import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../utils/apis.dart';
import '../utils/messages.dart';
import '../widgets/expandable_widget.dart';
import '../widgets/widget_text.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({Key? key, required this.productId,
    required this.productName, required this.hasReview}) : super(key: key);
  final String productId;
  final String productName;
  final bool hasReview;

  final ProductController productController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(MdiIcons.arrowLeft, size: 25),
                        )
                    ),
                  ),

                  Row(
                    children: [
                      Column(
                        children: [
                          WidgetText(text: productName, font: 'montserrat_bold',
                              size: 15, alignment: TextAlign.center, maxLines: 2),
                          const WidgetText(text: 'Reviews', font: 'montserrat_bold',
                              size: 20, alignment: TextAlign.center),
                        ],
                      ),
                    ],
                  ),

                  Visibility(
                    visible: Apis.client.auth.currentUser == null,
                    child: GestureDetector(
                    onTap: (){
                      if(hasReview){

                      }
                      else{

                      }
                    },
                    child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: hasReview ? const Icon(Icons.edit_outlined, size: 25) :
                          const Icon(Icons.add_outlined, size: 25),
                        )
                    ),
                  )
                  )

                ],
              ),

              FutureBuilder(
                  future: productController.fetchProductReview(productId),
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Center(child: WidgetText(text: snapshot.error.toString()));
                    }
                    else if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                      return showReviewWidget(snapshot, size);
                    }
                    return  Column(
                      children: const [
                        SizedBox(height: 250.0),
                        spinkit,
                      ],
                    );

                  }
              )
            ],
          ),
        )
      )
    );
  }

  Widget showReviewWidget(AsyncSnapshot snap, Size size){
    return snap.data.length != 0 ?
    Column(
      children: [
        const SizedBox(height: 15.0),
        WidgetText(text: '4.5', font: 'montserrat_bold',
            size: 50, alignment: TextAlign.center, maxLines: 2),
        Obx(() => SmoothStarRating(
            onRatingChanged: (v) {
            },
            starCount: 5,
            rating: productController.starSum.value,
            size: 35.0,
            color: Colors.black,
            borderColor: Colors.black,
            spacing: 1.0
        )),
        const SizedBox(height: 10.0),
        productController.userCount.value == 1 ?
        WidgetText(text: 'Based on ${productController.userCount.value} review', size: 14) :
        WidgetText(text: 'Based on ${productController.userCount.value} reviews', size: 14),

        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const WidgetText(text: 'Excellent', size: 14),
            LinearPercentIndicator(
              width: size.width / 1.6,
              lineHeight: 10.0,
              percent: 0.8,
              animation: true,
              barRadius: const Radius.circular(5.0),
              backgroundColor: Colors.grey,
              progressColor: Colors.green,
            ),
          ],
        ),

        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const WidgetText(text: 'Good', size: 14),
            LinearPercentIndicator(
              width: size.width / 1.6,
              lineHeight: 10.0,
              percent: 0.6,
              animation: true,
              barRadius: const Radius.circular(5.0),
              backgroundColor: Colors.grey,
              progressColor: Colors.lightGreen,
            ),
          ],
        ),

        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const WidgetText(text: 'Average', size: 14),
            LinearPercentIndicator(
              width: size.width / 1.6,
              lineHeight: 10.0,
              percent: 0.4,
              animation: true,
              barRadius: const Radius.circular(5.0),
              backgroundColor: Colors.grey,
              progressColor: Colors.yellow,
            ),
          ],
        ),

        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const WidgetText(text: 'Poor', size: 14),
            LinearPercentIndicator(
              width: size.width / 1.6,
              lineHeight: 10.0,
              percent: 0.2,
              animation: true,
              barRadius: const Radius.circular(5.0),
              backgroundColor: Colors.grey,
              progressColor: Colors.red,
            ),
          ],
        ),

        const SizedBox(height: 15.0),
        SizedBox(
          child: ListView.builder(
                itemCount: snap.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  final duration = DateTime.parse(snap.data[index]['created_at']);
                  return Container(
                    width: size.width,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        width: 1,
                        color: Colors.black
                      )
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                snap.data[index]['profiles']['avatar_url'] == null ?
                                CircleAvatar(
                                  radius: 30,
                                  child: Image.asset('assets/images/avatar.png'),
                                ) :
                                CircleAvatar(
                                  radius: 30,
                                  child: Image.network(snap.data[index]['profiles']['avatar_url']),
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WidgetText(text: snap.data[index]['profiles']['name']),
                                    Row(
                                      children: [
                                        SmoothStarRating(
                                          onRatingChanged: (v) {
                                          },
                                          starCount: 5,
                                          rating: (snap.data[index]['stars'] * 1.0),
                                          size: 19.0,
                                          color: Colors.black,
                                          borderColor: Colors.black,
                                          spacing: 0.0
                                        ),
                                        const SizedBox(width: 5.0),
                                        WidgetText(text: '${snap.data[index]['stars']} / 5', size: 11)
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),

                            WidgetText(text: getVerboseDateTimeRepresentation(duration), size: 10)
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        ExpandableText(snap.data[index]['review'] ?? ''),
                      ],
                    ),
                  );
                }
            )
        ),

        const SizedBox(height: 255.0),




      ],
    ) :
    SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 150),
          const WidgetText(text: 'No Review Yet'),
          const WidgetText(text: 'Be the first to leave a review', size: 12),
          SizedBox(height: 60),
          GestureDetector(
            onTap: (){

            },
            child: Container(
                height: 40,
                width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border:  Border.all(
                        width: 2,
                        color: Colors.black
                    )
                ),
                child: const Center(
                  child: WidgetText(text: 'Add Review', size: 18),
                )
            ),
          ),
        ],
      ),
    );
  }

  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now().toLocal();

    DateTime localDateTime = dateTime.toLocal();

    if (localDateTime.difference(now).inDays == 0) {
      var differenceInHours = localDateTime.difference(now).inHours.abs();
      var differenceInMins = localDateTime.difference(now).inMinutes.abs();

      if (differenceInHours > 0) {
        return '$differenceInHours hours ago';
      } else if (differenceInMins > 2) {
        return '$differenceInMins mins ago';
      } else {
        return 'Just now';
      }
    }

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat(
        'EEEE',
      ).format(localDateTime);

      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
