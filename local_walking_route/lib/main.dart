import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/getCurrent_location_bloc.dart';
import 'feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_bloc.dart';
import 'feature/walking_route/presentation/page/splash_screen.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CurrentLocationBloc>()),
        BlocProvider(create: (_) => sl<RandomRoutesBloc>()),
      ],
      child: const MaterialApp(
        home: SplashScreen(),
      )));
}
