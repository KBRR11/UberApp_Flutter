import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app_flutter/helpers/helpers.dart';
import 'package:maps_app_flutter/themes/map_theme.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(new MapaState());

  //Controlador del Mapa
  GoogleMapController _mapController;
  //Polylines
  Polyline _miRuta = new Polyline(
      polylineId: PolylineId('_miRuta'), color: Colors.transparent, width: 4);
  Polyline _miRutaManual = new Polyline(
      polylineId: PolylineId('_miRutaManual'), color: Colors.black87, width: 4);

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapaListo) {
      print('Mapa Listo');
      yield state.copyWith(mapaListo: true);
    } else if (event is OnNewLocation) {
      //print('New Location: ${event.ubicacion}');
      yield* this._onNewLocation(event);
    } else if (event is OnMarcarRecorrido) {
      yield* this._onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* this._onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      //print('Centro mapa: ${event.centroMapa}');
      //print('Mapa Siguiendo: ${this._miRuta.points[this._miRuta.points.length - 1]}');
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCrearRutaInicioFin) {
      yield* this._onCrearRutaInicioFin(event);
    }
  }

  Stream<MapaState> _onNewLocation(OnNewLocation event) async* {
    if (state.seguirUbicacion) {
      this.moverCamara(event.ubicacion);
    }
    List<LatLng> points = [...this._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
    } else {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, polylines: currentPolylines);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      this.moverCamara(this._miRuta.points[this._miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCrearRutaInicioFin(OnCrearRutaInicioFin event) async* {
    this._miRutaManual =
        _miRutaManual.copyWith(pointsParam: event.rutaCoordenadas);
    final currentPolylines = state.polylines;
    currentPolylines['_miRutaManual'] = this._miRutaManual;

    //final iconBlack = await getAssetImageMarker('assets/pin-black.png', 100);
    //final iconRed = await getAssetImageMarker('assets/pin-red.png', 100);
    final iconWidgetInicio = await getMarkerInicioIcon(event.duration.toInt());
    final iconWidgetDestino =
        await getMarkerDestinoIcon(event.nombreDestino, event.distance);
    final markerInicio = new Marker(
        anchor: Offset(0.0, 1.0),
        markerId: MarkerId('inicio'),
        position: event.rutaCoordenadas[0],
        icon:
            iconWidgetInicio, //BitmapDescriptor.fromBytes(iconRed),//!cambiamos a widget convertido a Imagen
        infoWindow: InfoWindow(
          title: 'Mi Ubicación',
          snippet: 'te encuentras aquí.',
        ));

    final marcadorFin =
        event.rutaCoordenadas.length - 1; //posición de la coordenada de destino

    double kilometros = event.distance / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;
    final markerFin = new Marker(
        anchor: Offset(0.1, 0.90),
        markerId: MarkerId('fin'),
        position: event.rutaCoordenadas[marcadorFin],
        icon:
            iconWidgetDestino, //BitmapDescriptor.fromBytes(iconBlack),//!cambiamos a widget convertido a Imagen
        infoWindow: InfoWindow(
            title: '${event.nombreDestino}',
            snippet:
                'Distancia: $kilometros Km, Tiempo estimado: ${(event.duration / 60).floor()} min.'));

    final newMarkers = {...state.markers}; //desestructuramos del MapaState
    newMarkers['inicio'] =
        markerInicio; //creamos una nueva llave en el map llamado 'inicio'
    newMarkers['fin'] = markerFin;

    Future.delayed(Duration(milliseconds: 300)).then((value) {
      //_mapController
      //    .showMarkerInfoWindow(MarkerId('fin')); //solo deja mostrar uno
    });

    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }
}
