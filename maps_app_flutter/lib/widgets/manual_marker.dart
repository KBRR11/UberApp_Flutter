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
                          final busquedaBloc =
                              BlocProvider.of<BusquedaBloc>(context);
                          busquedaBloc.add(OnDesactivarManualMarker());
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
                    //TODO: hacer algo
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
}
