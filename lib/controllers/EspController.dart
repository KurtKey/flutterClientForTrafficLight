import 'dart:convert';
import 'package:esp_iot_app/models/Esp.dart';
import 'package:http/http.dart' as http;

String serverLink = 'http://192.168.8.104:3000/';

Future<List<Esp>> fetchEspData() async {
  List<Esp> esps = [];
  final response = await http.get(Uri.parse('${serverLink}getall'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    esps = data.map((json) => Esp.fromJson(json)).toList();
      print("---------------------data received :"+data.toString());
  } else {
    // Handle error
    print('Failed to fetch ESPs: ${response.statusCode}');
  }
  return esps;
}

Future<List<String>> fetchLedState() async {
  // Make an HTTP GET request to fetch the LED state
  List<String> ledState = ['DEFAULT'];
  String espName = 'DEFAULT NAME';
  List<String> stateAndName = [];

  final response = await http.get(Uri.parse('${serverLink}get-global-led-state'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
      ledState = data['globalLedState'].split(';');
      espName = data['globalEspName'];

      stateAndName.add(ledState[0]);
      stateAndName.add(ledState[1]);
      stateAndName.add(espName);

      print("Led state received :"+data.toString());
  } else {
    // Handle error
    print('Failed to fetch LED state: ${response.statusCode}');
  }
  return stateAndName;
}

Future<void> turnOnOffTrafficLight(String espIP, String onOff) async{
  final response = await http.get(Uri.parse('${serverLink}turnonoff-esp/${espIP}/${onOff}'));

  if (response.statusCode == 200) {
    print("TrafficLight turned $onOff");
    final response2 = await http.post(Uri.parse('${serverLink}update-esp-state/${espIP}/${onOff}'));
    if(response2.statusCode ==200){
      print("state of esp successfully changed to $onOff in Mongodb");
    }else {
      print('Failed to change the state of esp to $onOff in Mongodb: ${response2.statusCode}');
    }
  } else {
    // Handle error
    print('Failed to turn $onOff the trafficlight: ${response.statusCode}');
  }
}

Future<void> inverseTrafficLight(String espIP, String wantedState) async{
  final response = await http.get(Uri.parse('${serverLink}control-esp/${espIP}/${wantedState}'));

  if (response.statusCode == 200) {
    print("TrafficLight order changed");
  } else {
    // Handle error
    print('TrafficLight order failed to change: ${response.statusCode}');
  }
}