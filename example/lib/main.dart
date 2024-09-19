import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _result = '';
  bool logoutVisible = false;
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    textEditingController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    // This is important to trigger the user cancellation on Android.
    if (state == AppLifecycleState.resumed) {
      Web3AuthFlutter.setCustomTabsClosed();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#229954";

    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('torusapp://org.torusresearch.flutter.web3authexample');
    } else if (Platform.isIOS) {
      redirectUrl =
          Uri.parse('com.web3auth.flutter.web3authflutterexample://auth');
    } else {
      throw UnKnownException('Unknown platform');
    }

    final loginConfig = HashMap<String, LoginConfigItem>();
    loginConfig['jwt'] = LoginConfigItem(
        verifier: "w3a-auth0-demo", // get it from web3auth dashboard
        typeOfLogin: TypeOfLogin.jwt,
        clientId: "hUVVf4SEsZT7syOiL0gLU9hFEtm2gQ6O" // auth0 client id
        );

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId:
            'BHgArYmWwSeq21czpcarYh0EVq2WWOzflX-NTK-tY1-1pauPzHKRRLgpABkmYiIV_og9jAvoIxQ8L3Smrwe04Lw',
        //sdkUrl: 'https://auth.mocaverse.xyz',
        //walletSdkUrl: 'https://lrc-mocaverse.web3auth.io',
        network: Network.sapphire_devnet,
        buildEnv: BuildEnv.testing,
        redirectUrl: redirectUrl,
        whiteLabel: WhiteLabelData(
          mode: ThemeModes.dark,
          defaultLanguage: Language.en,
          appName: "Web3Auth Flutter App",
          theme: themeMap,
        ),
        loginConfig: loginConfig,
      ),
    );

    if (await Web3AuthFlutter.isSessionIdExists()) {
      await Web3AuthFlutter.initialize();
    }

    final String res = await Web3AuthFlutter.getPrivKey();
    log(res);
    if (res.isNotEmpty) {
      setState(() {
        logoutVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "abc@xyz.com",
                              ),
                            ),
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                            ),
                            onPressed: _logout(),
                            child: const Text('Logout'),
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
                            child: const Text('Launch Wallet Services'),
                          ),
                          ElevatedButton(
                            onPressed: _setupMFA(),
                            child: const Text('Setup MFA'),
                          ),
                          ElevatedButton(
                            onPressed: _signMesssage(),
                            child: const Text('Sign Message'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _getSignResponse(context);
                            },
                            child: const Text('Get Sign Response'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_result),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _getSignResponse(BuildContext context) async {
    try {
      final signResponse = await Web3AuthFlutter.getSignResponse();
      if (context.mounted) {
        showAlertDialog(
          context,
          'Sign Result',
          signResponse.toString(),
        );
      }
    } catch (e) {
      log(e.toString());
    }
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
      } catch (e) {
        log(e.toString());
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
          login_hint: textEditingController.text,
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
          ChainConfig(
            chainId: "0x89",
            rpcTarget:
                "https://mainnet.infura.io/v3/daeee53504be4cd3a997d4f2718d33e0",
          ),
        );
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  VoidCallback _setupMFA() {
    return () async {
      try {
        await Web3AuthFlutter.enableMFA();
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  VoidCallback _signMesssage() {
    return () async {
      try {
        String? privKey = await _getPrivKey();
        final credentials = EthPrivateKey.fromHex(privKey!);
        final address = credentials.address;
        List<dynamic> params = [];
        params.add("Hello, Web3Auth from Flutter!");
        params.add(address.hexEip55);
        params.add("Web3Auth");
        await Web3AuthFlutter.request(
          ChainConfig(chainId: "0x89", rpcTarget: "https://polygon-rpc.com/"),
          "personal_sign",
          params,
        );
      } on UserCancelledException {
        log("User cancelled.");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  void showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
