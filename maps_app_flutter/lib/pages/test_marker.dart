import 'package:flutter/material.dart';
import 'package:maps_app_flutter/custom_markers/custom_markers.dart';

 
class TestMarker extends StatelessWidget {
  //const TestMarker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          width: 350,
          color: Colors.red,
          child: CustomPaint(
            painter:MarkerDetinoPainter('agsdbnajsfhasnmsdkdshfndamsdkaj', 42541),
            
          ),
        ),
      )
    );
  }
}