import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zanime/Constants.dart';
import 'package:zanime/Models/Anime.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:zanime/Models/Details.dart';
import 'package:zanime/Models/Servers.dart';
import 'dart:math';
import 'package:zanime/Screens/WebViewPage.dart';
import 'package:zanime/Services/API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.anime});
  final Anime anime;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isWatching = false;
  String? episode;
  int? episodeNumber;
  bool selected = false;
  bool back = false;
  Details? details;
  List<Server>? servers;
  List<Anime> favorites = [];
  List<Anime> saved = [];
  var _interstitialRetryAttempt = 0;
  bool isFav = false;
  bool isSav = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDetails();
    initializeInterstitialAds();
    AppLovinMAX.createBanner("1321a537abe8fcc1", AdViewPosition.bottomCenter);
    AppLovinMAX.showBanner("1321a537abe8fcc1");
    _getFavorites();
    _getSaved();
  }

  loadDetails() async {
    Details result = await API.getDetails(url: widget.anime.url!);
    setState(() {
      details = result;
      back = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Constant.background,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _backButton(),
              backgroundColor: Constant.main,
              elevation: 0,
              child: FaIcon(
                FontAwesomeIcons.angleLeft,
                size: 50,
              ),
            ),
            floatingActionButtonLocation: CustomFabLocation(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                      0.6,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                              color: Constant.main,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 80,
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.anime.title!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Axiforma",
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (isFav) {
                                          setState(() {
                                            isFav = false;
                                            for (int i = 0;
                                                i < favorites.length;
                                                i++) {
                                              if (favorites[i].title ==
                                                  widget.anime.title) {
                                                favorites.removeAt(i);
                                              }
                                            }
                                            _saveFavorites();
                                          });
                                        } else {
                                          favorites.add(widget.anime);
                                          setState(() {
                                            isFav = true;
                                            _saveFavorites();
                                          });
                                        }
                                      },
                                      child: FaIcon(
                                        isFav
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (isSav) {
                                          setState(() {
                                            isSav = false;
                                            for (int i = 0;
                                                i < saved.length;
                                                i++) {
                                              if (saved[i].title ==
                                                  widget.anime.title) {
                                                saved.removeAt(i);
                                              }
                                            }
                                            _saveSaved();
                                          });
                                        } else {
                                          saved.add(widget.anime);
                                          setState(() {
                                            isSav = true;
                                            _saveSaved();
                                          });
                                        }
                                      },
                                      child: FaIcon(
                                        isSav
                                            ? FontAwesomeIcons.solidBookmark
                                            : FontAwesomeIcons.bookmark,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: Image.network(
                              widget.anime.thumbnail!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder(
                    future: API.getDetails(url: widget.anime.url!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          details == null) {
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return Expanded(
                            child:
                                isWatching ? episodes() : description(context));
                      } else {
                        return Center(
                          child: Text("An Error has Occured"),
                        );
                      }
                    })
              ],
            )));
  }

  ships() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _buildShip(index),
          separatorBuilder: (context, index) => Divider(
                color: Colors.transparent,
              ),
          itemCount: details!.type.length),
    );
  }

  _buildShip(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            details!.type[index],
            style: TextStyle(color: Constant.main, fontFamily: "Ahlan"),
          ),
        ),
      ),
    );
  }

  episodes() {
    return Column(
      children: [
        Center(
            child: Text(
          episode != null ? "$episodeNumber الحلقة" : "الحلقات",
          style: TextStyle(
              color: Constant.white,
              fontSize: 36,
              fontWeight: FontWeight.w600,
              fontFamily: "Ahlan"),
        )),
        Expanded(
            child: SizedBox(
          width: double.maxFinite,
          child: selected
              ? _servers()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => _buildTile(index),
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.transparent,
                          ),
                      itemCount: details!.episodes.length),
                ),
        ))
      ],
    );
  }

  _servers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Constant.main,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                  child: Text(
                "اختر السرفر",
                style: TextStyle(
                    fontSize: 26, color: Colors.white, fontFamily: "Ahlan"),
              )),
            ),
            FutureBuilder(
              future: API.getWatchServers(url: episode!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    servers == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: SizedBox(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) => _buildServer(index),
                        itemCount: servers!.length,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('An error occured'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildServer(int index) {
    return GestureDetector(
      onTap: () {
        _showAd();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(url: servers![index].url),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: Text(
              "${servers![index].name} ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Constant.main,
                  fontFamily: 'Axiforma',
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  _loadServers(String url) async {
    List<Server> result = await API.getWatchServers(url: url);
    setState(() {
      servers = result;
    });
  }

  _showAd() async {
    bool isReady = (await AppLovinMAX.isInterstitialReady("f9c015d070affc28"))!;

    if (isReady) {
      AppLovinMAX.showInterstitial("f9c015d070affc28");
    } else {
      await Future.delayed(
        Duration(seconds: 5),
        () {
          AppLovinMAX.loadInterstitial("f9c015d070affc28");
        },
      );
    }
  }

  void initializeInterstitialAds() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'

        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial("f9c015d070affc28");
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial("f9c015d070affc28");
  }

  _buildTile(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = true;
                        episodeNumber = index + 1;
                        episode = details!.episodes[index];
                        _loadServers(details!.episodes[index]);
                      });
                    },
                    child: FaIcon(
                      FontAwesomeIcons.play,
                      color: Constant.white,
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "الحلقة ${index + 1}",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 20,
                    color: Constant.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Ahlan"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  description(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isWatching = true;
                  });
                },
                child: Container(
                  width: 140,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: Constant.main,
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.play,
                          size: 20,
                          color: Colors.white,
                        ),
                        Text(
                          "الحلقات",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Ahlan",
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                color: Constant.main,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "القصة",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Ahlan",
                          fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        details!.plot,
                        style: TextStyle(
                          fontFamily: "Ahlan",
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    !isWatching ? ships() : SizedBox()
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _backButton() {
    if (episode != null || selected == true) {
      setState(() {
        episode = null;
        selected = false;
      });
    } else if (isWatching == true) {
      setState(() {
        isWatching = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  bool isFavorite() {
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].title == widget.anime.title) return true;
    }
    return false;
  }

  _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> temp = jsonDecode(prefs.getString('favorites')!);
    setState(() {
      favorites = temp.map((show) => Anime.fromJson(show)).toList();
      isFav = isFavorite();
    });
  }

  _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', jsonEncode(favorites));
  }

  bool isSaved() {
    for (int i = 0; i < saved.length; i++) {
      if (saved[i].title == widget.anime.title) return true;
    }
    return false;
  }

  _getSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> temp = jsonDecode(prefs.getString('saved')!);
    setState(() {
      saved = temp.map((show) => Anime.fromJson(show)).toList();
      isSav = isSaved();
    });
  }

  _saveSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved', jsonEncode(favorites));
  }
}

class CustomFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Adjust the offsetY value to move the FAB down or up
    const double offsetY = 40.0;
    return Offset(0.0, offsetY);
  }
}
