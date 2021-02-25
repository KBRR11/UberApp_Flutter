part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent {}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnCrearRutaManual extends MapaEvent {
  final List<LatLng> rutaCoordenadas;
  final double distance;
  final double duration;

  OnCrearRutaManual({
    this.rutaCoordenadas, 
    this.distance, 
    this.duration
    });
}

class OnMovioMapa extends MapaEvent{
  final LatLng centroMapa;

  OnMovioMapa({this.centroMapa});
}

class OnNewLocation extends MapaEvent{
  final LatLng ubicacion;

  OnNewLocation({this.ubicacion});
}

