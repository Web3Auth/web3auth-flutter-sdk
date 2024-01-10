package com.web3auth.flutter.web3auth_flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.web3auth.core.Web3Auth
import com.web3auth.core.types.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject


class Web3AuthFlutterPlugin : FlutterPlugin, ActivityAware, MethodCallHandler,
    PluginRegistry.NewIntentListener {
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null
    private lateinit var context: Context
    private lateinit var web3auth: Web3Auth
    private var gson: Gson = Gson()

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

    override fun onNewIntent(intent: Intent): Boolean {
        if (this::web3auth.isInitialized) {
            web3auth.setResultUrl(intent.data)
        }
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
                    result.error("error", e.message, e.localizedMessage)
                }
            }
        }
    }

    private fun runMethodCall(@NonNull call: MethodCall): Any? {
        when (call.method) {
            "init" -> {
                val initArgs = call.arguments<String>() ?: return null
                val initParams = gson.fromJson(initArgs, Web3AuthOptions::class.java)
                // handle custom parameters which are gson excluded
                val obj = JSONObject(initArgs)
                if (obj.has("redirectUrl")) initParams.redirectUrl = Uri.parse(obj.get("redirectUrl") as String?)
                initParams.context = activity!!
                // Log.d(initParams.toString(), "#initParams")
                web3auth = Web3Auth(
                    initParams
                )

                web3auth.setResultUrl(activity?.intent?.data)

                Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#init")
                return null
            }

            "login" -> {
                try {
                    val loginArgs = call.arguments<String>() ?: return null
                    val loginParams = gson.fromJson(loginArgs, LoginParams::class.java)
                    val obj = JSONObject(loginArgs)
                    if (obj.has("redirectUrl")) loginParams.redirectUrl = Uri.parse(obj.get("redirectUrl") as String?)
                    val loginCF = web3auth.login(loginParams)
                    // Log.d(loginParams.toString(), "#loginParams")
                    Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#login")
                    val loginResult: Web3AuthResponse = loginCF.get()
                    return gson.toJson(loginResult)
                } catch (e: NotImplementedError) {
                    throw Error(e)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "logout" -> {
                try {
                    val logoutCF = web3auth.logout()
                    Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#logout")
                    logoutCF.get()
                    return null
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "initialize" -> {
                try {
                    val initializeCF = web3auth.initialize()
                    Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#initialize")
                    initializeCF.get()
                    return null
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "getPrivKey" -> {
                val privKey = web3auth.getPrivkey()
                Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#getPrivKey")
                return privKey
            }

            "getEd25519PrivKey" -> {
                val ed25519Key = web3auth.getEd25519PrivKey()
                Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#getEd25519PrivKey")
                return ed25519Key
            }

            "getUserInfo" -> {
                try {
                    val userInfoResult = web3auth.getUserInfo()
                    Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#getUserInfo")
                    if (userInfoResult == null) {
                        throw Error(Web3AuthError.getError(ErrorCode.NOUSERFOUND))
                    }
                    return gson.toJson(userInfoResult)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "launchWalletServices" -> {
                try {
                    Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#launchWalletServices")
                    val loginArgs = call.arguments<String>() ?: return null
                    val loginParams = gson.fromJson(loginArgs, LoginParams::class.java)
                    Log.d(loginParams.toString(), "#loginParams")
                    val obj = JSONObject(loginArgs)
                    if (obj.has("redirectUrl")) loginParams.redirectUrl =
                        Uri.parse(obj.get("redirectUrl") as String?)
                    val launchWalletCF = web3auth.launchWalletServices(loginParams)
                    Log.d(
                        "${Web3AuthFlutterPlugin::class.qualifiedName}",
                        "#launchWalletServices_1"
                    )
                    launchWalletCF.get()
                    return null
                } catch (e: NotImplementedError) {
                    throw Error(e)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "setupMFA" -> {
                try {
                    val loginArgs = call.arguments<String>() ?: return null
                    val loginParams = gson.fromJson(loginArgs, LoginParams::class.java)
                    val obj = JSONObject(loginArgs)
                    if (obj.has("redirectUrl")) loginParams.redirectUrl =
                        Uri.parse(obj.get("redirectUrl") as String?)
                    val setupMfaCF = web3auth.setupMFA(loginParams)
                    Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#setupMFA")
                    return setupMfaCF.get()
                } catch (e: NotImplementedError) {
                    throw Error(e)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

        }
        throw NotImplementedError()
    }
}
