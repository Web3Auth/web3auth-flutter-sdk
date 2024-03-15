class Web3AuthResponse {
  /// secp256k1 private key compaitible with Ethereum ecosystem.
  final String? privKey;

  /// ed25519 private key compaitible with Solana ecosystem.
  final String? ed25519PrivKey;

  /// Current We3Auth sessionId.
  final String? sessionId;

  /// User's information based on the current session.
  final TorusUserInfo? userInfo;

  final String? error;

  /// secp256k1 core kit key.
  final String? coreKitKey;

  /// ed25519 core kit key.
  final String? coreKitEd25519PrivKey;

  Web3AuthResponse({
    this.privKey,
    this.userInfo,
    this.error,
    this.ed25519PrivKey,
    this.sessionId,
    this.coreKitKey,
    this.coreKitEd25519PrivKey,
  });

  @override
  String toString() {
    return "{privKey=$privKey, userInfo = ${userInfo.toString()}, ed25519PrivKey=$ed25519PrivKey, coreKitKey=$coreKitKey, coreKitEd25519PrivKey=$coreKitEd25519PrivKey, sessionId=$sessionId, error=$error}";
  }

  Map<String, dynamic> toJson() {
    return {
      'privKey': privKey,
      'userInfo': userInfo?.toJson(),
      'ed25519PrivKey': ed25519PrivKey,
      'sessionId': sessionId,
      'error': error,
      'coreKitKey': coreKitKey,
      'coreKitEd25519PrivKey': coreKitEd25519PrivKey
    };
  }

  Web3AuthResponse.fromJson(Map<String, dynamic> json)
      : privKey = json['privKey'],
        userInfo = json['userInfo'] != null
            ? TorusUserInfo.fromJson(json['userInfo'])
            : null,
        ed25519PrivKey = json['ed25519PrivKey'],
        sessionId = json['sessionId'],
        coreKitKey = json['coreKitKey'],
        coreKitEd25519PrivKey = json['coreKitEd25519PrivKey'],
        error = json['error'];
}

class TorusUserInfo {
  /// Email of the connected user.
  final String? email;

  /// Name of the connected user.
  final String? name;

  /// Profile image of the connected user.
  final String? profileImage;

  /// Details of the verifier type.
  final String? verifier;

  /// Verified id for the custom verifiers.
  final String? verifierId;

  /// Type of login choosen by user, like google, facebook, etc.
  final String? typeOfLogin;

  /// Details of the aggregate verifier, if present.
  final String? aggregateVerifier;

  /// If you are using a Custom Verifier, you can get a dapp share after successful login.
  /// This share can act as a replacement to your user's device share.
  ///
  /// It is a 24 word seed phrase)
  final String? dappShare;

  /// JWT token issued by the Web3Auth.
  final String? idToken;

  /// JWT token issued by the OAuth provider.
  final String? oAuthIdToken;

  //// Access token issued by the OAuth provider.
  final String? oAuthAccessToken;

  /// Defines whether MFA is enabled or not.
  final bool? isMfaEnabled;

  const TorusUserInfo({
    this.email,
    this.name,
    this.profileImage,
    this.verifier,
    this.verifierId,
    this.typeOfLogin,
    this.aggregateVerifier,
    this.dappShare,
    this.idToken,
    this.oAuthIdToken,
    this.oAuthAccessToken,
    this.isMfaEnabled,
  });

  @override
  String toString() {
    return "{email=$email, name=$name, profileImage=$profileImage, verifier=$verifier,"
        "verifierId=$verifierId, typeOfLogin=$typeOfLogin, dappShare=$dappShare, idToken=$idToken, oAuthIdToken=$oAuthIdToken, oAuthAccessToken=$oAuthAccessToken, isMfaEnabled=$isMfaEnabled}";
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'verifier': verifier,
      'verifierId': verifierId,
      'typeOfLogin': typeOfLogin,
      'aggregateVerifier': aggregateVerifier,
      'dappShare': dappShare,
      'idToken': idToken,
      'oAuthIdToken': oAuthIdToken,
      'oAuthAccessToken': oAuthAccessToken,
      'isMfaEnabled': isMfaEnabled
    };
  }

  TorusUserInfo.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'],
        profileImage = json['profileImage'],
        verifier = json['verifier'],
        verifierId = json['verifierId'],
        typeOfLogin = json['typeOfLogin'],
        aggregateVerifier = json['aggregateVerifier'],
        dappShare = json['dappShare'],
        idToken = json['idToken'],
        oAuthIdToken = json['oAuthIdToken'],
        oAuthAccessToken = json['oAuthAccessToken'],
        isMfaEnabled = json['isMfaEnabled'];
}
