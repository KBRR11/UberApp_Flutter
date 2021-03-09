


import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app_flutter/Secret%20Keys/keys.dart';
import 'package:maps_app_flutter/helpers/debouncer.dart';
import 'package:maps_app_flutter/model/driving_response.dart';
import 'package:maps_app_flutter/model/reverse_query_response.dart';
import 'package:maps_app_flutter/model/search_response.dart';

class TrafficService{
  //Singleton
  TrafficService._privateConstructor();
  static final TrafficService _intance = TrafficService._privateConstructor();
  factory TrafficService(){
    return _intance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400 ));
   
  final StreamController<SearchResponse> _sugerenciasStreamController = new StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get sugerenciasStream => this._sugerenciasStreamController.stream;

  final _baseUrlManual = 'https://api.mapbox.com/directions/v5'; /// se usa manualmente con un punto LatLng de destino
  final _baseUrlRequest = 'https://api.mapbox.com/geocoding/v5'; // se envía el nombre de un lugar como destino, tambien sirve para obterner informacion de un punto específico
  final _apikey = access_token;

  Future<DrivingResponse> getCoordsInicioYDestino(LatLng inicio, LatLng destino) async{
    
     final coordString = '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
     final url = '${this._baseUrlManual}/mapbox/driving/$coordString';

     final resp = await this._dio.get(url, queryParameters: {
       'alternatives':'true',
       'geometries':'polyline6',
       'steps':'false',
       'access_token':this._apikey, 
       'language':'es' 
     });

     final data = DrivingResponse.fromJson(resp.data);

     return data;

  }

  Future<SearchResponse> getResultadosRequest(String busqueda, LatLng miUbicacion) async{
    
    final url = '${this._baseUrlRequest}/mapbox.places/$busqueda.json';
    try {
      final resp = await this._dio.get(url, queryParameters: {
      'access_token': this._apikey,
      'autocomplete':true,
      'proximity'   : '${miUbicacion.longitude},${miUbicacion.latitude}',
      'language'    :'es'
    });
    
    final searchResponse = searchResponseFromJson(resp.data);
    
    return searchResponse;
    } catch (e) {
      return SearchResponse( features: [] );
    }
  }

  void getSugerenciasPorQuery( String busqueda, LatLng proximidad ) {

  debouncer.value = '';
  debouncer.onValue = ( value ) async {
    final resultados = await this.getResultadosRequest(value, proximidad);
    this._sugerenciasStreamController.add(resultados);
  };

  final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
    debouncer.value = busqueda;
  });

  Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel()); 

}

  Future<ReverseQueryResponse> getCoordenadasInfo(LatLng destino) async{//ReverseQueryResponse
  
     final url = '${this._baseUrlRequest}/mapbox.places/${destino.longitude},${destino.latitude}.json';

     final resp = await this._dio.get(url, queryParameters: {
       'access_token':this._apikey,//'pk.eyJ1Ijoia2JycjExIiwiYSI6ImNrbGdycm94aDEzb3kybm82MHBwY2lzbXMifQ.zMpWEeu8aQf_EUxhEJ_0gQ',
       'language':'es' 
     });

     final data = reverseQueryResponseFromJson(resp.data);
     print(data.features[0].placeName);
     //final data = DrivingResponse.fromJson(resp.data);

     return data;
  }

}