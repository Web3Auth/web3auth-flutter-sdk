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
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(call, "calling args")
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
                print(initParams, "params")
            } catch {
                print(error)
                result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Flutter iOS plugin init params",
                        details: nil))
                return
            }
            // self.initParams = W3AInitParams(
            //     clientId: clientId,
            //     network: Network(rawValue: network) ?? .mainnet,
            //     loginConfig: loginConfig,
            //     whiteLabel: whiteLabelData
            // )
            let web3auth = Web3Auth(initParams)
            self.web3auth = web3auth
            result(nil)
            return
        case "login":
            guard let web3auth = self.web3auth
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
            print(loginParams, "login params")

            web3auth.login(loginParams) {
                switch $0 {
                case .success(let state):
                    var resultMap: String = ""
                    do {
                        let resultData = try self.encoder.encode(state)
                        resultMap = String(decoding: resultData, as: UTF8.self)
                    } catch {
                        print(error)
                        result(FlutterError(
                            code: "INVALID_ARGUMENTS",
                            message: "Web3Auth login flow failed",
                            details: error.localizedDescription
                        ))
                    }
                    result(resultMap)
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
            //            self.web3auth.logout()
            print("unhandled")
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
