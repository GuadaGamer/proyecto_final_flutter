
import 'package:firebase_app_web/responsive.dart';
import 'package:flutter/material.dart';

class CardData {
  final String title;
  final String subtitle;
  //final ImageProvider image;
  final Color backgraundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? backgraund;
  final Icon icono;

  const CardData({
    required this.title,
    required this.subtitle,
    //required this.image,
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
                Flexible(flex: 20, child: Icon(Icons.next_plan, size: 80, color: data.titleColor,)),
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
      desktop: Stack(
        children: [
          if (data.backgraund != null) data.backgraund!,
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 260),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Flexible(
                  //  child: Image(image: data.image),
                 // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}