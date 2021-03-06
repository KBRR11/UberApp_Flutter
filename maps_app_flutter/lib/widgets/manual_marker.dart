part of 'widgets.dart';

class ManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return _BuildManualMarker();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
              top: 30,
              left: 20,
              child: ZoomIn(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 5))
                      ]),
                  child: CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () {
                          BlocProvider.of<BusquedaBloc>(context)
                              .add(OnDesactivarManualMarker());
                        }),
                  ),
                ),
              )),
          Center(
            child: Transform.translate(
                offset: Offset(0, -25),
                child: BounceInDown(
                  from: 200,
                  child: Icon(
                    Icons.location_on_sharp,
                    size: 40,
                  ),
                )),
          ),
          Positioned(
              bottom: MediaQuery.of(context).size.height * 0.05,
              left: 40,
              child: ZoomIn(
                child: MaterialButton(
                  onPressed: () {
                    this.calcularDestino(context);
                  },
                  child: Text('Confirmar ubicación',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.black,
                  minWidth: MediaQuery.of(context).size.width - 120,
                  shape: StadiumBorder(),
                  elevation: 0,
                ),
              ))
        ],
      ),
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficService = new TrafficService();

    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = BlocProvider.of<MapaBloc>(context).state.ubicacionCentral;
    //Obtener información del destino
    final reverseQueryResponse =
        await trafficService.getCoordenadasInfo(destino);

    final trafficResponse =
        await trafficService.getCoordsInicioYDestino(inicio, destino);
    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;
    final nombreDestino = reverseQueryResponse.features[0].text;
    //decodificar los puntos que vienen en geometry
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> rutaManual =
        points.map((point) => LatLng(point[0], point[1])).toList();
    //print(points);
    BlocProvider.of<MapaBloc>(context).add(OnCrearRutaInicioFin(
        rutaCoordenadas: rutaManual,
        distance: distance,
        duration: duration,
        nombreDestino: nombreDestino));

    BlocProvider.of<BusquedaBloc>(context).add(OnDesactivarManualMarker());
    Navigator.of(context).pop();
  }
}
