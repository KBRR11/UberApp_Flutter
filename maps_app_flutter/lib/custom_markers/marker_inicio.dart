import 'package:flutter/material.dart';

class MarkerInicioPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    final double circuloNegroR = 20;    
    final double circuloBlancoR = 7;

    Paint paint = new Paint()
      ..color = Colors.black87; // es lo mismo que poner paint.color = Colors.black87;

    //* Dibujar Circulo Negro 
    canvas.drawCircle(
      Offset(circuloNegroR, size.height-circuloNegroR), 
      circuloNegroR, 
      paint); 

    paint.color = Colors.white;
    //* Dibujar Circulo blanco 
    canvas.drawCircle(
      Offset(circuloNegroR, size.height - circuloNegroR), 
      circuloBlancoR, 
      paint);   

      
  }

  @override
  bool shouldRepaint(MarkerInicioPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerInicioPainter oldDelegate) => false;
}