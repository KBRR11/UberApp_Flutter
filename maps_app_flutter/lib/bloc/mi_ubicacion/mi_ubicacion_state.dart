part of 'mi_ubicacion_bloc.dart';

@immutable
class MiUbicacionState {
  final bool siguendo;
  final bool existeUbicacion;
  final LatLng ubicacion;

  MiUbicacionState({
    this.siguendo = true, 
    this.existeUbicacion = false, 
    this.ubicacion
    }); 
  
 MiUbicacionState copyWith(
   {bool siguendo,
bool existeUbicacion,
LatLng ubicacion})=> new MiUbicacionState(
  siguendo       : siguendo        ?? this.siguendo,
  existeUbicacion: existeUbicacion ?? this.existeUbicacion,
  ubicacion      : ubicacion       ?? this.ubicacion,
);
  
}


