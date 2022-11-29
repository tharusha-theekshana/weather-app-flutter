import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Climate App',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var name;
  var temp;
  var description;
  var id;

  Future getWeather() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?id=524901&units=metric&appid=07165661a7b5436e79f6a78b46b87f97');

    http.Response response = await http.get(url);
    var result = jsonDecode(response.body);

    setState(() {
      this.name = result['name'];
      this.temp = result['main']['temp'];
      this.description = result['weather'][0]['description'];
      this.id = result['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 10), (timer) {
      this.getWeather();
      print('Load Function');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Center(
          child: Text( 'Weather App'),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0) ,
                    child: Text(
                      name != null ? 'City is' + ' ' + name.toString() : "Loading",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    temp != null ? temp.toString() + ' °C ' : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      description != null
                          ? description.toString() + ""
                          : "Loading",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Temperature"),
                    trailing: Text (temp != null ? temp.toString() + ' °C ' : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.city),
                    title: Text("City Id"),
                    trailing: Text(id != null ? id.toString() : "Loading"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
