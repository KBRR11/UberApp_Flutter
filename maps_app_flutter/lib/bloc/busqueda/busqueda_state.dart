part of 'busqueda_bloc.dart';

@immutable
class BusquedaState {
  final bool seleccionManual;
  final bool busquedaPorQuery;

  BusquedaState({
    this.seleccionManual = false,
    this.busquedaPorQuery = false
    });

    BusquedaState copyWith({bool seleccionManual, bool busquedaPorQuery}) => 
    BusquedaState(
    seleccionManual: seleccionManual ?? this.seleccionManual,
    busquedaPorQuery: busquedaPorQuery ?? this.busquedaPorQuery
    );
}


