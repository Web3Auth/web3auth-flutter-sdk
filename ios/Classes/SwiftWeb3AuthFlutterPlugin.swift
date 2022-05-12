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
          let whiteLabelData = mapWhiteLabelData(args["white_label_data"] as? Dictionary<String, Any>)
          let loginConfig = mapLoginConfig(args["login_config"] as? Dictionary<String, Any>)
          self.initParams = W3AInitParams(
            clientId: clientId,
            network: Network(rawValue: network) ?? .mainnet,
            loginConfig: loginConfig,
            whiteLabel: whiteLabelData
          )
          result(nil)
          return
      case "login":
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
                        "dappShare": state.userInfo.dappShare,
                        "profileImage": state.userInfo.profileImage,
                        "verifier": state.userInfo.verifier,
                        "verifierId": state.userInfo.verifierId,
                        "typeOfLogin": state.userInfo.typeOfLogin,
                        "aggregateVerifier": state.userInfo.aggregateVerifier,
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
      case "logout":
          print("Web3Auth.logout has been called, this operation is a no-op on iOS.")
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}

func getWeb3AuthNetwork(_ networkStr: String) -> Network {
    if networkStr.lowercased() == "mainnet" {
        return .mainnet
    }
    if networkStr.lowercased() == "testnet" {
        return .testnet
    }
    if networkStr.lowercased() == "cyan" {
        return .cyan
    }
    return .mainnet
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

func getMfaLevel(_ mfaLevel: String?) -> MFALevel {
    let mfaLevelStr = mfaLevel?.lowercased()
    switch mfaLevelStr {
    case "none":
        return .NONE
    case "default":
        return .DEFAULT
    case "mandatory":
        return .MANDATORY
    case "optional":
        return .OPTIONAL
    default:
        return .DEFAULT
    }
}

func getW3ATypeOfLogin(_ providerStr: String?) -> TypeOfLogin? {
    guard let providerStr = providerStr else {
        return nil
    }
    switch providerStr {
    case "google":
        return .google
    case "facebook":
        return .facebook
    case "reddit":
        return .reddit
    case "discord":
        return .discord
    case "twitch":
        return .twitch
    case "github":
        return .github
    case "apple":
        return .apple
    case "linkedin":
        return .linkedin
    case "twitter":
        return .twitter
    case "weibo":
        return .weibo
    case "line":
        return .line
    case "email_password":
        return .email_password
    case "jwt":
        return .jwt
    default:
        return nil
    }
}

func mapLoginParams(_ args: Dictionary<String, Any>) -> W3ALoginParams {
    let extraLoginOptions: ExtraLoginOptions = ExtraLoginOptions(
        display: args["display"] as? String,
        prompt: args["prompt"] as? String,
        max_age: args["max_age"] as? String,
        ui_locales: args["ui_locales"] as? String,
        id_token_hint: args["id_token_hint"] as? String, id_token: args["id_token"] as? String,
        login_hint: args["login_hint"] as? String,
        acr_values: args["acr_values"] as? String,
        scope: args["scope"] as? String,
        audience: args["audience"] as? String,
        connection: args["connection"] as? String,
        domain: args["domain"] as? String,
        client_id: args["client_id"] as? String,
        redirect_uri: args["id_token_hint"] as? String,
        leeway: args["leeway"] as? Int,
        verifierIdField: args["verifierIdField"] as? String,
        isVerifierIdCaseSensitive: args["isVerifierIdCaseSensitive"] as? Bool
    )
    
    return W3ALoginParams(
        loginProvider: getWeb3AuthProvider(args["provider"] as! String).rawValue,
        relogin: args["reLogin"] as? Bool,
        dappShare: args["dappShare"] as? String,
        extraLoginOptions: extraLoginOptions,
        redirectUrl: args["redirectUrl"] as? String,
        appState: args["appState"] as? String,
        mfaLevel : getMfaLevel(args["mfaLevel"] as? String)
    )
}

func mapWhiteLabelData(_ args: Dictionary<String, Any>?) -> W3AWhiteLabelData? {
    guard
        let args = args
    else {
        return nil
    }
    let whiteLabelData: W3AWhiteLabelData = W3AWhiteLabelData(
        name: args["name"] as? String,
        logoLight: args["logoLight"] as? String,
        logoDark: args["logoDark"] as? String,
        defaultLanguage: args["defaultLanguage"] as? String,
        dark: args["dark"] as? Bool,
        theme: args["theme"] as? Dictionary<String, String>
    )
    return whiteLabelData
}

func mapLoginConfig(_ args: Dictionary<String, Any>?) -> [String: W3ALoginConfig]? {
    guard let args = args else {
        return nil
    }
    var ret: [String: W3ALoginConfig] = [:]
    for (k, v) in args {
       ret[k] = mapLoginConfigItem(v as? Dictionary<String, Any>)!
    }
    return ret
}

func mapLoginConfigItem(_ args: Dictionary<String, Any>?) -> W3ALoginConfig? {
    guard
        let args = args
    else{
        return nil
    }
    return W3ALoginConfig(
        verifier: args["verifier"] as! String,
        typeOfLogin: getW3ATypeOfLogin(args["typeOfLogin"] as? String) ?? .jwt,
        name: args["verifier"] as! String,
        description: args["description"] as? String,
        clientId: args["clientId"] as? String,
        verifierSubIdentifier: args["verifierSubIdentifier"] as? String,
        logoHover: args["logoHover"] as? String,
        logoLight: args["logoLight"] as? String,
        logoDark: args["logoDark"] as? String,
        mainOption: args["mainOption"] as? Bool,
        showOnModal: args["showOnModal"] as? Bool,
        showOnDesktop: args["showOnDesktop"] as? Bool,
        showOnMobile: args["showOnMobile"] as? Bool
    )
    
}
