part of 'mi_ubicacion_bloc.dart';

@immutable
abstract class MiUbicacionEvent {}

class OnChangeUbicacion extends MiUbicacionEvent {
   
   final LatLng ubicacion;

  OnChangeUbicacion(this.ubicacion);
}
