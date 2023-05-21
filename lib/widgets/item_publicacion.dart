import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ItemProyectos extends StatefulWidget {
  const ItemProyectos({super.key, required this.nombre,required this.totalAcumulado, required this.totalRequerido, required this.url});

  final String nombre;
  final String url;
  final int totalRequerido;
  final int totalAcumulado;

  @override
  State<ItemProyectos> createState() => _ItemProyectosState();
}

class _ItemProyectosState extends State<ItemProyectos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.nombre, style: TextStyle(color: Colors.white),),
        CachedNetworkImage(
              imageUrl: widget.url),
        SizedBox(height: 10,),
        new LinearPercentIndicator(
          lineHeight: 14.0,
          percent: (widget.totalAcumulado.toDouble() * 1) / widget.totalRequerido.toDouble(),
          center: Text('${((widget.totalAcumulado.toDouble() * 100) / widget.totalRequerido.toDouble()).toString()}%'),
          barRadius: Radius.zero,
          backgroundColor: Colors.grey,
          progressColor: Colors.amber,
        ),
      ],
    );
  }
}