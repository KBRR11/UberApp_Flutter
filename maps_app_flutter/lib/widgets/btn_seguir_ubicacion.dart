
part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    return BlocBuilder<MapaBloc,MapaState>(builder: (BuildContext context, state) { 
      return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child:  IconButton(icon: mapaBloc.state.seguirUbicacion
        ?Icon(Icons.pause, color: Colors.black87,)
        :Transform.rotate(
          angle: - math.pi / 2,
          child: Container(child: Icon(Icons.send_outlined, color: Colors.black87,))), 
            onPressed: (){
             mapaBloc.add(OnSeguirUbicacion());
            }
            ),
          ),
        
      );
     },);
    
  }
}