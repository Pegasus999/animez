import 'package:html/dom.dart' as dom;

class Server {
  String name = "";
  String url = '';
  String quality = '';

  Server.toServer(dom.Element element) {
    name = element.getElementsByTagName('a').first.text.trim();
    url = element
        .getElementsByTagName('a')
        .first
        .attributes['data-ep-url']
        .toString();
    quality = element.getElementsByTagName('small').first.text;
  }
}
