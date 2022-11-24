import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/getCurrent_location_bloc.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/get_current_location_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/get_current_location_state.dart';
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
  String message = "";

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
    BlocProvider.of<CurrentLocationBloc>(context)
        .add(GetCurrentLocationEvent());
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
              flex: 5,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                child: BlocBuilder<CurrentLocationBloc, CurrentLocationState>(
                    builder: (context, state) {
                  if (state is CurrentLocationInitial) {
                    message = "";
                    return buildLoadingAnimation();
                  } else if (state is CurrentLocationLoading) {
                    message = "";
                    return buildLoadingAnimation();
                  } else if (state is CurrentLocationLoaded) {
                    message = "";
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => WalkingRouteScreen(
                                    currentLocation: state.currentLocation,
                                  )));
                    });

                    return buildLoadingAnimation();
                  } else if (state is CurrentLocationError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                })),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
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
