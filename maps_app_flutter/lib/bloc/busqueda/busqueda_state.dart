part of 'busqueda_bloc.dart';

@immutable
class BusquedaState {
  final bool seleccionManual;
  final bool busquedaPorQuery;
  final List<SearchResult> historial;

  BusquedaState({
    this.seleccionManual = false,
    this.busquedaPorQuery = false,
    List<SearchResult> historial
    }): this.historial = (historial == null) ? [] : historial;

    BusquedaState copyWith({
      bool seleccionManual, 
      bool busquedaPorQuery,
      List<SearchResult> historial
      }) => 
    BusquedaState(
    seleccionManual : seleccionManual  ?? this.seleccionManual,
    busquedaPorQuery: busquedaPorQuery ?? this.busquedaPorQuery,
    historial       : historial        ?? this.historial
    );
}


