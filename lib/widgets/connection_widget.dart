import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_feeder/api/mqtt_api.dart';
import 'package:pet_feeder/models/connection.dart';

import '../enums.dart';

class CustomConnectionWidget extends StatefulWidget {
  const CustomConnectionWidget({Key? key}) : super(key: key);

  @override
  State<CustomConnectionWidget> createState() => _CustomConnectionWidgetState();
}

class _CustomConnectionWidgetState extends State<CustomConnectionWidget> {
  late Future<Connection> _connection;

  @override
  void initState() {
    super.initState();
    _connection = MqttApi().checkConnectionAlive();
  }

  void _refreshConnection() {
    setState(() {
      _connection = MqttApi().checkConnectionAlive();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Connection?>(
        future: _connection,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: ConnectionWidget(ConnectionStatus.offline, null)),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          } else if (snapshot.hasData && snapshot.data?.active == true) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: ConnectionWidget(ConnectionStatus.connected, null)),
                IconButton(
                  onPressed: () => {_refreshConnection()},
                  icon: const Icon(
                    Icons.refresh_outlined,
                    size: 35,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: ConnectionWidget(ConnectionStatus.error, snapshot.error.toString())),
                IconButton(
                  onPressed: () => {_refreshConnection()},
                  icon: const Icon(
                    Icons.refresh_outlined,
                    size: 35,
                  ),
                ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: ConnectionWidget(ConnectionStatus.offline, null)),
                IconButton(
                  onPressed: () => {_refreshConnection()},
                  icon: const Icon(
                    Icons.refresh_outlined,
                    size: 35,
                  ),
                ),
              ],
            );
          }
        });
  }
}

class ConnectionWidget extends StatelessWidget {
  final ConnectionStatus _connectionStatus;
  final String? _error;

  const ConnectionWidget(this._connectionStatus, this._error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectionStatus.connected || _connectionStatus == ConnectionStatus.offline) {
      return Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
        decoration: BoxDecoration(
          color: _connectionStatus == ConnectionStatus.connected ? Colors.lightGreen[400] : Colors.grey[600],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0)),
        ),
        child: Text(
          _connectionStatus == ConnectionStatus.connected ? 'Connected' : 'Offline',
          style: const TextStyle(fontSize: 30.0, color: Colors.white),
        ),
      );
    } else {
      return Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
          decoration: BoxDecoration(
            color: Colors.red[600],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Error",
              style: TextStyle(fontSize: 30.0, color: Colors.white),
            ),
            Text(
              '$_error',
              style: const TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ]));
    }
  }

  Column createErrorColumn(String? error) {
    Column column = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "Error",
        style: TextStyle(fontSize: 30.0, color: Colors.white),
      ),
      Text(
        '$_error',
        style: const TextStyle(fontSize: 15.0, color: Colors.white),
      ),
    ]);

    if (_error != null && _error!.isNotEmpty) {}

    return Column();
  }
}
