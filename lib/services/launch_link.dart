import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  if (!url.startsWith('http')) {
    url = 'https://$url';
  }
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.inAppBrowserView,
  )) {
    throw 'Could not launch $url';
  }
}
