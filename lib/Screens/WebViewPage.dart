import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({required this.url});
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
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
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.url),
                  headers: {"Referer": widget.url},
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                      useShouldInterceptRequest: true, initialScale: 10),
                ),
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  print(
                      "CLICKED ::::" + navigationAction.request.url.toString());
                  if (isTrusted(navigationAction))
                    return NavigationActionPolicy.ALLOW;
                  else
                    return NavigationActionPolicy.CANCEL;
                },
                androidShouldInterceptRequest: (controller, request) async {
                  if (isAd(request)) {
                    //print("BLOCKED");
                    return WebResourceResponse();
                  } else {
                    print("===>" + request.url.host);
                  }
                  return null;
                },
                onEnterFullscreen: (controller) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight
                  ]);
                },
                onExitFullscreen: (controller) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.portraitUp
                  ]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onBackPressed() {
    Navigator.of(context).pop();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  bool isAd(WebResourceRequest request) {
    String r = request.toString();
    List<String> adsProviders = [
      "dutorterraom.com",
      "googletagmanager.com",
      "louchees.net",
      "inpagepush.com",
      "toglooman.com",
      "onmarshtompor.com",
      "offerimage.com",
      "naucaish.net",
      "naucaish.net",
      "jighucme.com",
      "jomtingi.net",
      "in-page-push.com",
      "goajuzey.com",
      "yandex.ru",
      "ddmax20.xyz",
      "awaitcola.com",
      "pianistrefutationgoose.com",
      "snarlleadenpsychology.com",
      "d24ak3f2b.top",
      "onaudience.com",
      "e2wysbacctt1.com",
      "lightningprefacegrant.com",
      "seeptauw.net",
      "tapecontent.net",
      "cloudfront.net",
      ".biz",
      "exdynsrv.com",
      "2mdn.net",
      "geedoovu.net",
      "bidgear.com",
      "adnxs.com",
      "a-mo.net",
      "criteo.com",
      "snagbaudhulas.com",
      "cdn4ads.com",
      "apus.tech",
      "adsco.re",
      "howstroll.com",
      "disinheritacquaintancechop.com",
      "salutationcheerlessdemote.com",
      "lcdn.runative-syndicate.com",
    ];
    for (int i = 0; i < adsProviders.length; i++)
      if (r.contains(adsProviders[i])) return true;

    return false;
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
