import 'package:equatable/equatable.dart';

/// Shared label + URL for match streams (YouTube, Twitch, etc.).
class StreamLink extends Equatable {
  const StreamLink({required this.label, required this.url});

  final String label;
  final String url;

  /// Parses Firestore [streamLinks] array and falls back to legacy [streamUrl].
  static List<StreamLink> listFromFirestore(dynamic raw, String? legacyUrl) {
    final out = <StreamLink>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map) {
          final url = (e['url'] as String?)?.trim();
          final label = (e['label'] as String?)?.trim();
          if (url != null && url.isNotEmpty) {
            out.add(StreamLink(label: (label != null && label.isNotEmpty) ? label : 'Stream', url: url));
          }
        }
      }
    }
    if (out.isEmpty) {
      final u = legacyUrl?.trim();
      if (u != null && u.isNotEmpty) {
        out.add(StreamLink(label: 'Stream', url: u));
      }
    }
    return out;
  }

  @override
  List<Object?> get props => [label, url];
}
