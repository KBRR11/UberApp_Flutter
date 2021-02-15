import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:maps_app_flutter/helpers/helpers.dart';
import 'package:maps_app_flutter/pages/acceso_gps_page.dart';
import 'package:maps_app_flutter/pages/mapa_page.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() { 
    WidgetsBinding.instance.addObserver(this);
    super.initState();  
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.resumed){
      if( await Geolocator.GeolocatorPlatform.instance.isLocationServiceEnabled() ){
        Navigator.pushReplacement(context, navegarFadeIn(context, MapaPage()));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: this.chekGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data),
            );
          } else {
            return Center(
            child: Image(image: AssetImage('assets/loading_g.gif')),
          );
          }
        },
      ),
    );
  }

  Future chekGpsYLocation(BuildContext context) async {
    
    final permisoGPS = await Permission.location.isGranted;
    
    final gpsActivo = await Geolocator.GeolocatorPlatform.instance.isLocationServiceEnabled();
    if (permisoGPS && gpsActivo) {
      Navigator.pushReplacement(context, navegarFadeIn(context, MapaPage()));
      return '';
    }else if(!permisoGPS){
      Navigator.pushReplacement(context, navegarFadeIn(context, AccesoGpsPage()));
    return 'Es necesario el permiso del GPS';
    }else if(!gpsActivo){
      return 'active el GPS';
    }
    //await Future.delayed(Duration(milliseconds: 1000));
   // Navigator.pushReplacement(context, navegarFadeIn(context, AccesoGpsPage()));
  }
}
