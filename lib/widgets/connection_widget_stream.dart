import 'package:flutter/material.dart';
import 'package:pet_feeder/enums.dart';
import 'package:pet_feeder/models/connection.dart';
import 'package:pet_feeder/service/app_service.dart';

class CustomStreamConnectionWidget extends StatelessWidget {
  final AppService _appService = AppService.instance;

  CustomStreamConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Connection?>(
      stream: _appService.connection,
      initialData: _appService.connection.valueOrNull,
      builder: (context, snapshot) {
        final connection = snapshot.data;
        final error = snapshot.error;

        if (connection == null && error == null || connection != null && !connection.active) {
          return buildConnectionBanner(ConnectionStatus.offline);
        } else if (connection != null && connection.active) {
          return buildConnectionBanner(ConnectionStatus.connected);
        } else {
          return buildConnectionBanner(ConnectionStatus.error, error: error.toString());
        }
      },
    );
  }

  Widget buildConnectionBanner(ConnectionStatus connectionStatus, {String? error}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            decoration: BoxDecoration(
              color: connectionStatus == ConnectionStatus.connected
                  ? Colors.lightGreen[400]
                  : connectionStatus == ConnectionStatus.offline
                      ? Colors.grey[600]
                      : Colors.red[600],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connectionStatus == ConnectionStatus.connected
                      ? 'Connected'
                      : connectionStatus == ConnectionStatus.offline
                          ? 'Offline'
                          : 'Error',
                  style: const TextStyle(fontSize: 30.0, color: Colors.white),
                ),
                Visibility(
                  visible: error != null && error.isNotEmpty,
                  child: Text(
                    '$error',
                    style: const TextStyle(fontSize: 15.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: connectionStatus == ConnectionStatus.offline,
          child: Container(
            margin: const EdgeInsets.only(left: 11, right: 11),
            child: const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Visibility(
          visible: connectionStatus == ConnectionStatus.connected || connectionStatus == ConnectionStatus.error,
          child: IconButton(
            onPressed: () => {_appService.onInvalidate()},
            icon: const Icon(
              Icons.refresh_outlined,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }
}
