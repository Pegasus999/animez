import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zanime/Constants.dart';
import 'package:zanime/Models/Anime.dart';
import 'package:zanime/Screens/AnimeDetails.dart';
import 'package:zanime/Services/API.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Anime> favorites = [];

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Future _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> temp = jsonDecode(prefs.getString('favorites')!);
    setState(() {
      favorites = temp.map((show) => Anime.fromJson(show)).toList();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(
                      width: 100,
                      child: FaIcon(
                        FontAwesomeIcons.angleLeft,
                        size: 36,
                        color: Constant.main,
                      ),
                    ),
                  ),
                  Text(
                    "انمياتي المفضلة",
                    style: TextStyle(
                        fontFamily: "Ahlan",
                        fontSize: 26,
                        color: Constant.main),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  child: favorites.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            color: Colors.transparent,
                          ),
                          itemBuilder: (context, index) => _buildTile(index),
                          itemCount: favorites.length,
                        )
                      : Center(
                          child: Text(
                            "لا يوجد انميات",
                            style: TextStyle(
                                fontFamily: "Ahlan",
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        )),
            ),
          ],
        ),
      ),
    );
  }

  bool isFavorite(String name) {
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].title == name) return true;
    }
    return false;
  }

  _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', jsonEncode(favorites));
  }

  _buildTile(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(anime: favorites[index]),
            ));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  favorites.removeAt(index);
                });
                _saveFavorites();
              },
              child: FaIcon(
                FontAwesomeIcons.solidHeart,
                size: 40,
                color: Constant.main,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        favorites[index].title!,
                        style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      ),
                      FutureBuilder(
                          future: API.getDetails(url: favorites[index].url!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 8),
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: "${snapshot.data.state} ,",
                                        style: TextStyle(
                                            fontFamily: "Ahlan",
                                            fontSize: 14,
                                            color: Constant.main)),
                                    TextSpan(
                                      text:
                                          " ${snapshot.data.episodes.length} / ${snapshot.data.episodeCount}",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    )
                                  ])),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text("An error occured"),
                              );
                            }
                          })
                    ]),
              ),
            ),
            Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(favorites[index].thumbnail!),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
