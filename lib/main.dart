import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _Homepage(
        isDark: isDark,
        toggleTheme: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
    );
  }
}

class _Homepage extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  _Homepage({
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<_Homepage> {
  bool isLoading = true;
  List<Map<String, dynamic>> hindiArticlesList = [];
  List<Map<String, dynamic>> englishArticlesList = [];

  Future<void> fetchHindiNews() async {
    final url = await http.get(
      Uri.parse(
        'https://gnews.io/api/v4/top-headlines?category=general&lang=hi&country=in&max=10&apikey=05c793fe6cf9e6dea3333a8b0c5cebf2',
      ),
    );
    var data = json.decode(url.body);
    hindiArticlesList.clear();
    for (int i = 0; i < data["articles"].length; i++) {
      hindiArticlesList.add({
        "title": data["articles"][i]["title"],
        "description": data["articles"][i]["description"],
        "image": data["articles"][i]["image"],
        "url": data["articles"][i]["url"],
      });
    }
  }

  Future<void> fetchEnglishNews() async{
    final url = await http.get(Uri.parse("https://gnews.io/api/v4/top-headlines?category=general&lang=en&country=in&max=10&apikey=05c793fe6cf9e6dea3333a8b0c5cebf2"));
    var data = json.decode(url.body);
    englishArticlesList.clear();
    for(int i=0;i<data["articles"].length;i++){
      englishArticlesList.add({
        "title": data["articles"][i]["title"],
        "description": data["articles"][i]["description"],
        "image": data["articles"][i]["image"],
        "url": data["articles"][i]["url"],
      });
    }

  }

  @override
  void initState() {
    super.initState();
    loadedData();
  }

  Future<void> loadedData() async{
    await fetchHindiNews();
    await fetchEnglishNews();
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aapka Apna Khabari 😉",
          style: TextStyle(fontFamily: "bold", fontSize: 23),
        ),
        actions: [
          IconButton(onPressed: ()async{
            setState(() {
              isLoading = true;
            });
            await loadedData();
          }, icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: widget.toggleTheme,
            icon: widget.isDark ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
          )
        ],
      ),
      body: isLoading? Center(child: CircularProgressIndicator(),):ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "News in Hindi",
              style: TextStyle(fontFamily: "bold", fontSize: 22),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 510,
            width: double.infinity,
            child: ListView.builder(

              itemCount: hindiArticlesList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        hindiArticlesList[index]["image"],
                        height: 180,
                        width: 320,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 7,right:10),
                      child: Column(
                        children: [
                          Text(
                            hindiArticlesList[index]["title"],
                            style: TextStyle(fontFamily: "regular", fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 2),
                    Container(
                      margin: EdgeInsets.only(left: 12, top: 5,right:10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hindiArticlesList[index]["description"],
                            style: TextStyle(fontFamily: "regular", fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () async {
                              final Uri url = Uri.parse(hindiArticlesList[index]["url"]);
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text("Read full article"),
                          )
                        ],
                      ),
                    ),
                    Divider(height: 20,),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "News in English",
              style: TextStyle(fontFamily: "bold", fontSize: 22),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 510,
            width: double.infinity,
            child: ListView.builder(

              itemCount: englishArticlesList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        englishArticlesList[index]["image"],
                        height: 180,
                        width: 320,

                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 7,right: 8),
                      child: Column(
                        children: [
                          Text(
                            englishArticlesList[index]["title"],
                            style: TextStyle(fontFamily: "regular", fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 2),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 5,right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            englishArticlesList[index]["description"],
                            style: TextStyle(fontFamily: "regular", fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () async {
                              final Uri url = Uri.parse(englishArticlesList[index]["url"]);
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text("Read full article"),
                          )
                        ],
                      ),
                    ),
                    Divider(height: 20,),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
