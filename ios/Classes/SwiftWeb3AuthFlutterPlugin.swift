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
                do {
                    let web3auth = try await Web3Auth(initParams)
                    self.web3auth = web3auth
                    result(nil)
                    return
                } catch {
                    result(FlutterError(
                        code: "InitFailedException",
                        message: "Web3Auth init failed",
                        details: error.localizedDescription))
                    return
                }
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
                    //print("loginParams: \(loginParams)")
                } catch {
                    //print(error)
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
                // There is no initialize function in swift
                result(nil)
                return
            case "getPrivKey":
                let privKey = web3auth?.getPrivkey()
                result(privKey)
                return
            case "getEd25519PrivKey":
                let getEd25519PrivKey = web3auth?.getEd25519PrivKey()
                result(getEd25519PrivKey)
                return
            case "launchWalletServices":
                let wsParams: WalletServicesParams
                do {
                    wsParams = try decoder.decode(WalletServicesParams.self, from: data)
                    print("chainConfig: \(wsParams.chainConfig)")
                } catch {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Wallet Services Params",
                        details: nil))
                        return
                }
                
                do {
                    try await web3auth?.launchWalletServices(chainConfig: wsParams.chainConfig, path: wsParams.path)
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
                do {
                    let loginParams = try? decoder.decode(W3ALoginParams.self, from: data)

                    if let params = loginParams {
                        let enableMFAResult = try await web3auth?.enableMFA(params)
                        result(enableMFAResult)
                    } else {
                        let enableMFAResult = try await web3auth?.enableMFA()
                        result(enableMFAResult)
                    }
                    return
                } catch {
                    result(FlutterError(
                        code: "enableMFAFailedException",
                        message: "Web3Auth enableMFA failed",
                        details: error.localizedDescription))
                    return
                }
            case "manageMFA":
                do {
                    let loginParams = try? decoder.decode(W3ALoginParams.self, from: data)

                    if let params = loginParams {
                        let manageMFAResult = try await web3auth?.manageMFA(params)
                        result(manageMFAResult)
                    } else {
                        let manageMFAResult = try await web3auth?.manageMFA()
                        result(manageMFAResult)
                    }
                    return
                } catch {
                    result(FlutterError(
                        code: "manageMFAFailedException",
                        message: "Web3Auth manageMFA failed",
                        details: error.localizedDescription))
                    return
                }
            case "request":
                let reqParams: RequestJson
                    do {
                        reqParams = try decoder.decode(RequestJson.self, from: data)
                        } catch {
                        result(FlutterError(
                            code: "INVALID_ARGUMENTS",
                            message: "Invalid request Params",
                            details: error.localizedDescription))
                            return
                        }
                
                    do {
                        let signResponse = try await web3auth?.request(
                            chainConfig: reqParams.chainConfig,
                            method: reqParams.method,
                            requestParams: reqParams.requestParams,
                            path: reqParams.path,
                            appState: reqParams.appState
                        )
                        let signData = try encoder.encode(signResponse)
                        let resultMap = String(decoding: signData, as: UTF8.self)
                        result(resultMap)
                        return
                    } catch {
                        result(FlutterError(
                            code: "RequestFailedFailedException",
                            message: "Web3Auth request launch failed",
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

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

struct WalletServicesParams: Codable {
    let chainConfig: ChainConfig
    let path: String?
}

struct RequestJson: Codable {
    let chainConfig: ChainConfig
    let method: String
    let requestParams: [String]
    let path: String?
    let appState: String?
}
