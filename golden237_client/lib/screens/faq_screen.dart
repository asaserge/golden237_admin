import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:golden237_client/widgets/widget_text.dart';

import '../utils/messages.dart';
import '../widgets/faq_widget.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const WidgetText(text: 'FAQ'),
      ),

      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.black,
          useInkWell: true,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: const [
              SizedBox(height: 20),
              FaqWidget(
                title: 'What is $appName?',
                subTitle:
                    '$appName is the best online shopping platform in Cameroon that connects products and customers seamlessly '
                    'and delivers on time at their doorstep through a simple yet beautiful user interface.',
              ),
              FaqWidget(
                title: 'Is $appName a secured platform?',
                subTitle:
                    'At $appName, your transactions are secured and your personal data is kept private on a dedicated server. '
                    'We do NOT integrate with big tech companies that steal and sell your data, checkout privacy policy for more.',
              ),
              FaqWidget(
                title: 'Does $appName owns shops?',
                subTitle:
                    '$appName is an online shopping platform, we do NOT own any products displayed on our platforms, '
                    'we only partner with the best stores in town that sell locally and internationally.',
              ),
              FaqWidget(
                title: 'What can I order at $appName?',
                subTitle:
                    '$appName does not own products, we simply connect customers to products and do their delivery.',
              ),

              FaqWidget(
                title: 'What payment methods are available on $appName?',
                subTitle:
                    'We accept MTN MoMo, Orange Money and $appName Loyalty Points.',
              ),

              FaqWidget(
                title: 'My order came in with wrong attributes, what do I do?',
                subTitle: 'Do not use the product, if you are certain that your package was tempered with upon delivery, '
                    'take a picture and place a report on our app, we will redo a delivery cost free and compensate you for your time wasted. '
                    'Our clients safety and satisfaction is our priority.',
              ),

              FaqWidget(
                title:
                    'I placed an order and I wasn\'t at the designated location, the delivery guy has gone with my order, what do I do?',
                subTitle:
                    'After placing an order, you will get step by step notification of the delivery guys progress, when the delivery reaches at '
                    'your destination, he has a maximum of 5 minutes to spare. After which he leaves, in that case, you will need to reorder by going '
                    'to my orders on the main menu, then navigate to failed orders on the navigation tap, click on reorder. Note, you will only '
                    'be charged for the delivery fee.',
              ),

              FaqWidget(
                title:
                    'I was gifted Loyalty Points by someone, I didn\'t receive it or it doesn\'t sum up',
                subTitle:
                    'Kindly contact our customer support team, we will resolve it in no time.',
              ),

              FaqWidget(
                title:
                    'I am a business owner, how do I feature in your platform?',
                subTitle:
                    'Contact us with the following information, your store supporting documents including your tax payers number, '
                    'your location and a picture of the exterior and interior of your store. You will be notified by email and our agents will '
                    'pass by for physical sanitation inspection before further processing, if everything works out fine, your account will be '
                    'created by team of experts and your credentials will be forwarded to you with the $appName app.',
              ),

              FaqWidget(
                title: 'How does the referral system work?',
                subTitle:
                    'Share the app to family and friends together with your referral code, they use your code upon signup, when they make their '
                    ' fist purchase, you receive a commission which is called Referral Loyalty Points which you can use to place  '
                    'an order on $appName or redeem into cash',
              ),

              FaqWidget(
                title: 'Is there any other way to gain Loyalty Points?',
                subTitle:
                    'Yes, there is more, each time you place an order, you automatically gain points depending on the amount of the order. '
                    'This is called Delivery Loyalty Points which you can use to place an order on $appName or redeem into cash',
              ),

              FaqWidget(
                  title: 'I was charged but my order wasn\'t confirmed!',
                  subTitle:
                      'Man made machines but machines sometimes turn to fail man, if this happens to you, chill! Please immediately contact us through our app and '
                      'provide us with a screenshot of the transaction details and we will sort it out as soon as possible. You won\'t loose your money!'),
              FaqWidget(
                title: 'Does $appName offer employment?',
                subTitle:
                    'As we are a fast growing platform, the hunt for employees will always be imminent, we offer delivery guy employment,'
                    ' customer service representative job and IT job, leave us an email on contact@damee237.com precising your desired role, '
                    'we will contact you for interview if need be.',
              ),
              FaqWidget(
                title: 'Can I order for someone else?',
                subTitle:
                    'Yes you can order for your love ones, note that you will need to check the box at the end of the '
                    'checkout screen to include their phone number. Placing an order without the recipients\'t phone number is risky.',
              ),
              FaqWidget(
                title: 'What is $appName doing to help it\'s community?',
                subTitle:
                    'Our main goal is to make the world a better place, starting with where we come from, where we operate and then the world at large. '
                    '$appName started effectively at the end of 2022, at this moment, we are still racing to place ourselves amongst the best in the midst of our competitors, '
                    'nevertheless, we have helped many young Cameroonians so far, we have created employment opportunities for many irrespective of gender. '
                    'we have created a startup called ASAtech to nurture young developers in the Silicon Mountain area and lastly we are planning on operating the largest charity '
                    'organisation in Cameroon to help the internally displaced persons from the Northwest and Southwest regions of Cameroon.'
                    '.',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
