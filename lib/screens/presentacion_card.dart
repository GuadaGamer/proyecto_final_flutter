import 'package:firebase_app_web/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CardData {
  final String title;
  final String subtitle;
  final Color backgraundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? backgraund;
  final Icon icono;

  const CardData({
    required this.title,
    required this.subtitle,
    required this.backgraundColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.icono,
    this.backgraund,
  });
}

class CardApi extends StatelessWidget {
  const CardApi({required this.data, super.key});

  final CardData data;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Stack(
        fit: StackFit.passthrough,
        children: [
          data.backgraund!,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            child: Column(
              children: [
                const Spacer(
                  flex: 80,
                ),
                Text(
                  data.title.toUpperCase(),
                  style: TextStyle(
                    color: data.titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                Flexible(
                    flex: 20,
                    child: data.icono),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    color: data.subtitleColor,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                )
              ],
            ),
          ),
        ],
      ),
      tablet: Stack(
        children: [
          Lottie.asset('assets/obscuro.json'),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,150,0,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    data.title.toUpperCase(),
                    style: TextStyle(
                        color: data.titleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    width: 300,
                    child: Text(
                      data.subtitle,
                      style: TextStyle(
                        color: data.subtitleColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      textWidthBasis: TextWidthBasis.longestLine,
                      maxLines: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: data.icono)
        ],
      ),
      desktop: Text(''),
    );
  }
}
