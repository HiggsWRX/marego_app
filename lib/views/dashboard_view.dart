import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marego_app/services/auth/bloc/auth_bloc.dart';
import 'package:marego_app/services/auth/bloc/auth_event.dart';
import 'package:marego_app/services/auth/bloc/auth_state.dart';
import 'package:marego_app/utils/dialogs/error_dialog.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            return TabBarView(
              children: [
                Column(
                  children: [
                    Card(
                      elevation: 1,
                      margin: const EdgeInsets.all(16),
                      child: ListTile(
                        onTap: () {
                          showErrorDialog(context, 'Hi!');
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
                  ],
                ),
                const Text('Transactions'),
                const Text('Account'),
              ],
            );
          },
        ),
        endDrawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 138, 207, 40),
          child: ListView(
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
                  BlocProvider.of<AuthBloc>(context)
                      .add(const AuthEventUnauthenticate());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
