import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zanime/Constants.dart';
import 'package:zanime/Models/Anime.dart';
import 'package:zanime/Screens/AnimeDetails.dart';
import 'package:zanime/Screens/Favorites.dart';
import 'package:zanime/Screens/Saved.dart';

import 'package:zanime/Services/API.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  Color purple = Constant.main;
  Color white = Constant.white;

  List<Anime>? animes;
  ScrollController? _controller;
  int page = 2;
  bool isLoadingNextPage = false;
  String path = 'الموسم-الحالي';

  _scrollListener() {
    if (_controller!.offset >= _controller!.position.maxScrollExtent) {
      if (!isLoadingNextPage) {
        _loadMore();
        setState(() {
          page++;
        });
      }
    }
  }

  _loadMore() async {
    setState(() {
      isLoadingNextPage = true;
    });
    API.getContent(path: path, page: page).then((response) {
      setState(() {
        animes!.addAll(response);
        isLoadingNextPage = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller!.addListener(_scrollListener);
    loadAnime();
  }

  loadAnime() async {
    List<Anime> list = await API.getContent(path: path);

    setState(() {
      animes = list;
    });
  }

  _search(String value) async {
    String str = value.replaceAll(' ', '+');
    String path = 'search/?s=$str';

    setState(() {
      animes = null;
      path = path;
    });
    List<Anime> response = await API.search(path: path);
    setState(() {
      animes = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.background,
        body: Column(
          children: [
            _appBar(),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(
                  "لائحة الانمي",
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontSize: 20,
                      fontFamily: "Ahlan",
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder(
                future: API.getContent(path: path),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      animes == null) {
                    return Expanded(
                      child: Center(
                        child: Text("لا يوجد نتيجة"),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.waiting ||
                      animes == null) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return Flexible(
                        child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          controller: _controller,
                          itemCount: animes!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.65,
                            crossAxisCount: 3,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                          ),
                          itemBuilder: (context, index) => _buildTile(index),
                        ),
                      ),
                    ));
                  } else {
                    return Center(
                      child: Text("Error has occured"),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  _buildTile(int index) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                anime: animes![index],
              ),
            )),
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(animes![index].thumbnail!),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                animes![index].title!,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    color: white,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 0,
            child: Container(
              width: 60,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: purple,
              ),
              child: Center(
                  child: Text(
                animes![index].state!,
                style: TextStyle(color: white, fontFamily: "Ahlan"),
              )),
            ),
          ),
        ]));
  }

  _appBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Saved(),
                        ));
                  },
                  child: FaIcon(
                    FontAwesomeIcons.solidBookmark,
                    size: 30,
                    color: white,
                  ),
                ),
                SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      "assets/Logo.png",
                      color: white,
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Favorites(),
                        ));
                  },
                  child: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    size: 30,
                    color: white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            search()
          ]),
    );
  }

  search() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: white,
        border: Border.all(
          color: purple,
          width: 2,
        ),
      ),
      height: 46,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          onFieldSubmitted: (value) => _search(value),
          controller: searchController,
          style: TextStyle(color: purple),
          decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: purple,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: "البحث",
              hintStyle: TextStyle(
                  color: purple,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Ahlan",
                  fontSize: 20)),
        ),
      ),
    );
  }
}
