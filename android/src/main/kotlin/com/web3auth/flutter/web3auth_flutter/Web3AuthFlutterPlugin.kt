package com.web3auth.flutter.web3auth_flutter

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import com.google.gson.Gson
import com.web3auth.flutter.web3auth_flutter.types.LoginConfig
import com.web3auth.flutter.web3auth_flutter.types.WLData
import com.web3auth.core.Web3Auth
import com.web3auth.core.types.*

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Error


class Web3AuthFlutterPlugin: FlutterPlugin, ActivityAware, MethodCallHandler, PluginRegistry.NewIntentListener {
  private lateinit var channel: MethodChannel

  private var activity: Activity? = null
  private lateinit var context: Context
  private lateinit var web3auth: Web3Auth

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "web3auth_flutter")
    channel.setMethodCallHandler(this)
    context = binding.applicationContext
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onNewIntent(intent: Intent) : Boolean {
    web3auth.setResultUrl(intent.data)
    return true
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    CoroutineScope(Dispatchers.Default).launch {
      try {
        val response = runMethodCall(call)
        launch(Dispatchers.Main) { result.success(response) }
      } catch (e: NotImplementedError) {
        launch(Dispatchers.Main) { result.notImplemented() }
      } catch (e: Throwable) {
        launch(Dispatchers.Main) {
          result.error("error",e.message, e.localizedMessage)
        }
      }
    }
  }

  private fun runMethodCall(@NonNull call: MethodCall): Any? {
    when (call.method) {
      "init" -> {
        val whiteLabelData = mapWhiteLabelData(call)
        val loginConfig = mapLoginConfigItem(call)
        web3auth = Web3Auth(
          Web3AuthOptions(
                activity!!,
                call.argument("clientId")!!,
                getWeb3AuthNetwork(call.argument("network")),
                Uri.parse(call.argument("redirectUri")),
                whiteLabel = whiteLabelData,
                loginConfig = loginConfig
          )
        )

        web3auth.setResultUrl(activity?.intent?.data)

        Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}","#init")
        return null
      }

      "login" -> {

        val loginCF = web3auth.login(mapLoginParams(call))
        loginCF.join()
        Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}","#login")

        var loginResult : Map<String, Any?>? = null
        loginCF.whenComplete { result, error ->
          if (error != null) {
            throw Error(error)
          } else {
            loginResult =  mapOf(
                    "privateKey" to result.privKey,
                    "userInfo" to listOf(mapOf(
                            "email" to result.userInfo?.email,
                            "name" to result.userInfo?.name,
                            "dappShare" to result.userInfo?.dappShare,
                            "profileImage" to result.userInfo?.profileImage,
                            "aggregateVerifier" to result.userInfo?.aggregateVerifier,
                            "verifier" to result.userInfo?.verifier,
                            "verifierId" to result.userInfo?.verifierId,
                            "typeOfLogin" to result.userInfo?.typeOfLogin
                    ))
            )
          }
        }
        return loginResult
      }

      "logout" -> {
        val logoutCF = web3auth.logout()
        logoutCF.join()
        Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}","#logout")

        logoutCF.whenComplete { _, error ->
          if (error != null) {
            throw Error(error)
          }
        }
        return null
      }
    }
    throw NotImplementedError()
  }

  private fun getWeb3AuthProvider(provider: String): Provider {
    return when (provider) {
      "google" -> Provider.GOOGLE
      "facebook" -> Provider.FACEBOOK
      "reddit" -> Provider.REDDIT
      "discord" -> Provider.DISCORD
      "twitch" -> Provider.TWITCH
      "apple" -> Provider.APPLE
      "line" -> Provider.LINE
      "github" -> Provider.GITHUB
      "kakao" -> Provider.KAKAO
      "linkedin" -> Provider.LINKEDIN
      "twitter" -> Provider.TWITTER
      "weibo" -> Provider.WEIBO
      "wechat" -> Provider.WECHAT
      "email_passwordless" -> Provider.EMAIL_PASSWORDLESS
      "jwt" -> Provider.JWT

      else -> throw Exception("Provider is required")
    }
  }

  private fun getWeb3AuthNetwork(network : String?) : Web3Auth.Network {
    return when {
        network.isNullOrBlank() -> Web3Auth.Network.MAINNET
        network.equals("mainnet", true) -> Web3Auth.Network.MAINNET
        network.equals("testnet", true) -> Web3Auth.Network.TESTNET
        network.equals("cyan", true) -> Web3Auth.Network.CYAN
        else -> Web3Auth.Network.MAINNET
    }
  }

  private fun mapWhiteLabelData(call: MethodCall) : WhiteLabelData? {
    val wlData : String? = call.argument("white_label_data")
    if (wlData.isNullOrBlank()) return null
    return Gson().fromJson(wlData, WLData::class.java).toWhiteLabelData()
  }

  private fun mapLoginConfigItem(call : MethodCall) : HashMap<String, LoginConfigItem>? {
    val loginConfig : String? = call.argument("login_config")
    if (loginConfig.isNullOrBlank() || loginConfig == "null") return null
    return Gson().fromJson(loginConfig, LoginConfig::class.java).toLoginConfig()
  }

  private fun mapLoginParams(call : MethodCall) : LoginParams {
    val provider: String = call.argument("provider") ?: ""
    val appState: String? = call.argument("appState")
    val dappShare: String? = call.argument("dappShare")
    val relogin: Boolean? = call.argument("relogin")
    val redirectUrlStr: String? = call.argument("redirectUrl")
    val redirectUrl: Uri? = redirectUrlStr?.let { Uri.parse(redirectUrlStr) }

    val additionalParams: Map<String, String>? = call.argument("additionalParams")
    val client_id: String? = call.argument("client_id")
    val connection: String? = call.argument("connection")
    val domain: String? = call.argument("domain")
    val id_token_hint: String? = call.argument("id_token_hint")
    val login_hint : String? = call.argument("login_hint")
    val leeway : String? = call.argument("leeway")
    val verifierIdField : String? = call.argument("verifierIdField")
    val isVerifierIdCaseSensitive : Boolean? = call.argument("isVerifierIdCaseSensitive")
    val displayStr : String? = call.argument("display")
    val promptStr : String? = call.argument("prompt")
    val max_age : String? = call.argument("max_age")
    val ui_locales : String? = call.argument("ui_locales")
    val acr_values : String? = call.argument("acr_values")
    val scope : String? = call.argument("scope")
    val audience : String? = call.argument("audience")
    val state : String? = call.argument("state")
    val response_type : String? = call.argument("response_type")
    val nonce : String? = call.argument("nonce")
    val redirect_uri : String? = call.argument("redirect_uri")

    val extraLoginOptions = ExtraLoginOptions(client_id = client_id,
            connection = connection,
            additionalParams = additionalParams as HashMap<String, String>?,
            domain = domain,
            leeway = leeway,
            verifierIdField = verifierIdField,
            isVerifierIdCaseSensitive = isVerifierIdCaseSensitive,
            display = getDisplay(displayStr),
            prompt = getPrompt(promptStr),
            max_age = max_age,
            ui_locales = ui_locales,
            acr_values = acr_values,
            scope = scope,
            audience = audience,
            state = state,
            response_type = response_type,
            nonce = nonce,
            redirect_uri = redirect_uri,
            id_token_hint = id_token_hint,
            login_hint = login_hint)

    return LoginParams(getWeb3AuthProvider(provider),
            appState = appState,
            dappShare = dappShare,
            relogin = relogin,
            redirectUrl = redirectUrl,
            extraLoginOptions = extraLoginOptions,
    )
  }

  private fun getDisplay(display : String?) : Display? {
    return when {
      display.isNullOrBlank() -> null
      display.equals("page", true) -> Display.PAGE
      display.equals("popup", true) -> Display.POPUP
      display.equals("touch", true) -> Display.TOUCH
      display.equals("wap", true) -> Display.WAP
      else -> null
    }
  }

  private fun getPrompt(prompt : String?) : Prompt? {
    return when {
      prompt.isNullOrBlank() -> null
      prompt.equals("none", true) -> Prompt.NONE
      prompt.equals("login", true) -> Prompt.LOGIN
      prompt.equals("consent", true) -> Prompt.CONSENT
      prompt.equals("select_account", true) -> Prompt.SELECT_ACCOUNT
      else -> null
    }
  }
}
