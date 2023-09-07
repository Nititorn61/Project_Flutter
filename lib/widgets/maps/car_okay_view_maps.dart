import 'dart:async';

import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/models/store_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class COMapsView extends StatefulWidget {
  final Function(LatLng) onChanged;
  final Function(StoreModel) onTap;
  final LatLng? center;

  const COMapsView(
      {super.key, required this.onChanged, this.center, required this.onTap});

  @override
  State<COMapsView> createState() => _COMapsViewState();
}

class _COMapsViewState extends State<COMapsView> {
  late StoreCubit _storeCubit;
  late GoogleMapController _mapController;
  late List<Marker> markers = [];
  List<StoreModel> storeList = [];

  late LatLng _center;
  final TextEditingController _controller = TextEditingController();
  List<StoreModel> _predictionPlaceList = [];

  @override
  void initState() {
    _storeCubit = context.read<StoreCubit>();
    _center = widget.center ?? const LatLng(18.7880315, 98.98563493);
    _init();

    super.initState();
  }

  Future<void> _init() async {
    List<StoreModel> list = await _storeCubit.getStoreList();
    storeList = list;
    for (var store in list) {
      markers.add(
        Marker(
          markerId: MarkerId(store.name),
          position: LatLng(store.location.latitude, store.location.longitude),
          infoWindow: InfoWindow(
            title: store.name,
            snippet: "เปิด ${store.open} ⋅ ปิด ${store.close}",
            onTap: () {
              widget.onTap(store);
            },
          ),
        ),
      );
    }
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // for (var store in storeList) {
    // _mapController.showMarkerInfoWindow(MarkerId(store.name));
    // }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _predictionPlaceList = [];
    } else {
      _predictionPlaceList = storeList
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _onTapSuggestion(StoreModel prediction) async {
    _controller.text = prediction.name;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _controller.text.length,
      ),
    );
    LatLng latlng =
        LatLng(prediction.location.latitude, prediction.location.longitude);
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latlng,
          zoom: 16,
        ),
      ),
    );
    widget.onChanged(latlng);

    _predictionPlaceList = [];
    setState(() {});
  }

  void _onPressedClear() {
    _controller.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height +
        MediaQuery.of(context).padding.top +
        defaultPadding;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: COTextSearchField(
          controller: _controller,
          onChanged: _onSearchChanged,
          onPressedClear: _onPressedClear,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      floatingActionButton: Column(
        children: [
          SizedBox(
            height: appBarHeight,
          ),
          Visibility(
            visible: _predictionPlaceList.isNotEmpty,
            child: Column(
              children: _predictionPlaceList.map((place) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () => _onTapSuggestion(place),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding * 2,
                      ),
                      color: inputPrimaryBackground,
                      width: double.maxFinite,
                      child: COText(place.name),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13,
        ),
        compassEnabled: true,
        myLocationEnabled: true,
        markers: Set.from(markers),
      ),
    );
  }
}
