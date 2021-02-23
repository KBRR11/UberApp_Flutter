


import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app_flutter/Secret%20Keys/keys.dart';
import 'package:maps_app_flutter/model/driving_response.dart';

class TrafficService{
  //Singleton
  TrafficService._privateConstructor();
  static final TrafficService _intance = TrafficService._privateConstructor();
  factory TrafficService(){
    return _intance;
  }

  final _dio = new Dio();
  final _baseUrl = 'https://api.mapbox.com/directions/v5';
  final _apikey = access_token;

  Future<DrivingResponse> getCoordsInicioYDestino(LatLng inicio, LatLng destino) async{
    
     final coordString = '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
     final url = '${this._baseUrl}/mapbox/driving/$coordString';

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
}