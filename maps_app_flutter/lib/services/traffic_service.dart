


import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app_flutter/Secret%20Keys/keys.dart';
import 'package:maps_app_flutter/model/driving_response.dart';
import 'package:maps_app_flutter/model/search_response.dart';

class TrafficService{
  //Singleton
  TrafficService._privateConstructor();
  static final TrafficService _intance = TrafficService._privateConstructor();
  factory TrafficService(){
    return _intance;
  }

  final _dio = new Dio();
  final _baseUrlManual = 'https://api.mapbox.com/directions/v5'; /// se usa manualmente con un punto LatLng de destino
  final _baseUrlRequest = 'https://api.mapbox.com/geocoding/v5'; // se envía el nombre de un lugar como destino
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
    //print('${miUbicacion.longitude},${miUbicacion.latitude}');
    final url = '${this._baseUrlRequest}/mapbox.places/$busqueda.json';
    final resp = await this._dio.get(url, queryParameters: {
      'access_token': this._apikey,
      'autocomplete':true,
      'proximity'   : '${miUbicacion.longitude},${miUbicacion.latitude}',
      'language'    :'es'
    });
    //print(resp.data);
    final searchResponse = searchResponseFromJson(resp.data);
    
    return searchResponse;
  }
}