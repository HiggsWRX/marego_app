import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marego_app/components/marego_app_drawer.dart';
import 'package:marego_app/services/auth/bloc/auth_bloc.dart';
import 'package:marego_app/services/auth/bloc/auth_state.dart';
import 'package:marego_app/services/tapconnect/model/station_model.dart';
import 'package:marego_app/services/tapconnect/stations_api.dart';
import 'package:marego_app/utils/biometrics/authenticate_with_biometrics.dart';
import 'package:marego_app/utils/dialogs/error_dialog.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late bg.Location _currentLocation;
  late List<Station> _stations;

  Future<void> getLocationsAroundUser(
    double latitude,
    double longituve,
  ) async {
    final List<Station> stations =
        await StationsAPI.getStationsAroundCoordinate(
      latitude,
      longituve,
    );

    setState(() {
      _stations = stations;
    });
  }

  @override
  void initState() {
    super.initState();

    // Note: BackgroundGeolocation plugin has an enourmous amount of events
    // that can be subscribed to. Check docs for all available events.

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      log('ON LOCATION CALLBACK');
      _currentLocation = location;
      log(_currentLocation.toString());
      await getLocationsAroundUser(
        _currentLocation.coords.latitude,
        _currentLocation.coords.longitude,
      );
    });

    bg.BackgroundGeolocation.ready(
      bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      ),
    ).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start().then((value) => log('Started'));
      }

      bg.BackgroundGeolocation.getCurrentPosition(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        maximumAge: 0,
        timeout: 10,
      ).then((bg.Location location) {
        _currentLocation = location;
        getLocationsAroundUser(
          _currentLocation.coords.latitude,
          _currentLocation.coords.longitude,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight + 8.0,
          elevation: 0,
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: false,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Image.asset(
              'assets/images/marego-logo-wheel.png',
            ),
          ),
          title: const Text('Marego'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.more_vert),
                color: Colors.black,
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 138, 207, 40),
            indicatorWeight: 3,
            labelColor: Color.fromARGB(255, 138, 207, 40),
            labelStyle: TextStyle(
              fontSize: 12,
            ),
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'CHECK IN'),
              Tab(text: 'TRANSACTIONS'),
              Tab(text: 'ACCOUNT'),
            ],
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {},
          builder: (context, state) {
            return SafeArea(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Card(
                        elevation: 1,
                        margin: const EdgeInsets.all(16),
                        child: ListTile(
                          onTap: () async {
                            final couldAuthenticate =
                                await authenticateWithBiometrics();

                            if (!mounted) return;
                            showErrorDialog(context,
                                'Could authenticate? $couldAuthenticate');
                          },
                          title: const Text('Check-in | Check-out',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              )),
                          subtitle: const Text('Einfach fahren!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              )),
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          itemCount: _stations.length,
                          itemBuilder: (context, index) {
                            final station = _stations[index];
                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.all(16),
                              child: ListTile(
                                onTap: () {
                                  showErrorDialog(context, 'TODO');
                                },
                                title: Text(
                                  station.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(station.zone,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Text('Transactions'),
                  const Text('Account'),
                ],
              ),
            );
          },
        ),
        endDrawer: const MaregoAppDrawer(),
      ),
    );
  }
}
