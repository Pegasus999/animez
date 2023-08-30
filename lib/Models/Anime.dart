import 'package:html/dom.dart' as dom;

class Anime {
  String? title;
  String? url;
  String? thumbnail;
  String? state;

  Anime.toAnime(dom.Element element) {
    title = element.querySelector('h3')!.text;
    url = element.getElementsByTagName('a').first.attributes['href'];
    state = element
        .getElementsByClassName('anime-card-status')
        .first
        .children[0]
        .text;
    thumbnail = element.getElementsByTagName('img').first.attributes['src'];
  }

  Anime.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumbnail = json['thumbnail'],
        url = json['url'],
        state = json['state'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'thumbnail': thumbnail,
        'url': url,
        'state': state,
      };
}
