import 'package:flutter/material.dart';
import 'package:github_user_flutter/ui/pages/home/home_page.dart';
import 'package:github_user_flutter/ui/pages/users/users_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => HomePage(),
        "/users": (context) => UsersPage(),
      },
      //home: HomePage(),
      initialRoute: "/users",
    );
  }
}
