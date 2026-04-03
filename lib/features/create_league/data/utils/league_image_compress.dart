import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../domain/entities/league_image_kind.dart';

/// Enforces KickOff limits: 512KB logo, 1MB banner (after compression).
Future<Uint8List> compressLeagueImageForUpload({
  required Uint8List bytes,
  required LeagueImageKind kind,
}) async {
  final maxBytes = kind == LeagueImageKind.logo ? 512 * 1024 : 1024 * 1024;
  if (bytes.length <= maxBytes) return bytes;

  final minSide = kind == LeagueImageKind.logo ? 256 : 720;
  final minWidth = kind == LeagueImageKind.logo ? 256 : 1280;

  var quality = 88;
  var current = bytes;

  while (current.length > maxBytes && quality >= 25) {
    final out = await FlutterImageCompress.compressWithList(
      current,
      minHeight: minSide,
      minWidth: minWidth,
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
    throw StateError(
      'Image is still too large after compression. Try a smaller image.',
    );
  }
  return current;
}
