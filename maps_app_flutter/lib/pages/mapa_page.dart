import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app_flutter/bloc/mapa/mapa_bloc.dart';
import 'package:maps_app_flutter/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:maps_app_flutter/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
    super.initState();
  }
  @override
  void dispose() {
    BlocProvider.of<MiUbicacionBloc>(context).cancelarSeguimiento();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white,
    body: Stack(
      children: [
        BlocBuilder< MiUbicacionBloc,MiUbicacionState >(
          builder: ( _ , state) => crearMapa(state)
          ),
          SearchBar(),//TODO: hacer toggle cuando tengo manual marker
          ManualMarker()
      ],
    ), 
    floatingActionButton:Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
      
        BtnUbicacion(),
        BtnSeguirUbicacion(),
        BtnMiRuta(),
         
      ],
    ) ,
    );  
  }

  Widget crearMapa(MiUbicacionState state){
      if (!state.existeUbicacion) return Center(child: Image(image: AssetImage('assets/loading_g.gif')),);
      final mapaBloc = BlocProvider.of<MapaBloc>(context);
      mapaBloc.add(OnNewLocation(ubicacion: state.ubicacion));
      final camaraPosition = CameraPosition(target: state.ubicacion, zoom:16);
      return GoogleMap(
        initialCameraPosition: camaraPosition, 
        myLocationEnabled: true, 
        zoomControlsEnabled: false, 
        myLocationButtonEnabled: false,
        compassEnabled: false,
        onMapCreated: mapaBloc.initMapa ,//valido cuando tenemos solo un argumento que puede pasar directo EJEMPLO: onMapCreated: (GoogleMapController controler){ mapaBloc.initMapa(controler) } //SIMPLE
        polylines: mapaBloc.state.polylines.values.toSet(),
        onCameraMove: (cameraPosition){
          mapaBloc.add( OnMovioMapa(centroMapa: cameraPosition.target) );// la idea es hacer que si el target es diferente al point final entonces SeguirUbicación cambiará a false
        },
        );
  }
}

