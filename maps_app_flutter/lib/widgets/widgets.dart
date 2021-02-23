import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app_flutter/bloc/busqueda/busqueda_bloc.dart';
import 'package:maps_app_flutter/bloc/mapa/mapa_bloc.dart';
import 'package:maps_app_flutter/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:polyline/polyline.dart' as Poly;

import 'package:maps_app_flutter/model/search_result.dart';
import 'dart:math' as math;

import 'package:maps_app_flutter/search/search_destination.dart';
import 'package:maps_app_flutter/services/traffic_service.dart';

part 'btn_ubicacion.dart';
part 'btn_mi_ruta.dart';
part 'btn_seguir_ubicacion.dart';
part 'search_bar.dart';
part 'manual_marker.dart';
