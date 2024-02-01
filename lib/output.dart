class Web3AuthResponse {
  final String? privKey;
  final String? ed25519PrivKey;
  final String? sessionId;
  final TorusUserInfo? userInfo;
  final String? error;
  final String? coreKitKey;
  final String? coreKitEd25519PrivKey;
  final String? factorKey;
  final List<String>? signatures;
  final int? tssShareIndex;
  final String? tssPubKey;
  final String? tssShare;
  final int? tssNonce;

  Web3AuthResponse({
    this.privKey,
    this.userInfo,
    this.error,
    this.ed25519PrivKey,
    this.sessionId,
    this.coreKitKey,
    this.coreKitEd25519PrivKey,
    this.factorKey,
    this.signatures,
    this.tssShareIndex,
    this.tssPubKey,
    this.tssShare,
    this.tssNonce,
  });

  @override
  String toString() {
    return "{privKey=$privKey, userInfo = ${userInfo.toString()}, ed25519PrivKey=$ed25519PrivKey, coreKitKey=$coreKitKey, coreKitEd25519PrivKey=$coreKitEd25519PrivKey, sessionId=$sessionId, error=$error,"
        "factorKey=$factorKey, signatures=$signatures, tssShareIndex=$tssShareIndex, tssPubKey=$tssPubKey, tssShare=$tssShare, tssNonce=$tssNonce}";
  }

  Map<String, dynamic> toJson() {
    return {
      'privKey': privKey,
      'userInfo': userInfo?.toJson(),
      'ed25519PrivKey': ed25519PrivKey,
      'sessionId': sessionId,
      'error': error,
      'coreKitKey': coreKitKey,
      'coreKitEd25519PrivKey': coreKitEd25519PrivKey,
      'factorKey': factorKey,
      'signatures': signatures,
      'tssShareIndex': tssShareIndex,
      'tssPubKey': tssPubKey,
      'tssShare': tssShare,
      'tssNonce': tssNonce
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
        error = json['error'],
        factorKey = json['factorKey'],
        signatures = json['signatures'] != null
            ? List<String>.from(json['signatures'])
            : null,
        tssShareIndex = json['tssShareIndex'],
        tssPubKey = json['tssPubKey'],
        tssShare = json['tssShare'],
        tssNonce = json['tssNonce'];
}

class TorusUserInfo {
  final String? email;
  final String? name;
  final String? profileImage;
  final String? verifier;
  final String? verifierId;
  final String? typeOfLogin;
  final String? aggregateVerifier;
  final String? dappShare;
  final String? idToken;
  final String? oAuthIdToken;
  final String? oAuthAccessToken;
  final bool? isMfaEnabled;

  const TorusUserInfo(
      {this.email,
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
      this.isMfaEnabled});

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
