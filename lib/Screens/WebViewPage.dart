import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:adblocker_webview/adblocker_webview.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({required this.url});
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _adBlockerWebviewController = AdBlockerWebviewController.instance;
  @override
  void initState() {
    super.initState();
    _adBlockerWebviewController.initialize();

    /// ... Other code here.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: InkWell(
          onTap: _onBackPressed,
          child: Container(
            margin: EdgeInsets.only(top: 16),
            height: 45,
            width: 45,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        body: SafeArea(
          child: Center(
            child: AspectRatio(
                aspectRatio: 16 / 10,
                child: AdBlockerWebview(
                  url: Uri.parse(widget.url),
                  adBlockerWebviewController: _adBlockerWebviewController,
                  shouldBlockAds: true,
                )),
          ),
        ),
      ),
    );
  }

  _onBackPressed() async {
    Navigator.of(context).pop();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  bool isTrusted(NavigationAction action) {
    String r = action.request.url.toString();
    List<String> trustedURLs = [
      "sbembed.com/play/",
    ];
    for (int i = 0; i < trustedURLs.length; i++)
      if (r.contains(trustedURLs[i])) return true;

    return false;
  }
}
