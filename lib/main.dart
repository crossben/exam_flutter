import 'package:flutter/material.dart';
import 'package:exam/progress_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jauge App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
            .copyWith(background: const Color.fromARGB(255, 131, 147, 160)),
      ),
      home: const MyHomePage(title: 'Jauge App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    double percentage = 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenue dans l\'application Jauge. Appuyez sur le bouton pour continuer.',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          percentage += 0.1;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProgressScreen()),
          );
        },
        key: const Key('myButton'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 5,
        heroTag: 'myButton',
        isExtended: false,
        tooltip: 'Voir',
        splashColor: const Color.fromARGB(255, 255, 255, 255),
        disabledElevation: 0,
        child: const Icon(Icons.ac_unit),
      ),
    );
  }
}
