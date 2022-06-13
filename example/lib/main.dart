import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '<empty>';
  bool logoutVisible = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#fff000";

    await Web3AuthFlutter.init(
      clientId:
          'BEvzsPEkx0ir-DKwS4rJ9_Wf5FlZMTLaSlFuWN64wDlpqOkMI-gUSXUYN9JV-QZEt60dqlQOMD1oK9ZcOxbyfrc',
      network: Network.mainnet,
      redirectUri: 'org.torusresearch.flutter.web3authexample://auth',
      whiteLabelData: WhiteLabelData(
          dark: true, name: "Web3Auth Flutter App", theme: themeMap),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torus Web3Auth Example'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Login with'),
            ),
            ElevatedButton(
                onPressed: _login(_withGoogle), child: const Text('Google')),
            ElevatedButton(
                onPressed: _login(_withFacebook),
                child: const Text('Facebook')),
            ElevatedButton(
                onPressed: _login(_withReddit), child: const Text('Reddit ')),
            ElevatedButton(
                onPressed: _login(_withDiscord), child: const Text('Discord')),
            Visibility(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red // This is what you need!
                      ),
                  onPressed: _logout(),
                  child: const Text('Logout')),
              visible: logoutVisible,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Result: $_result'),
            )
          ],
        )),
      ),
    );
  }

  VoidCallback _login(Future<Web3AuthResponse> Function() method) {
    return () async {
      try {
        final Web3AuthResponse response = await method();
        setState(() {
          _result = response.toString();
          logoutVisible = true;
        });
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  VoidCallback _logout() {
    return () async {
      try {
        await Web3AuthFlutter.logout();
        setState(() {
          _result = '<empty>';
          logoutVisible = false;
        });
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  Future<Web3AuthResponse> _withGoogle() {
    return Web3AuthFlutter.login(provider: Provider.google);
  }

  Future<Web3AuthResponse> _withFacebook() {
    return Web3AuthFlutter.login(provider: Provider.facebook);
  }

  Future<Web3AuthResponse> _withReddit() {
    return Web3AuthFlutter.login(
        provider: Provider.email_passwordless,
        extraLoginOptions:
            ExtraLoginOptions(login_hint: "sosid94742@abincol.com"));
  }

  Future<Web3AuthResponse> _withDiscord() {
    return Web3AuthFlutter.login(provider: Provider.discord);
  }
}
