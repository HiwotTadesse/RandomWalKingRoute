import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/walking_route/presentation/bloc/bloc/walking_route_bloc.dart';
import 'feature/walking_route/presentation/page/splash_screen.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(BlocProvider(
      create: (_) => sl<WalkingRouteBloc>(),
      child: const MaterialApp(
        home: SplashScreen(),
      )));
}
