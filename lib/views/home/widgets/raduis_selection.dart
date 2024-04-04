import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';

class RadiusSelectionBottomSheet extends StatefulWidget {
  const RadiusSelectionBottomSheet({super.key});

  @override
  State<RadiusSelectionBottomSheet> createState() =>
      _RadiusSelectionBottomSheetState();
}

class _RadiusSelectionBottomSheetState
    extends State<RadiusSelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Radius (km)',
            style: primaryTextStyle(context, weight: FontWeight.bold, size: 18),
          ),
          SizedBox(height: 8.fh),
          Slider(
            value: eventsAroundRadius,
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: (value) {
              setState(() {
                eventsAroundRadius = value;
              });
              // widget.callback();
            },
          ),
          SizedBox(height: 8.fh),
          Text('${eventsAroundRadius.toStringAsFixed(0)} km'),
        ],
      ),
    );
  }
}
