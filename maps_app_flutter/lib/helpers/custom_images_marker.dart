part of 'helpers.dart';

Future<Uint8List> getAssetImageMarker(String path, int width) async{
   ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}

Future<BitmapDescriptor> getNetworkImageMarker() async{
  final resp = await Dio().get(
    'https://www.flaticon.es/svg/vstatic/svg/595/595735.svg?token=exp=1615313526~hmac=2a325e289f043cf722efc1d018f8c31f',
    options: Options( responseType: ResponseType.bytes ) //porque esto no retorna un Json entonces necesitammos los bytes
  );

  final bytes = resp.data;
  //Opcional para ajustar el tamaño de la imagen
  final imageCodec = await ui.instantiateImageCodec(bytes, targetHeight: 150, targetWidth: 150);
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);//especificamos el formato 

  return  BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}