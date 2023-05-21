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
        ClipRRect(
          child: FadeInImage(
            fit: BoxFit.cover,
            height: 225,
            placeholder: const AssetImage('assets/loading.gif'),
            //image: const AssetImage('assets/maincraft.webp')
            image: NetworkImage(
                widget.url, scale: 1),
          ),
        ),
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