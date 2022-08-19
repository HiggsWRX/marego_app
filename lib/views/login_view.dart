import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marego_app/services/auth/auth_exceptions.dart';
import 'package:marego_app/services/auth/bloc/auth_bloc.dart';
import 'package:marego_app/services/auth/bloc/auth_event.dart';
import 'package:marego_app/services/auth/bloc/auth_state.dart';
import 'package:marego_app/utils/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateUnauthenticated) {
          if (state.exception is UserNotFoundAuthException ||
              state.exception is WrongCredentialsAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the provided credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Something went wrong');
          }
        }
      },
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
              color: Colors.black,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ListTile(
                title: Text(
                  'Please log in to your \nbank account.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    'You only have to do this once.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                tileColor: Color.fromARGB(255, 138, 207, 40),
                contentPadding: EdgeInsets.fromLTRB(16, 32, 16, 32),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text('Bei Ihrer Bank anmelden',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Kontonummer',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 138, 207, 40),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'PIN',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 138, 207, 40),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: OutlinedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    context
                        .read<AuthBloc>()
                        .add(AuthEventAuthenticate(email, password));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 2, color: Colors.orange),
                    backgroundColor: Colors.orange,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'WEITER',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
