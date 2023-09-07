import 'dart:async';

import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_text_button.dart';
import 'package:car_okay/widgets/maps/car_okay_maps_utils.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class COMaps extends StatefulWidget {
  final Function(LatLng) onSelected;
  final LatLng? center;

  const COMaps({super.key, required this.onSelected, this.center});

  @override
  State<COMaps> createState() => _COMapsState();
}

class _COMapsState extends State<COMaps> {
  late GoogleMapController _mapController;
  List<Marker> _markers = [];

  late LatLng _center;
  Timer? _debounce;
  final TextEditingController _controller = TextEditingController();
  List<AutocompletePrediction> _predictionPlaceList = [];

  @override
  void initState() {
    _center = widget.center ?? const LatLng(18.7880315, 98.98563493);
    if (widget.center != null) {
      _markers = [
        Marker(
          markerId: const MarkerId("create"),
          position: _center,
          draggable: true,
          onDragEnd: (LatLng latLng) {
            _onDragMarker(latLng);
          },
        ),
      ];
    }

    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onDragMarker(LatLng point) {
    final mark = Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      draggable: true,
      onDragEnd: (LatLng latLng) {
        _onDragMarker(latLng);
      },
    );
    _markers = [mark];
    setState(() {});
  }

  void _onTap(LatLng point) {
    _markers = [
      Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        draggable: true,
        onDragEnd: (LatLng latLng) {
          _onDragMarker(latLng);
        },
      ),
    ];
    setState(() {});
  }

  Future<void> _placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input": query,
        "key": apiKey,
      },
    );

    String? response = await COMapsUtils.fetchUrl(uri);
    if (response != null) {
      COMapsAutoCompleteResponse autoCompleteResponse =
          COMapsAutoCompleteResponse.parseAutocompleteResult(response);
      if (autoCompleteResponse.predictions != null) {
        _predictionPlaceList = autoCompleteResponse.predictions!;
        setState(() {});
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _placeAutoComplete(query);
    });
  }

  void _onTapSuggestion(AutocompletePrediction prediction) async {
    _controller.text = prediction.description ?? _controller.text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _controller.text.length,
      ),
    );
    LatLng? latlng =
        await COMapsUtils.getLatLongFromPlaceId(prediction.placeId!);
    if (latlng != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latlng,
            zoom: 13,
          ),
        ),
      );
      _markers = [
        Marker(
          markerId: MarkerId(prediction.placeId!),
          position: latlng,
          infoWindow: InfoWindow(
            title: prediction.description,
          ),
          draggable: true,
          onDragEnd: (LatLng latLng) {
            _onDragMarker(latLng);
          },
        ),
      ];
    }

    _predictionPlaceList = [];
    setState(() {});
  }

  void _onPressedClear() {
    _markers = [];
    _predictionPlaceList = [];
    _controller.clear();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const COAppBarText("ตำแหน่งที่ตั้ง"),
        actions: [
          Visibility(
            visible: _markers.isNotEmpty,
            child: COTextButton(
              onPressed: () {
                widget.onSelected(
                  LatLng(
                    _markers.first.position.latitude,
                    _markers.first.position.longitude,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const COText(
                "ยืนยัน",
                bold: true,
                color: Colors.white,
              ),
            ),
          ),
        ],
        elevation: 1,
        backgroundColor: Colors.black87,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13,
              ),
              myLocationEnabled: true,
              markers: Set.from(_markers),
              onTap: _onTap,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: COTextField(
                      key: const Key("Search Textfield"),
                      controller: _controller,
                      onChanged: _onSearchChanged,
                      onPressedClear: _onPressedClear,
                      isHaveClearText: true,
                      label: "",
                    ),
                  ),
                  Visibility(
                    visible: _predictionPlaceList.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        children: _predictionPlaceList.map((place) {
                          return InkWell(
                            onTap: () => _onTapSuggestion(place),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                                vertical: defaultPadding * 2,
                              ),
                              color: inputPrimaryBackground,
                              width: double.maxFinite,
                              child: COText(
                                place.description ?? "",
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
