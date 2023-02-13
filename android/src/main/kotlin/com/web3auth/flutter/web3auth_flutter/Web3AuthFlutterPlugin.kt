package com.web3auth.flutter.web3auth_flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.google.gson.JsonObject
import org.json.JSONObject
import com.web3auth.core.Web3Auth
import com.web3auth.core.types.*
import com.web3auth.flutter.web3auth_flutter.types.LoginConfig
import com.web3auth.flutter.web3auth_flutter.types.WLData
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
        if(this::web3auth.isInitialized) {
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
                val redirectUrl = obj.get("redirectUrl")
                initParams.redirectUrl = Uri.parse(redirectUrl as String)
                initParams.sdkUrl = "https://sdk.openlogin.com"
                initParams.context = activity!!
                web3auth = Web3Auth(
                    initParams
                )

                web3auth.setResultUrl(activity?.intent?.data)

                Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#init")
                return null
            }

            "login" -> {
                val loginArgs = call.arguments<String>() ?: return null
                val loginParams = gson.fromJson(loginArgs, LoginParams::class.java)
                val loginCF = web3auth.login(loginParams)
                Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#login")
                loginCF.join()
                var loginResult: String? = null
                loginCF.whenComplete { result, error ->
                    if (error != null) {
                        throw Error(error)
                    } else {
                        loginResult = gson.toJson(result)
                    }
                }
                return loginResult
            }

            "logout" -> {
                val logoutCF = web3auth.logout()
                logoutCF.join()
                Log.d("${Web3AuthFlutterPlugin::class.qualifiedName}", "#logout")

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
}
