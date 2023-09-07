import 'package:flutter/material.dart';

const double appBodyHeight = 600;

const double defaultBorderRadius = 20;
const double defaultPadding = 8;
const double defaultRadius = 6;
const double defaultCardRadius = 15;

const Color textColor = Colors.black;
const Color inActiveTextColor = Color.fromRGBO(33, 33, 33, 0.5);
const Color inputPrimaryBackground = Colors.white;
const Color inputPrimaryBorderColor = Color.fromRGBO(82, 145, 240, 1);
const Color appPrimaryBackground = Colors.white;
const Color appImageBackground = Color.fromRGBO(45, 45, 45, 1);
const Color buttonPrimaryBackground = Color.fromRGBO(82, 145, 240, 1);
const Color buttonSecondaryBackground = Color.fromRGBO(237, 237, 237, 1);
const Color buttonPrimaryTextColor = Color.fromRGBO(1, 61, 111, 1);
const Color appBarBackgroundColor = Colors.black87;

const EdgeInsets padding = EdgeInsets.symmetric(
  horizontal: defaultPadding * 3,
  vertical: defaultPadding,
);

//Storage keys
const String userStorageKey = "auth_user";
const String carTypesStorageKey = "car_types";
const String carTypesFetchDateStorageKey = "car_types_fetch_date";

//Error message
const String internalServerErrorMessage = "Internal server error.";
const String listEmptyMessage = "ไม่มีรายการ";

//Assets
const String logoUri = "assets/image/logo.jpg";
const String mapSvg = "assets/svg/map.svg";
const String dotsSvg = "assets/svg/dots.svg";
const String reviewUri = "assets/image/review.png";
const String reviewBlackUri = "assets/image/review_black.png";
const String promotionUri = "assets/image/promotion.png";

//Google map geocoding key
const String apiKey = "AIzaSyCFLkyRM6L1_Xgx5wr4nilQ9wpdlTwC-vA";
