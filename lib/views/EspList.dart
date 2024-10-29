import 'package:esp_iot_app/models/Esp.dart';
import 'package:flutter/material.dart';

import '../controllers/EspController.dart';
import 'EspDetail.dart';

class EspList extends StatefulWidget {
  @override
  _EspListState createState() => _EspListState();
}

class _EspListState extends State<EspList> {
  List<Esp> esps = [];
  String onOff = '';

  Future<void> _refreshEsps() async {
    setState(() {
      esps = [];
    });
    await getAllEsps();
  }

  Future<void> getAllEsps() async {
    var fetchedEsps = await fetchEspData();
    setState(() {
      esps = fetchedEsps;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllEsps();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshEsps,
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading data'),
            );
          } else {
            return ListView.builder(
              itemCount: esps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(esps[index].espNumber),
                  subtitle: Text(esps[index].ipAddress),
                  trailing: Switch(
                    value: esps[index].state,
                    onChanged: (value) {
                      setState(() {
                        esps[index].state = value;
                        esps[index].state ? onOff = 'ON' : onOff = 'OFF';
                        turnOnOffTrafficLight(
                            esps[index].ipAddress, onOff);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EspDetailsPage(esp: esps[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
