import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.location});
  final String location;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final String apiKey = '9ab15cbcf8fddcab5fee13382128b2f1';
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${widget.location}&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      setState(() {
        _weatherData = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 8, 99),
      appBar: AppBar(
        title: const Text('Weather Result',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _weatherData != null
                ? Card(
                    color: Colors.transparent,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Location: ${_weatherData?['name'] ?? 'N/A'}',
                            style: myStyle,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Temperature: ${_weatherData?['main']['temp'] ?? 'N/A'}°C',
                            style: myStyle,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Condition: ${_weatherData?['weather'][0]['description'] ?? 'N/A'}',
                            style: myStyle,
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    'Failed to load weather data',
                    style: myStyle,
                  ),
      ),
    );
  }
}

TextStyle myStyle = const TextStyle(
  fontSize: 22,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
