import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_web/responsive.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ItemProyectos extends StatefulWidget {
  const ItemProyectos(
      {super.key,
      required this.nombre,
      required this.totalAcumulado,
      required this.totalRequerido,
      required this.url});

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
    return Card(
      elevation: 50,
      color: Colors.grey[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.nombre,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Responsive(
              desktop: Text(''),
              tablet: CachedNetworkImage(
                  height: 200,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  imageUrl: widget.url),
              mobile: CachedNetworkImage(
                  height: 100,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  imageUrl: widget.url),
            ),
            SizedBox(
              height: 10,
            ),
            new LinearPercentIndicator(
              lineHeight: 14.0,
              percent: (widget.totalAcumulado.toDouble() * 1) /
                  widget.totalRequerido.toDouble(),
              center: Text(
                  '${((widget.totalAcumulado.toDouble() * 100) / widget.totalRequerido.toDouble()).toString()}%'),
              barRadius: Radius.zero,
              backgroundColor: Colors.grey,
              progressColor: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
