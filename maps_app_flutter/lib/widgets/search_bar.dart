part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  //const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Container(
        margin: EdgeInsets.symmetric( vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width ,
        child: GestureDetector(
          onTap: () async {
            print('buscando..');
            final result = await showSearch(context: context, delegate: SearchDestination());
            this.retornoBusqueda(result);
          },
                  child: Container(
            width: double.infinity,
            
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
              ]
            ),
            child: Text('¿ A donde vamos ?', style: TextStyle(color: Colors.black87),),
          ),
        ),
       
      ),
    );
  }

  void retornoBusqueda(SearchResult result){
    print('Canceló: ${result.cancelo}');
      print('Manual: ${result.manual}');
    if(result.cancelo){
      return;
    }
  }
}