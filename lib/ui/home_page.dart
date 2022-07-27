import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:buscador_gifs/ui/createGifTable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';
  int offset = 0;

  Uri myUri = Uri.parse(
      'https://api.giphy.com/v1/gifs/trending?api_key=e322BcFyOHrsWx9G58SFvtHOHbAaDG9c&limit=20&rating=g');

  Future<Map> getGifs() async {
    https.Response response;

    if (search.isEmpty) {
      response = await https.get(myUri);
    } else {
      response = await https.get(
        Uri.parse(
            'https://api.giphy.com/v1/gifs/search?api_key=e322BcFyOHrsWx9G58SFvtHOHbAaDG9c&q=$search&limit=20&offset=$offset&rating=g&lang=pt'),
      );
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisa',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getGifs(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError) return Container();
                      else return createGifTable(context, snapshot);
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}
