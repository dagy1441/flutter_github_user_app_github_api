import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.username, this.avatar}) : super(key: key);
  final String? username;
  final String? avatar;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic repositoriesData;
  
  void loadUserRepositories() async {
    String url = "https://api.github.com/users/${widget.username}/repos";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        //pour rafraichire les donnees
        repositoriesData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserRepositories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.username} repositories",
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.avatar!),
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
                title: Text("${repositoriesData[index]['name']}"),
              ),
          separatorBuilder: (context, index) => Divider(
                height: 2,
                color: Colors.blueAccent,
              ),
          itemCount: repositoriesData == null ? 0 : repositoriesData.length),
    );
  }
}
