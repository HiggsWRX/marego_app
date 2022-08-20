import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:marego_app/services/auth/bloc/auth_bloc.dart';
import 'package:marego_app/services/auth/bloc/auth_event.dart';

class MaregoAppDrawer extends StatefulWidget {
  const MaregoAppDrawer({Key? key}) : super(key: key);

  @override
  State<MaregoAppDrawer> createState() => _MaregoAppDrawerState();
}

class _MaregoAppDrawerState extends State<MaregoAppDrawer> {
  late TextEditingController _salesChannelController;
  late TextEditingController _apiKeyController;

  @override
  void initState() {
    _salesChannelController = TextEditingController();
    _apiKeyController = TextEditingController();

    final Box<String> box = Hive.box('devSettingsBox');
    final salesChannel = box.get('salesChannel');
    final apiKey = box.get('apiKey');

    if (salesChannel != null) {
      _salesChannelController.text = salesChannel;
    }

    if (apiKey != null) {
      _apiKeyController.text = apiKey;
    }

    super.initState();
  }

  @override
  void dispose() {
    _salesChannelController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveSalesAndApiKey() {
    final salesChannel = _salesChannelController.text;
    final apiKey = _apiKeyController.text;

    if (salesChannel.isEmpty || apiKey.isEmpty) {
      return;
    }

    final Box<String> box = Hive.box('devSettingsBox');
    box.putAll({
      'salesChannel': salesChannel,
      'apiKey': apiKey,
    });
    log('Saved sales channel and api key');

    _salesChannelController.clear();
    _apiKeyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 138, 207, 40),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
        children: [
          ListTile(
            title: const Text('Settings',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
            color: Colors.redAccent,
            thickness: 2,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Text(
              'DEVELOPER AREA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.redAccent,
              ),
            ),
          ),
          const Text(
            'Sales Channel',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: TextField(
              controller: _salesChannelController,
              enableSuggestions: false,
              autocorrect: false,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Channel ID...',
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          const Text(
            'API Key',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: TextField(
              controller: _apiKeyController,
              enableSuggestions: false,
              autocorrect: false,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Key...',
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            onTap: () {},
          ),
          TextButton(
            onPressed: _saveSalesAndApiKey,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            color: Colors.redAccent,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.white70,
            ),
            title: const Text('Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                )),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(
                const AuthEventUnauthenticate(),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
