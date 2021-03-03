import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'busqueda_event.dart';
part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  BusquedaBloc() : super(BusquedaState());

  @override
  Stream<BusquedaState> mapEventToState( BusquedaEvent event,) async* {
   
   if (event is OnActivarManualMarker) {
     print('Se llamó evento OnActivarManualMarker');
     yield state.copyWith(seleccionManual: true);
   }else if(event is OnDesactivarManualMarker){
     yield state.copyWith(seleccionManual: false);
   }else if(event is OnActivarBusquedaQuery){
     yield state.copyWith(busquedaPorQuery: true);
   }else if(event is OnDesactivarBusquedaQuery){
     yield state.copyWith(busquedaPorQuery: false);
   }
  }
}
