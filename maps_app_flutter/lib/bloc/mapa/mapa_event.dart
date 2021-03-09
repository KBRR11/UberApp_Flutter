part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent {}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnCrearRutaInicioFin extends MapaEvent {
  final List<LatLng> rutaCoordenadas;
  final double distance;
  final double duration;
  final String nombreDestino;

  OnCrearRutaInicioFin(
      {this.rutaCoordenadas, this.distance, this.duration, this.nombreDestino});
}

class OnMovioMapa extends MapaEvent {
  final LatLng centroMapa;

  OnMovioMapa({this.centroMapa});
}

class OnNewLocation extends MapaEvent {
  final LatLng ubicacion;

  OnNewLocation({this.ubicacion});
}
