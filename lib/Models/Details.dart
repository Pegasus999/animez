import 'package:html/dom.dart' as dom;

class Details {
  List<String> type = [];
  String plot = '';
  String state = '';
  String episodeCount = '?';
  List<String> episodes = [];

  Details.toDetails(dom.Document element) {
    type = _types(element);
    episodes = _episodes(element);
    state = element.querySelectorAll('div.full-list-info>small>a')[1].text;
    plot = element.querySelector('p.anime-story')!.text;
    episodeCount = element.querySelectorAll('div.full-list-info>small')[7].text;
  }

  List<String> _types(dom.Document document) {
    List<dom.Element> types =
        document.querySelector('ul.anime-genres')!.querySelectorAll('li');
    List<String> list = types.map((e) => e.text).toList();
    return list;
  }

  List<String> _episodes(dom.Document document) {
    List<dom.Element> list = document
        .querySelector('div.episodes-list-content')!
        .querySelectorAll('div.ep-card-anime-title-detail>h3>a');
    return list.map((e) => e.attributes['href']!).toList();
  }

  Details.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        plot = json['plor'],
        state = json['state'],
        episodeCount = json['episodeCount'],
        episodes = json['episodes'];
}
