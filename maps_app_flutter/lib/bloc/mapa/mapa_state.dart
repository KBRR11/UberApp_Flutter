part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng ubicacionCentral;

  //Polylines
  final Map<String, Polyline> polylines;

  MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = false,
    this.ubicacionCentral,
    Map<String, Polyline> polylines
    }): this.polylines = polylines ?? new Map() ;

  MapaState copyWith({
      bool mapaListo,
      bool dibujarRecorrido,
      bool seguirUbicacion,
      LatLng ubicacionCentral,
      Map<String, Polyline> polylines
    }) => MapaState(
      mapaListo: mapaListo?? this.mapaListo, 
      dibujarRecorrido: dibujarRecorrido?? this.dibujarRecorrido, 
      seguirUbicacion: seguirUbicacion?? this.seguirUbicacion, 
      ubicacionCentral: ubicacionCentral?? this.ubicacionCentral, 
      polylines: polylines?? this.polylines, 
    );
}
