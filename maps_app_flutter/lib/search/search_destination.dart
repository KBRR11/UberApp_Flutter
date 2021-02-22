

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app_flutter/bloc/busqueda/busqueda_bloc.dart';
import 'package:maps_app_flutter/model/search_result.dart';

class SearchDestination extends SearchDelegate<SearchResult>{

  @override
  final String searchFieldLabel;

  SearchDestination(): this.searchFieldLabel = 'Buscar...';


  @override
  List<Widget> buildActions(BuildContext context) {
      return [
        IconButton(icon: Icon(Icons.clear), onPressed: () => this.query = '')
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      
      return IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => this.close(context, SearchResult(cancelo: true)));
    }
  
    @override
    Widget buildResults(BuildContext context) {
      return Text('buildResults');
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Colocar ubicación manualmente'),
          onTap: (){
           final busquedaBloc =  BlocProvider.of<BusquedaBloc>(context);
           busquedaBloc.add(OnActivarManualMarker());
            this.close(context, SearchResult(cancelo: false, manual: true));
          },
        )
      ],
    );
  }

}