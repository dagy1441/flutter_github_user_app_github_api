import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_user_flutter/ui/pages/home/home_page.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  UsersPage({Key? key}) : super(key: key);
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController searchUserController = TextEditingController();
  String? username;
  dynamic data;
  int currentPage = 0;
  int totalPages = 0;
  int pageSize = 20;
  List<dynamic> items = [];
  ScrollController scrollController = ScrollController();

  void _search(String username) {
    const String endPoint = "https://api.github.com/search/users?q=";
    String url =
        '$endPoint${username}&page=${currentPage},per_page=${pageSize} ';
    print("====> url $url");
    http.get(Uri.parse(url)).then((response) {
      setState(() {
        data = json.decode(response.body);
        items.addAll(data['items']);
        if (data['total_count'] % pageSize == 0) {
          totalPages = data['total_count'] ~/
              pageSize; // ~/ ignore les decimaux recuperer la partie enier d'une division
        } else {
          totalPages = (data['total_count'] ~/ pageSize) +
              1; // floor arrondi les decimaux
        }
      });
    }).catchError((error) {
      print("@=====> error : ${error}");
    });
  }

//permet d'initializer nos variable ou action avant ou a chaque constructon du widget
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          if (currentPage < totalPages - 1) {
            ++currentPage;
            _search(username!);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: this.username != null
            ? Text("Welcome $username page $currentPage / $totalPages")
            : Text("welcome"),
      ),
      body: Center(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: searchUserController,
                    onChanged: (value) {
                      setState(() {
                        this.username = value;
                      });
                    },
                    decoration: InputDecoration(
                      //icon: Icon(Icons.log),
                      //suffixIcon: Icon(Icons.visibility),
                      contentPadding: EdgeInsets.only(left: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    items = [];
                    currentPage = 0;
                    username = searchUserController.text;
                    _search(username!);
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          // Expanded(
          //   child: ListView.separated(
          //     // ListView.builder et ListView.separated
          //     separatorBuilder: (context, index) => Divider(
          //       height: 2,
          //       color: Colors.blueAccent,
          //     ),
          //     controller: scrollController,
          //     itemCount: items.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => HomePage(
          //                 username: items[index]['login'],
          //                 avatar: items[index]['avatar_url'],
          //               ),
          //             ),
          //           );
          //         },
          //         title: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Row(
          //               children: [
          //                 CircleAvatar(
          //                   backgroundImage: NetworkImage(
          //                     "${items[index]['avatar_url']}",
          //                   ),
          //                   radius: 30,
          //                 ),
          //                 SizedBox(
          //                   width: 15,
          //                 ),
          //                 Text("${items[index]['login']}"),
          //               ],
          //             ),
          //             CircleAvatar(
          //               child: Text("${items[index]['score']}"),
          //             )
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    crossAxisCount: 3,
                  ),
                  itemCount: data == null ? 0 : items.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              username: items[index]['login'],
                              avatar: items[index]['avatar_url'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    "${items[index]['avatar_url']}",
                                  ),
                                ),
                              ),
                            ),
                            Text("${items[index]['login']}"),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      )),
    );
  }
}
