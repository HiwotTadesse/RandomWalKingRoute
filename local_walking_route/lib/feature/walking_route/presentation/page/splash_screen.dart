import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_bloc.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_state.dart';
import 'package:local_walking_route/feature/walking_route/presentation/page/walking_route_page.dart';

import '../../../../injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSplashScreen(context);
  }

  Scaffold buildSplashScreen(BuildContext context) {
    BlocProvider.of<WalkingRouteBloc>(context).add(GetCurrentLocationEvent());
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 4,
              child: SizedBox(),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Generate Walking Route",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            const SizedBox(
              width: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phone_in_talk,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/foot_print.png',
                      height: 100,
                      width: 100,
                    ),
                  ],
                ),
              ],
            ),
            const Expanded(
              flex: 4,
              child: SizedBox(),
            ),
            AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 420),
                child: BlocBuilder<WalkingRouteBloc, WalkingRouteState>(
                    builder: (context, state) {
                  if (state is WalkingRouteInitial) {
                    return buildLoadingAnimation();
                  } else if (state is WalkingRouteLoading) {
                    return buildLoadingAnimation();
                  } else if (state is WalkingRouteLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => WalkingRouteScreen(
                                    currentLocation: state.currentLocation,
                                  )));
                    });

                    return buildLoadingAnimation();
                  } else if (state is WalkingRouteError) {
                    return const Center(
                      child: Text(
                        'Please check your internet connection',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }))
          ])
    ]));
  }

  Widget buildLoadingAnimation() {
    return SpinKitThreeBounce(
      color: Colors.black,
      size: 35.0,
      controller: animationController,
    );
  }
}
