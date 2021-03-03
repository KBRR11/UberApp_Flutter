part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class OnActivarManualMarker extends BusquedaEvent{}

class OnDesactivarManualMarker extends BusquedaEvent{}

class OnActivarBusquedaQuery extends BusquedaEvent{}

class OnDesactivarBusquedaQuery extends BusquedaEvent{}

class OnAddHistorial extends BusquedaEvent{
  final SearchResult result;

  OnAddHistorial(this.result);
}