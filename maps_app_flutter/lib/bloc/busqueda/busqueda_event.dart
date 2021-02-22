part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class OnActivarManualMarker extends BusquedaEvent{}

class OnDesactivarManualMarker extends BusquedaEvent{}
