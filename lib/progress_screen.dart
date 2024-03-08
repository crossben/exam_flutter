import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;


import 'dart:convert';

class MyTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>  {
  int  _progress = 0;
  final List<Map<String, dynamic>> _citiesData = [];

  late Timer _timer;

  late AnimationController _animationController;

  get cities => null;
    @override
    void initState(){
      super.initState();
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        _getWeather();
        setState(() {
          _progress = min(_progress + 20, 100);
        });
      });

      _animationController = AnimationController(vsync: MyTickerProvider(),
      duration: const Duration(seconds: 60),
      );
      _animationController.forward();
    }

  Future<void> _getWeather() async {
    List<String> _cities = ['senegal', 'niger', 'Paris', 'Tokyo', 'Sydney'];
    for (int i = 0; i <= _cities.length - 1; i++) {
      String city = _cities[i];
      String apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=116f05f4ea4fbdaaee36382709490862';
      http.Response response = await http.get(Uri.parse(apiUrl));
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _citiesData.add(data);
      });
      if (response.statusCode == 200) {

      } else {
       // print('Error d affichage de données  $city');
      }
    }
    await Future.delayed(Duration(seconds: 10));
  }
    @override
  Widget build(BuildContext context) {

      return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Screen'),
      ),

      body: Center(


        child:Stack(
          alignment: Alignment.center,
          children: <Widget>  [
            LinearProgressIndicator(

          value: _citiesData.length / 5,
          backgroundColor: Colors.grey.shade200,
              valueColor: ColorTween(begin: Colors.transparent, end: Colors.purpleAccent).animate(_animationController),
          minHeight: 20,

            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _citiesData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> cityData = _citiesData[index];
                  return ListTile(
                    title: Text(cityData['name']),
                    subtitle: Text('Température: ${cityData['main']['temp']}°C'),
                    trailing: const Icon(Icons.cloud),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityDetailsScreen(cityData: cityData),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _timer.cancel();
      super.dispose();
    _animationController.dispose();
  }
}

class CityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> cityData;

  const CityDetailsScreen({super.key, required this.cityData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityData['name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Détails de ${cityData['name']}',
            ),
            const SizedBox(height: 20),
            Text(
              'Température: ${cityData['main']['temp']}°C',
            ),
            const SizedBox(height: 20),
            Text(
              'Couverture nuageuse: ${cityData['weather'][0]['description']}',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}