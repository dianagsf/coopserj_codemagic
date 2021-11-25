import 'package:coopserj_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          //fontFamily: 'Raleway',
          scaffoldBackgroundColor: Colors.white,
        ),
        title: "Coopserj",
        home:
            InitialPage() //LoginPage(), // InitialPage(), WEB COMEÇA DO LOGIN E MOBILE COMEÇA DA INITIAL PAGE!!!!!!!
        ),
  );
}
