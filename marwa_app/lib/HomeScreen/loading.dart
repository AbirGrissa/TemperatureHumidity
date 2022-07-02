import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue[100],
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.blue,
            size: 50.0,
          ),
        ));
  }
}
