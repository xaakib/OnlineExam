import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List getAPiData = [];

  getAllModels() async {
    String getUrl =
        "http://165.22.196.82:8080/api/v1/mcq-model-test/?format=json";

    http.Response response = await http.get(
      Uri.parse(getUrl),
    );

    if (response.statusCode == 200) {
      getAPiData = jsonDecode(response.body);
      print("ApiData loaded ");
      setState(() {});
    } else {
      print("no Data");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("API"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: getAPiData.length<1 ? Center(child: CircularProgressIndicator()) : ListView.builder(
            itemCount: getAPiData.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsScreen(
                      modelTitle : getAPiData[index]['title'].toString(),
                      id: getAPiData[index]['id'],
                    )),
                  );
                },
                child: ListTile(
                  title: Text(getAPiData[index]['title'].toString()),
                  subtitle:
                      Text(getAPiData[index]['short_description'].toString()),
                      trailing: Text(getAPiData[index]['id'].toString(),style: TextStyle(
                        color: Colors.white
                      ),),
                  leading: Image.network(
                      getAPiData[index]['cover_image'].toString()),
                ),
              );
            }),
      ),
    );
  }
}
