import Flutter
import UIKit
import Web3Auth
import FetchNodeDetails

public class SwiftWeb3AuthFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "web3auth_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftWeb3AuthFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private func getNetwork(_ network: String) -> Web3AuthNetwork {
        switch network {
        case "mainnet":
            return .MAINNET
        case "testnet":
            return .TESTNET
        case "aqua":
            return .AQUA
        case "cyan":
            return .CYAN
        case "sapphire_devnet":
            return .SAPPHIRE_DEVNET
        case "sapphire_mainnet":
            return .SAPPHIRE_MAINNET
        default:
            return .SAPPHIRE_MAINNET
        }
    }

    var web3auth: Web3Auth?
    public var web3AuthResponse: Web3AuthResponse? {
        return web3auth?.web3AuthResponse
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
                var options: Web3AuthOptions
                //print("RAW INIT DATA:", String(data: data, encoding: .utf8) ?? "Invalid UTF8")
                do {
                    let params = try decoder.decode(InitParams.self, from: data)
                    let network = getNetwork(params.network)
                    let buildEnv: BuildEnv = BuildEnv(rawValue: params.authBuildEnv ?? "production") ?? .production
                    options = Web3AuthOptions(
                        clientId: params.clientId,
                        redirectUrl: params.redirectUrl,
                        originData: params.originData,
                        authBuildEnv: buildEnv,
                        sdkUrl: params.sdkUrl,
                        storageServerUrl: params.storageServerUrl,
                        sessionSocketUrl: params.sessionSocketUrl,
                        authConnectionConfig: params.authConnectionConfig,
                        whiteLabel: params.whiteLabel,
                        dashboardUrl: params.dashboardUrl,
                        accountAbstractionConfig: params.accountAbstractionConfig,
                        walletSdkUrl: params.walletSdkUrl,
                        includeUserDataInToken: params.includeUserDataInToken ?? true,
                        chains: params.chains,
                        defaultChainId: params.defaultChainId ?? "0x1",
                        enableLogging: params.enableLogging ?? false,
                        sessionTime: params.sessionTime ?? 30 * 86400,
                        web3AuthNetwork: network,
                        useSFAKey: params.useSFAKey ?? false,
                        walletServicesConfig: params.walletServicesConfig,
                        mfaSettings: params.mfaSettings
                    )

                    options.setFlutterAnalytics(params.isFlutterAnalytics ?? true, sdkVersion: params.sdkVersion)
                } catch {
                    // print(error)
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Flutter decode init params",
                        details: data))
                    return
                }
                do {
                    let web3auth = try await Web3Auth(options: options)
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
            case "connectTo":
                guard let web3auth = web3auth
                else {
                    result(FlutterError(
                        code: "NotInitializedException",
                        message: "Web3Auth.init has to be called first",
                        details: nil))
                    return
                }
                let loginParams: LoginParams
                do {
                    loginParams = try decoder.decode(LoginParams.self, from: data)
                    print("loginParams: \(loginParams)")
                } catch {
                    print(error)
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid Login Params",
                        details: nil))
                    return
                }
                var resultMap: String = ""
                do {
                    let result = try await web3auth.connectTo(loginParams: loginParams)
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
            case "getPrivateKey":
                let privKey = web3auth?.getPrivateKey()
                result(privKey)
                return
            case "getEd25519PrivateKey":
                let getEd25519PrivKey = try? web3auth?.getEd25519PrivateKey()
                result(getEd25519PrivKey)
                return
            case "showWalletUI":
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
                
                do {
                    try await web3auth?.showWalletUI(path: wsParams.path)
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
                    let loginParams = try? decoder.decode(LoginParams.self, from: data)

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
                    let loginParams = try? decoder.decode(LoginParams.self, from: data)

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
    let path: String?
}

struct RequestJson: Codable {
    let method: String
    let requestParams: [String]
    let path: String?
    let appState: String?
}

struct InitParams: Codable {
    let clientId: String
    let redirectUrl: String
    let originData: [String: String]?
    let authBuildEnv: String?
    let sdkUrl: String?
    let storageServerUrl: String?
    let sessionSocketUrl: String?
    let authConnectionConfig: [AuthConnectionConfig]?
    let whiteLabel: WhiteLabelData?
    let dashboardUrl: String?
    let accountAbstractionConfig: String?
    let walletSdkUrl: String?
    let sessionNamespace: String?
    let includeUserDataInToken: Bool?
    let chains: [Chains]?
    let defaultChainId: String?
    let enableLogging: Bool?
    let sessionTime: Int?
    let network: String
    let useSFAKey: Bool?
    let walletServicesConfig: WalletServicesConfig?
    let mfaSettings: MfaSettings?
    let isFlutterAnalytics: Bool?
    let sdkVersion: String?
}
