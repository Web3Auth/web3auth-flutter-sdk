import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '';
  bool logoutVisible = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#229954";

    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse(
          'torusapp://org.torusresearch.flutter.web3authexample/auth');
    } else if (Platform.isIOS) {
      redirectUrl =
          Uri.parse('com.web3auth.flutter.web3authflutterexample://auth');
    } else {
      throw UnKnownException('Unknown platform');
    }

    final loginConfig = HashMap<String, LoginConfigItem>();
    loginConfig['jwt'] = LoginConfigItem(
        verifier: "web3auth-auth0-email-passwordless-sapphire-devnet",
        // get it from web3auth dashboard
        typeOfLogin: TypeOfLogin.jwt,
        clientId: "d84f6xvbdV75VTGmHiMWfZLeSPk8M07C" // auth0 client id
        );

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId:
            'BHgArYmWwSeq21czpcarYh0EVq2WWOzflX-NTK-tY1-1pauPzHKRRLgpABkmYiIV_og9jAvoIxQ8L3Smrwe04Lw',
        sdkUrl: 'https://auth.mocaverse.xyz',
        walletSdkUrl: 'https://lrc-mocaverse.web3auth.io',
          network: Network.sapphire_devnet,
          buildEnv: BuildEnv.production,
          redirectUrl: redirectUrl,
          whiteLabel: WhiteLabelData(
            mode: ThemeModes.dark,
            defaultLanguage: Language.en,
            appName: "Web3Auth Flutter App",
            theme: themeMap,
          ),
          loginConfig: loginConfig,
          chainConfig: ChainConfig(
              chainId: "0x1",
              rpcTarget:
                  "https://mainnet.infura.io/v3/daeee53504be4cd3a997d4f2718d33e0",
              ticker: "ETH")),
    );

    await Web3AuthFlutter.initialize();

    final Web3AuthResponse res = await Web3AuthFlutter.getWeb3AuthResponse();
    if (res.privKey!.isNotEmpty || res.factorKey!.isNotEmpty) {
      setState(() {
        logoutVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Web3Auth x Flutter Example'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Visibility(
                visible: !logoutVisible,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Icon(
                      Icons.flutter_dash,
                      size: 80,
                      color: Color(0xFF1389fd),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Web3Auth',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: Color(0xFF0364ff)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Welcome to Web3Auth x Flutter Demo',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Login with',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _login(_withGoogle),
                      child: const Text('Google'),
                    ),
                    ElevatedButton(
                      onPressed: _login(_withFacebook),
                      child: const Text('Facebook'),
                    ),
                    ElevatedButton(
                      onPressed: _login(_withEmailPasswordless),
                      child: const Text('Email Passwordless'),
                    ),
                    ElevatedButton(
                      onPressed: _login(_withDiscord),
                      child: const Text('Discord'),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: logoutVisible,
                child: Column(
                  children: [
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red[600] // This is what you need!
                              ),
                          onPressed: _logout(),
                          child: const Column(
                            children: [
                              Text('Logout'),
                            ],
                          )),
                    ),
                    ElevatedButton(
                      onPressed: _privKey(_getPrivKey),
                      child: const Text('Get PrivKey'),
                    ),
                    ElevatedButton(
                      onPressed: _userInfo(_getUserInfo),
                      child: const Text('Get UserInfo'),
                    ),
                    ElevatedButton(
                        onPressed: _launchWalletServices(),
                        child: const Text('Launch Wallet Services')),
                    ElevatedButton(
                        onPressed: _setupMFA(), child: const Text('Setup MFA')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_result),
              )
            ],
          )),
        ),
      ),
    );
  }

  VoidCallback _login(Future<Web3AuthResponse> Function() method) {
    return () async {
      try {
        final Web3AuthResponse _ = await method();
        setState(() {
          logoutVisible = true;
        });
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  VoidCallback _logout() {
    return () async {
      try {
        await Web3AuthFlutter.logout();
        setState(() {
          _result = '';
          logoutVisible = false;
        });
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  VoidCallback _privKey(Future<String?> Function() method) {
    return () async {
      try {
        final String response = await Web3AuthFlutter.getPrivKey();
        setState(() {
          _result = response;
          logoutVisible = true;
        });
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  VoidCallback _userInfo(Future<TorusUserInfo> Function() method) {
    return () async {
      try {
        final TorusUserInfo response = await Web3AuthFlutter.getUserInfo();
        setState(() {
          _result = response.toString();
          logoutVisible = true;
        });
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  Future<Web3AuthResponse> _withGoogle() {
    return Web3AuthFlutter.login(
      LoginParams(loginProvider: Provider.google, mfaLevel: MFALevel.NONE),
    );
  }

  Future<Web3AuthResponse> _withFacebook() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.facebook));
  }

  Future<Web3AuthResponse> _withEmailPasswordless() {
    return Web3AuthFlutter.login(
      LoginParams(
        loginProvider: Provider.email_passwordless,
        extraLoginOptions: ExtraLoginOptions(
          login_hint: "testtkey@gmail.com",
        ),
      ),
    );
  }

  Future<Web3AuthResponse> _withDiscord() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.discord));
  }

  Future<String?> _getPrivKey() {
    return Web3AuthFlutter.getPrivKey();
  }

  Future<TorusUserInfo> _getUserInfo() {
    return Web3AuthFlutter.getUserInfo();
  }

  VoidCallback _launchWalletServices() {
    return () async {
      try {
        await Web3AuthFlutter.launchWalletServices(
            LoginParams(loginProvider: Provider.google));
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  VoidCallback _setupMFA() {
    return () async {
      try {
        await Web3AuthFlutter.setupMFA(LoginParams(
            loginProvider: Provider.google, mfaLevel: MFALevel.MANDATORY));
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }
}
