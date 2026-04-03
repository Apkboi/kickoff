import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Max 512KB for profile avatars (KickOff rules).
Future<Uint8List> compressProfileAvatar({required Uint8List bytes}) async {
  const maxBytes = 512 * 1024;
  if (bytes.length <= maxBytes) return bytes;

  var quality = 88;
  var current = bytes;

  while (current.length > maxBytes && quality >= 25) {
    final out = await FlutterImageCompress.compressWithList(
      current,
      minHeight: 256,
      minWidth: 256,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    if (out.isEmpty) {
      throw StateError('Could not compress image');
    }
    current = Uint8List.fromList(out);
    quality -= 12;
  }

  if (current.length > maxBytes) {
    throw StateError('Image is still too large. Try a smaller image.');
  }
  return current;
}
