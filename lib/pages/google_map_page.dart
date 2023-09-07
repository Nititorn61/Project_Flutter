import 'package:car_okay/models/store_model.dart';
import 'package:car_okay/pages/booking/menu_booking_page.dart';
import 'package:car_okay/widgets/maps/car_okay_view_maps.dart';
import 'package:flutter/material.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late Widget current;

  @override
  void initState() {
    current = _builder();
    super.initState();
  }

  void onPressedBack() {
    current = _builder();
    setState(() {});
  }

  Widget _builder() {
    return COMapsView(
      onChanged: (_) {},
      onTap: (StoreModel store) {
        current = MenuBookingPage(store: store, onPressedBack: onPressedBack);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: current,
    );
  }
}
