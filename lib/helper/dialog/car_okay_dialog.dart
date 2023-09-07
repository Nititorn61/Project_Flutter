import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/models/rate_model.dart';
import 'package:car_okay/models/reservation_model.dart';
import 'package:car_okay/pages/home_page.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/rating/car_okay_rating.dart';
import 'package:car_okay/widgets/text/car_okay_center_text.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CODialog {
  static void voteRate(
    BuildContext context, {
    required RateModel rate,
    required Function(RateModel) onPressed,
  }) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        double clean = rate.clean;
        double fee = rate.fee;
        double haste = rate.haste;
        double service = rate.service;
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const COText("Review", bold: true),
                    const COPadding(height: 1),
                    // การบริการ
                    // ค่าบริการ
                    // ความสะอาด
                    // ความรวดเร็ว
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const COText("การบริการ", bold: true),
                        const COPadding(height: 1),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            service = rating;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const COText("ค่าบริการ", bold: true),
                        const COPadding(height: 1),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            fee = rating;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const COText("ความสะอาด", bold: true),
                        const COPadding(height: 1),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            clean = rating;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const COText("ความรวดเร็ว", bold: true),
                        const COPadding(height: 1),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            haste = rating;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: padding,
                      child: COElevatedButton(
                        onPressed: () {
                          onPressed(
                            RateModel(
                              service: service,
                              fee: fee,
                              clean: clean,
                              haste: haste,
                            ),
                          );
                        },
                        child:
                            const COText("บันทึกข้อมูล", color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static void rating(BuildContext context, {required RateModel rate}) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        final double total =
            (rate.clean + rate.fee + rate.haste + rate.service) / 4;
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const COText("Review", bold: true),
                  const COPadding(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      const COPadding(width: 1),
                      COText(
                        total.toString(),
                        bold: true,
                      )
                    ],
                  ),
                  const COPadding(height: 1),
                  // การบริการ
                  // ค่าบริการ
                  // ความสะอาด
                  // ความรวดเร็ว
                  CORating(title: "การบริการ", rate: rate.service),
                  CORating(title: "ค่าบริการ", rate: rate.fee),
                  CORating(title: "ความสะอาด", rate: rate.clean),
                  CORating(title: "ความรวดเร็ว", rate: rate.haste),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void promotion(BuildContext context, {required String promotion}) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  COText(
                    promotion,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void verifyBooking(BuildContext context,
      {required ReservationModel model,
      required Function() onPressed,
      required Function() onCancle}) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const COText("รายการที่รับบริการ", bold: true),
                  const COPadding(height: 1),
                  ...model.servicesDetailsList.map((service) {
                    int price = service.prices
                        .where((element) => element.carType == model.carType)
                        .first
                        .price;
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: COText(service.name),
                        ),
                        Expanded(
                          flex: 1,
                          child: COText(
                            "$price",
                            textAlign: TextAlign.end,
                            color: buttonPrimaryBackground,
                          ),
                        ),
                        const COText(" ฿"),
                      ],
                    );
                  }),
                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: COText("รวมเป็นเงิน"),
                      ),
                      Expanded(
                        flex: 1,
                        child: COText(
                          model.fee.toString(),
                          textAlign: TextAlign.end,
                          color: buttonPrimaryBackground,
                        ),
                      ),
                      const COText(" ฿"),
                    ],
                  ),
                  const COPadding(height: 1),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    child: Image.network(
                      model.photoURL ?? "",
                      width: double.maxFinite,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: COElevatedButton(
                          backgroundColor: Colors.red,
                          onPressed: onCancle,
                          child: const COText(
                            "ไม่ยืนยัน",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const COPadding(width: 1),
                      Expanded(
                        child: COElevatedButton(
                          onPressed: onPressed,
                          child: const COText(
                            "ยืนยัน",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void serviceDetails(
    BuildContext context, {
    required ReservationModel model,
  }) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const COText("รายการที่รับบริการ", bold: true),
                  const COPadding(height: 1),
                  ...model.servicesDetailsList.map((service) {
                    int price = service.prices
                        .where((element) => element.carType == model.carType)
                        .first
                        .price;
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: COText(service.name),
                        ),
                        Expanded(
                          flex: 1,
                          child: COText(
                            "$price",
                            textAlign: TextAlign.end,
                            bold: true,
                            color: buttonPrimaryBackground,
                          ),
                        ),
                        const COText(" ฿"),
                        Expanded(
                          flex: 1,
                          child: COText(
                            "${service.duration}",
                            textAlign: TextAlign.end,
                            bold: true,
                            color: buttonPrimaryBackground,
                          ),
                        ),
                        const COText(" นาที"),
                      ],
                    );
                  }),
                  const COPadding(height: 1),
                  COCenterText(
                    first: "รวมเป็นเงิน",
                    middle: model.fee.toString(),
                    last: "บาท",
                  ),
                  const COPadding(height: 1),
                  COCenterText(
                    first: "ใช้เวลารวม",
                    middle: model.servicesDetailsList
                        .fold(
                            0,
                            (previousValue, element) =>
                                previousValue + element.duration)
                        .toString(),
                    last: "นาที",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void progress(BuildContext context) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/check.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  const COPadding(height: 1),
                  const COText(
                    "ยืนยันการชำระเงินค่าบริการสำเร็จ\nกรุณารอการตรวจสอบจากเจ้าหน้าที่",
                    fontSize: 18,
                    textAlign: TextAlign.center,
                  ),
                  const COPadding(height: 1),
                  COElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      CONavigator.push(
                          context,
                          const HomePage(
                            index: 1,
                            subpageIndex: 2,
                          ));
                    },
                    child: const COText(
                      "ไปหน้ารายการจอง",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void confirm(
    BuildContext context, {
    required String title,
    String content = "",
    required Function() onConfirm,
  }) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   width: MediaQuery.of(context).size.width * 0.2,
                  // ),
                  COText(
                    "$title ",
                    fontSize: 18,
                    bold: true,
                  ),
                  COText(
                    content,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: COElevatedButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const COText(
                            "ยกเลิก",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const COPadding(width: 1),
                      Expanded(
                        child: COElevatedButton(
                          onPressed: () {
                            onConfirm();
                            Navigator.of(context).pop();
                          },
                          child: const COText(
                            "ยืนยัน",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
