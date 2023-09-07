import 'dart:convert';
import 'dart:math';

class SecureRandom {
  static final Random _random = Random.secure();

  static String createCryptoRandomString() {
    var values = List<int>.generate(32, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}
