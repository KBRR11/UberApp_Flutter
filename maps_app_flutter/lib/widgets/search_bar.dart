part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return buildSearchbar(context);
        }
      },
    );
  }

  Widget buildSearchbar(BuildContext context) {
    return SafeArea(
      child: SlideInDown(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () async {
              final miUbicacion =
                  BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
              final historial =
                  BlocProvider.of<BusquedaBloc>(context).state.historial;
              final result = await showSearch(
                  context: context,
                  delegate: SearchDestination(miUbicacion, historial));
              this.retornoBusqueda(context, result);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 5))
                  ]),
              child: Text(
                '¿ A donde vamos ?',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> retornoBusqueda(
      BuildContext context, SearchResult result) async {
    if (result.cancelo) return;

    //calcular ruta en base al valor result
    if (!result.cancelo && !result.manual) {
      //quiere decir que la busqueda se hizo por query
      calculandoAlerta(context);
      final trafficService = new TrafficService();

      final miUbicacion =
          BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
      final destino = result.coordenadas;

      final drivingResponse =
          await trafficService.getCoordsInicioYDestino(miUbicacion, destino);

      final geometry = drivingResponse.routes[0].geometry;
      final distancia = drivingResponse.routes[0].distance;
      final duracion = drivingResponse.routes[0].duration;
      final nombreDestino = result.nombreDestino;

      final points =
          Poly.Polyline.Decode(encodedString: geometry, precision: 6);
      final List<LatLng> rutaCoordenadas = points.decodedCoords
          .map((point) => LatLng(point[0], point[1]))
          .toList();
      
      BlocProvider.of<MapaBloc>(context).add(OnCrearRutaInicioFin(
          rutaCoordenadas: rutaCoordenadas,
          distance: distancia,
          duration: duracion,
          nombreDestino: nombreDestino));
      BlocProvider.of<BusquedaBloc>(context).add(OnDesactivarBusquedaQuery());
      Navigator.of(context).pop();
      //Agregamos el lugar seleccionado al historial
      BlocProvider.of<BusquedaBloc>(context).add(OnAddHistorial(result));
    }
  }
}
