

import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult{
  final bool cancelo;
  final bool manual;
  final LatLng coordenadas;
  final String nombreDestino;
  final String descripcion;

  SearchResult({
    @required this.cancelo, 
    this.manual, 
    this.coordenadas, 
    this.nombreDestino, 
    this.descripcion
    });
  

}