import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareService {
  static StreamSubscription? _sub;

  static void listen(void Function(String url) onUrl) {
    ReceiveSharingIntent.instance.getInitialMedia().then((list) {
      if (list.isNotEmpty && list[0].path.isNotEmpty) {
        onUrl(list[0].path);
      }
    });

    _sub = ReceiveSharingIntent.instance.getMediaStream().listen((list) {
      if (list.isNotEmpty && list[0].path.isNotEmpty) {
        onUrl(list[0].path);
      }
    });
  }

  static void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
