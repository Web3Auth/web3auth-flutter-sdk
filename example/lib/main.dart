import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openlogin_flutter/openlogin_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
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
    await OpenloginFlutter.init(
        clientId: 'BOsNaqfC9exeI_0K_YWV_jLe_wpLcqLu1QU1_bv5wb_D7ufUHSIuRyhqh6AnpfgsWkVChdaOO3cJ6T9LJddpYYQ',
        network: Network.mainnet,
        redirectUri: 'org.torusresearch.flutter.openloginexample://auth');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torus OpenLogin Example'),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Login with'),
                ),
                ElevatedButton(
                    onPressed: _login(_withGoogle), child: Text('Google')),
                ElevatedButton(
                    onPressed: _login(_withFacebook), child: Text('Facebook')),
                ElevatedButton(
                    onPressed: _login(_withReddit), child: Text('Reddit ')),
                ElevatedButton(
                    onPressed: _login(_withDiscord), child: Text('Discord')),
                Visibility(
                  child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.red // This is what you need!
                  ),onPressed: _logout(), child: Text('Logout')),
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

  VoidCallback _login(Future<OpenLoginResponse> Function() method) {
    return () async {
      try {
        final OpenLoginResponse response = await method();
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
        await OpenloginFlutter.triggerLogout();
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


  Future<OpenLoginResponse> _withGoogle() {
    return OpenloginFlutter.triggerLogin(
        provider: Provider.google);
  }

  Future<OpenLoginResponse> _withFacebook() {
    return OpenloginFlutter.triggerLogin(
        provider: Provider.facebook);
  }

  Future<OpenLoginResponse> _withReddit() {
    return OpenloginFlutter.triggerLogin(
        provider: Provider.reddit);
  }

  Future<OpenLoginResponse> _withDiscord() {
    return OpenloginFlutter.triggerLogin(
        provider: Provider.discord);
  }
}