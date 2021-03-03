import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app_flutter/bloc/busqueda/busqueda_bloc.dart';
import 'package:maps_app_flutter/model/search_response.dart';
import 'package:maps_app_flutter/model/search_result.dart';
import 'package:maps_app_flutter/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng miUbicacion;
  final List<SearchResult> historial;

  SearchDestination(this.miUbicacion, this.historial)
      : this.searchFieldLabel = 'Buscar...',
        this._trafficService = new TrafficService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => this.query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => this.close(context, SearchResult(cancelo: true)));
  }

  @override
  Widget buildResults(BuildContext context) {
    return this._construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicación manualmente'),
            onTap: () {
              final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
              busquedaBloc.add(OnActivarManualMarker());
              this.close(context, SearchResult(cancelo: false, manual: true));
            },
          ),
          ...historial.map((result) => ListTile(
            leading: Icon(Icons.history_outlined),
            title: Text(result.nombreDestino),
            subtitle: Text(result.descripcion),
            onTap: (){
              this.close(context, result);
            },
          )
          ).toList()
        ],
      );
    }
    return this._construirResultadosSugerencias();
  }

  Widget _construirResultadosSugerencias() {
    if (this.query.length == 0) {
      return Container();
    }
    this._trafficService.getSugerenciasPorQuery(this.query.trim(), this.miUbicacion);

    return StreamBuilder(
        stream: this._trafficService.sugerenciasStream,
        builder:
            (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final lugares = snapshot.data.features;

          if (lugares.length == 0) {
            return ListTile(
              leading: Icon(Icons.error_outline_outlined),
              tileColor: Colors.red[300],
              title: Text('No se encontraron resultados'),
              subtitle: Text('intenta con algo diferente'),
            );
          }

          return ListView.separated(
              itemCount: lugares.length,
              separatorBuilder: (_, i) => Divider(),
              itemBuilder: (_, i) {
                final lugar = lugares[i];

                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(lugar.textEs),
                  subtitle: Text(lugar.placeNameEs),
                  onTap: () {
                    BlocProvider.of<BusquedaBloc>(context).add(OnActivarBusquedaQuery());
   
                    this.close(context, SearchResult(
                      cancelo: false, 
                      manual: false,
                      coordenadas: LatLng(lugar.center[1], lugar.center[0]),
                      nombreDestino: lugar.textEs,
                      descripcion: lugar.placeNameEs
                      ));
                  },
                );
              });
        });
  }
}
