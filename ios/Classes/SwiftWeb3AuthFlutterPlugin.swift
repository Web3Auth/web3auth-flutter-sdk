import Flutter
import UIKit
import Web3Auth

public class SwiftWeb3AuthFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "web3auth_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftWeb3AuthFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    var web3auth: Web3Auth?
    public var state: Web3AuthState? {
        return web3auth?.state
    }
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task {
            // print(call, "calling args")
            guard let args = call.arguments as? String else {
                result(FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Invalid Flutter iOS plugin method arguments",
                    details: nil))
                return
            }
            guard let data = args.data(using: .utf8) else {
                result(FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Invalid Flutter iOS plugin init params",
                    details: nil))
                return
            }
            // print("call data", data)
            switch call.method {
            case "init":
                let initParams: W3AInitParams
                do {
                    initParams = try decoder.decode(W3AInitParams.self, from: data)
                    // print(initParams, "params")
                } catch {
                    // print(error)
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Flutter decode init params",
                        details: data))
                    return
                }
                let web3auth = await Web3Auth(initParams)
                self.web3auth = web3auth
                result(nil)
                return
            case "login":
                guard let web3auth = web3auth
                else {
                    result(FlutterError(
                        code: "NotInitializedException",
                        message: "Web3Auth.init has to be called first",
                        details: nil))
                    return
                }
                let loginParams: W3ALoginParams
                do {
                    loginParams = try decoder.decode(W3ALoginParams.self, from: data)
                } catch {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Login Params",
                        details: nil))
                    return
                }
                var resultMap: String = ""
                do {
                    let result = try await web3auth.login(loginParams)
                    let resultData = try encoder.encode(result)
                    resultMap = String(decoding: resultData, as: UTF8.self)
                } catch {
                    result(FlutterError(
                        code: "LoginFailedException",
                        message: "Web3Auth login flow failed",
                        details: error.localizedDescription
                    ))
                    return
                }
                result(resultMap)
                return
            case "logout":
                do {
                    try await web3auth?.logout()
                    result(nil)
                    return
                } catch {
                    result(FlutterError(
                        code: "LogoutFailedException",
                        message: "Web3Auth logout failed",
                        details: error.localizedDescription
                    ))
                    return
                }
            case "initialize":
                do {
                    // There is no initialize function in swift
                    result(nil)
                    return
                } catch {
                    result(FlutterError(
                        code: "InitializeFailedException",
                        message: "Web3Auth initialize failed",
                        details: error.localizedDescription
                    ))
                    return
                }
            case "getPrivKey":
                do {
                    let privKey = try web3auth?.getPrivkey()
                    result(privKey)
                    return
                } catch {
                    result(FlutterError(
                        code: "GetPrivKeyFailedException",
                        message: "Web3Auth getPrivKey failed",
                        details: ""
                    ))
                    return
                }
            case "getEd25519PrivKey":
                do {
                    let getEd25519PrivKey = try web3auth?.getEd25519PrivKey()
                    result(getEd25519PrivKey)
                    return
                } catch {
                    result(FlutterError(
                        code: "GetEd25519PrivKeyFailedException",
                        message: "Web3Auth getEd25519PrivKey failed",
                        details: ""
                    ))
                    return
                }
            case "launchWalletServices":
                let wsParams: WalletServicesParams
                do {
                    wsParams = try decoder.decode(WalletServicesParams.self, from: data)
                } catch {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Wallet Services Params",
                        details: nil))
                        return
                }
                var resultMap: String = ""
                do {
                    try await web3auth?.launchWalletServices(wsParams.loginParams, wsParams.chainConfig, wsParams.path)
                    result(nil)
                    return
                } catch {
                     result(FlutterError(
                         code: "WalletServicesFailedFailedException",
                         message: "Web3Auth wallet services launch failed",
                         details: error.localizedDescription))
                     return
                }
            case "enableMFA":
                let loginParams: W3ALoginParams
                do {
                    loginParams = try decoder.decode(W3ALoginParams.self, from: data)
                } catch {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Login Params",
                        details: nil))
                    return
                }
                do {
                    let enableMFAResult = try await web3auth?.enableMFA()
                    result(enableMFAResult)
                    return
                } catch {
                    result(FlutterError(
                        code: "enableMFAFailedException",
                        message: "Web3Auth enableMFA failed",
                        details: ""))
                    return
                }
            case "signMessage":
                let signMsgParams: SignMessageJson
                    do {
                        signMsgParams = try decoder.decode(SignMessageJson.self, from: data)
                        } catch {
                        result(FlutterError(
                            code: "INVALID_ARGUMENTS",
                            message: "Invalid Sign Message Params",
                            details: nil))
                            return
                        }
                    var resultMap: String = ""
                    do {
                        try await web3auth?.signMessage(signMsgParams.loginParams, signMsgParams.method, signMsgParams.requestParams, signMsgParams.path)
                        result(nil)
                        return
                    } catch {
                        result(FlutterError(
                            code: "MessageSigningFailedFailedException",
                            message: "Web3Auth sign message launch failed",
                            details: error.localizedDescription))
                            return
                    }
            case "getUserInfo":
                var resultMap: String = ""
                do {
                    let userInfo = try web3auth?.getUserInfo()
                    let resultData = try encoder.encode(userInfo)
                    resultMap = String(decoding: resultData, as: UTF8.self)
                } catch {
                    result(FlutterError(
                        code: "GetUserInfoFailedException",
                        message: "Web3Auth getUserInfo failed",
                        details: error.localizedDescription
                    ))
                    return
                }
                result(resultMap)
                return

            case "getWeb3AuthResponse":
                var resultMap: String = ""
                do {
                    let web3AuthResult = try web3auth?.getWeb3AuthResponse()
                    let resultData = try encoder.encode(web3AuthResult)
                    resultMap = String(decoding: resultData, as: UTF8.self)
                } catch {
                    result(FlutterError(
                        code: "GetWeb3AuthResponseFailedException",
                        message: "Web3Auth getUserInfo failed",
                        details: error.localizedDescription
                    ))
                    return
                }
                result(resultMap)
                return

            case "getSignResponse":
                var resultMap: String = ""
                do {
                    let signResponse = try Web3Auth?.getSignResponse()
                    let resultData = try encoder.encode(signResponse)
                    resultMap = String(decoding: resultData, as: UTF8.self)
                } catch {
                    result(FlutterError(
                        code: "GetSignResponseFailedException",
                        message: "Web3Auth getSignResponse failed",
                        details: error.localizedDescription
                    ))
                    return
                }
                result(resultMap)
                return

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

struct WalletServicesParams: Codable {
    let loginParams: W3ALoginParams
    let chainConfig: ChainConfig
    let path: String?

    public init(loginParams: W3ALoginParams, chainConfig: ChainConfig, path: String? = "wallet") {
        self.loginParams = loginParams
        self.chainConfig = chainConfig
        self.path = path
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        loginParams = try values.decodeIfPresent(W3ALoginParams.self, forKey: .loginParams) ?? W3ALoginParams(loginProvider: .GOOGLE)
        chainConfig = try values.decodeIfPresent(ChainConfig.self, forKey: .chainConfig) ?? ChainConfig(chainNamespace: ChainNamespace.eip155, chainId: "0x1",
                           rpcTarget: "", ticker: "ETH")
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }
}

struct SignMessageJson: Codable {
    let loginParams: LoginParams
    let method: String
    let requestParams: [Any?]
    let path: String?

    init(loginParams: LoginParams, method: String, requestParams: [Any?], path: String? = "wallet/request") {
        self.loginParams = loginParams
        self.method = method
        self.requestParams = requestParams
        self.path = path
    }

     public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        loginParams = try values.decodeIfPresent(W3ALoginParams.self, forKey: .loginParams) ?? W3ALoginParams(loginProvider: .GOOGLE)
        method = try values.decodeIfPresent(String.self, forKey: .method)
        requestParams = try values.decodeIfPresent([Any?].self, forKey: .requestParams)
        path = try values.decodeIfPresent(String.self, forKey: .path)
     }
}
