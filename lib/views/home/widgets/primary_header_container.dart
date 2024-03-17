import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/circular_container.dart';
import 'package:dhurandhar/utils/widgets/curved_edges_widget.dart';
import 'package:flutter/material.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key,
    required this.child, this.height = 200,
  });

  final double? height;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        color: primaryColor.withOpacity(0.8),
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: height!.fh,
          child: Stack(
            children: [
              Positioned(
                  top: -150,
                  left: -300,
                  child: TCircularContainer(
                      backgroundColor: textWhite.withOpacity(0.1))),
              Positioned(
                  top: 100,
                  left: -350,
                  child: TCircularContainer(
                      backgroundColor: textWhite.withOpacity(0.1))),
              Positioned(
                  top: -150,
                  right: -300,
                  child: TCircularContainer(
                      backgroundColor: textWhite.withOpacity(0.1))),
              Positioned(
                  top: 100,
                  right: -300,
                  child: TCircularContainer(
                      backgroundColor: textWhite.withOpacity(0.1))),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
