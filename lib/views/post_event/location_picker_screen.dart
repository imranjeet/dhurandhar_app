import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/providers/post_event_provider.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key, this.isFromHome = false});

  final bool isFromHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: FlutterLocationPicker(
        // urlTemplate:
        //     'https://api.maptiler.com/maps/hybrid/{z}/{x}/{y}.jpg?key=5SvIZhCyE9Ez1CxReDHF',
        initPosition: defaultLocation,
        initZoom: 11,
        minZoomLevel: 5,
        maxZoomLevel: 16,
        trackMyPosition: true,
        searchBarHintColor: Colors.black,
        searchBarBackgroundColor: Colors.white,
        selectedLocationButtonTextstyle: primaryTextStyle(context, size: 18),
        mapLanguage: 'en',
        onError: (e) => CustomLogger.instance.error(e.toString()),
        selectLocationButtonLeadingIcon: const Icon(Icons.check),
        onPicked: (pickedData) async {
          CustomLogger.instance.singleLine(
              "latitude: ${pickedData.latLong.latitude}\n longitude:${pickedData.latLong.longitude} \n address: ${pickedData.address}");
          isFromHome
              ? await Provider.of<HomeScreenProvider>(context, listen: false
              )
                  .updatePickedAddress(context, pickedData.address,
                      pickedData.latLong.latitude, pickedData.latLong.longitude)
              : await Provider.of<PostEventProvider>(context, listen: false)
                  .updatePickedAddress(
                      context,
                      pickedData.address,
                      pickedData.latLong.latitude,
                      pickedData.latLong.longitude);

          // print(pickedData.latLong.latitude);
          // print(pickedData.latLong.longitude);
          // print(pickedData.address);
          // print(pickedData.addressData);
        },
        onChanged: (pickedData) {
          // print(pickedData.latLong.latitude);
          // print(pickedData.latLong.longitude);
          // print(pickedData.address);
          // print(pickedData.addressData);
        },
        showContributorBadgeForOSM: true,
      ),
    );
  }
}
