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
    public var state: Web3AuthState?{
        return web3auth?.state
    }
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task{
            debugPrint(call, "calling args")
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
            switch call.method {
            case "init":
                let initParams: W3AInitParams
                do {
                    initParams = try decoder.decode(W3AInitParams.self, from: data)
                    debugPrint(initParams, "params")
                } catch {
                    debugPrint(error)
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Flutter iOS plugin init params",
                        details: nil))
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
            case "getPrivKey":
                let privKey: String = ""
                do {
                    privKey = try await web3auth?.getPrivKey()
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
                let getEd25519PrivKey: String = ""
                do {
                    getEd25519PrivKey = try await web3auth?.getEd25519PrivKey()
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
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
