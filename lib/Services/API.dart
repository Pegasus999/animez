import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:zanime/Models/Anime.dart';
import 'package:zanime/Models/Details.dart';
import 'package:zanime/Models/Servers.dart';

class API {
  static const url_active = "https://tenz.surge.sh/gogo.json";
  static String url_base = "https://animelek.me";

  static Future isActive() async {
    // var response = await http.get(Uri.parse(url_active));
    // return (response.statusCode == 200)
    //     ? jsonDecode(response.body)["active"]
    //     : true;
    return true;
  }

  static Future getContent({required String path, int page = 1}) async {
    var response =
        await http.get(Uri.parse(url_base + "/$path" + "/?page=$page"));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      var container =
          document.getElementsByClassName('anime-list-content').first;
      var animes = container.getElementsByClassName('anime-card-container');

      List<Anime> list = animes.map((e) => Anime.toAnime(e)).toList();

      return list;
    }
  }

  static Future getDetails({required String url}) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);

      return Details.toDetails(document);
    }
  }

  static Future getWatchServers({required String url}) async {
    var response = await http.get(Uri.parse(url));
    dom.Document document = parser.parse(response.body);

    var list = document.querySelector('ul#episode-servers')!.children;
    return list
        .map(
          (e) => Server.toServer(e),
        )
        .toList();
  }

  static Future search({required String path}) async {
    var response = await http.get(Uri.parse("$url_base/$path"));

    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      var container =
          document.getElementsByClassName('anime-list-content').first;
      var animes = container.getElementsByClassName('anime-card-container');

      List<Anime> list = animes.map((e) => Anime.toAnime(e)).toList();

      return list;
    }
  }
}
