import Flutter
import UIKit
import Web3Auth

public class SwiftWeb3AuthFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "web3auth_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftWeb3AuthFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
    var initParams: W3AInitParams? = nil

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      guard let args = call.arguments as? Dictionary<String, Any> else {
          result(FlutterError(
                  code: "INVALID_ARGUMENTS",
                  message: "Invalid Flutter iOS plugin method arguments",
                  details: nil))
          return
      }
      switch call.method {
      case "init":
          guard
            let clientId = args["clientId"] as? String,
            let network = args["network"] as? String
          else {
              result(FlutterError(
                      code: "MISSING_ARGUMENTS",
                      message: "Missing init arguments",
                      details: nil))
              return
          }
          self.initParams = W3AInitParams(clientId: clientId, network: Network(rawValue: network) ?? .testnet)
          result(nil)
          return
      case "triggerLogin":
          guard let initParams = self.initParams
          else {
              result(FlutterError(
                      code: "NotInitializedException",
                      message: "Web3Auth.init has to be called first",
                      details: nil))
              return
          }
          let loginParams = mapLoginParams(args)
          let web3auth = Web3Auth(initParams)
          web3auth.login(loginParams) {
              switch $0 {
              case .success(let state):
                  let map: [String: Any] = [
                    "privateKey": state.privKey,
                    "userInfo": [
                        "email": state.userInfo.email,
                        "name": state.userInfo.name,
                        "profileImage": state.userInfo.profileImage,
                        "verifier": state.userInfo.verifier,
                        "verifierId": state.userInfo.verifierId,
                        "typeOfLogin": state.userInfo.typeOfLogin
                    ]
                  ]
                  result(map)
                  return
              case .failure(let error):
                  result(FlutterError(
                    code: "LoginFailedException",
                    message: "Web3Auth login flow failed",
                    details: error.localizedDescription
                  ))
                  return
              }
          }
      case "triggerLogout":
          print("Web3Auth.logout has been called, this operation is a no-op on iOS.")
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}

func getWeb3AuthNetwork(_ networkStr: String) -> Network {
    if networkStr == "mainnet"{
        return .mainnet
    }
    return .testnet
}

func getWeb3AuthProvider(_ providerStr: String) -> Web3AuthProvider {
    switch providerStr {
    case "google":
        return .GOOGLE
    case "facebook":
        return .FACEBOOK
    case "reddit":
        return .REDDIT
    case "discord":
        return .DISCORD
    case "twitch":
        return .TWITCH
    case "apple":
        return .APPLE
    case "line":
        return .LINE
    case "github":
        return .GITHUB
    case "kakao":
        return .KAKAO
    case "linkedin":
        return .LINKEDIN
    case "twitter":
        return .TWITTER
    case "weibo":
        return .WEIBO
    case "wechat":
        return .WECHAT
    case "email_passwordless":
        return .EMAIL_PASSWORDLESS
    default:
        return .GOOGLE
    }
}

func mapLoginParams(_ args: Dictionary<String, Any>) -> W3ALoginParams {
    let extraLoginOptions: ExtraLoginOptions = ExtraLoginOptions(
        display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: args["id_token_hint"] as? String, login_hint: args["login_hint"] as? String, acr_values: nil, scope: nil, audience: nil, connection: args["connection"] as? String, domain: args["domain"] as? String, client_id: args["client_id"] as? String, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil
    )
    
    return W3ALoginParams(loginProvider: getWeb3AuthProvider(args["provider"] as! String).rawValue, relogin: args["reLogin"] as? Bool, skipTKey: args["skipTKey"] as? Bool, extraLoginOptions: extraLoginOptions, redirectUrl: args["redirectUrl"] as? String, appState: args["appState"] as? String)
}
