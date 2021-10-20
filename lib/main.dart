import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helios_test/utils.dart';
import 'package:helios_test/simple_bloc_observer.dart';
import 'package:helios_test/view/home_screen.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontFamily: 'P22',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
          headline1: TextStyle(
            fontFamily: 'P22',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 17,
          ),
          headline2: TextStyle(
            color: grayishGreen,
            fontSize: 15,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
