import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marego_app/helpers/loading/loading_screen.dart';
import 'package:marego_app/services/auth/bloc/auth_bloc.dart';
import 'package:marego_app/services/auth/bloc/auth_event.dart';
import 'package:marego_app/services/auth/bloc/auth_state.dart';
import 'package:marego_app/services/auth/firebase_auth_provider.dart';
import 'package:marego_app/views/dashboard_view.dart';
import 'package:marego_app/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('devSettingsBox');
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Marego',
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateAuthenticated) {
          return const DashboardView();
        } else if (state is AuthStateUnverifiedUser) {
          return const Text('Unverified');
        } else if (state is AuthStateUnauthenticated) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const Text('Forgot Password');
        } else if (state is AuthStateRegistering) {
          return const Text('Registering');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
