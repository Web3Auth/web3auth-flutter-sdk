import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Utils {
  String es256Token(String email) {
    String token;

    /* Sign */ {
      // Create a json web token
      final jwt = JWT({
        "sub": "email|hello",
        "aud": "torus-key-test",
        "exp": DateTime.now().millisecond,
        "iat": DateTime.now().millisecond,
        "iss": "torus-key-test",
        "email": email,
        "nickname": email.split("@")[0],
        "name": email,
        "picture": "",
        "email_verified": true
      });

      // Sign it
      final key = ECPrivateKey("-----BEGIN PRIVATE KEY-----\n"
          "MEECAQAwEwYHKoZIzj0CAQYIKoZIzj0DAQcEJzAlAgEBBCCD7oLrcKae+jVZPGx52Cb/lKhdKxpXjl9eGNa1MlY57A=="
          "\n-----END PRIVATE KEY-----");
      token = jwt.sign(key, algorithm: JWTAlgorithm.ES256);

      print('Signed token: \n $token\n');
      return token;
    }
  }
}
