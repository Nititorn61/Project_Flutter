import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:car_okay/utils/random.dart';

class COImageCompress {
  final String path;

  const COImageCompress(this.path);

  Future<Uint8List> _compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 30,
    );
    return result!;
  }

  Future<File> getCompressFile() async {
    Uint8List imageInUnit8List = await _compressFile(File(path));
    final tempDir = await getTemporaryDirectory();
    File file = await File(
            '${tempDir.path}/${SecureRandom.createCryptoRandomString()}.png')
        .create();
    file.writeAsBytesSync(imageInUnit8List);
    return file;
  }
}
