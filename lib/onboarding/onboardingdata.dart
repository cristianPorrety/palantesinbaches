

import 'package:flutter/material.dart';
import 'package:pilasconelhueco/shared/labels.dart';

class OnboardingItem {

  final String image;
  final String title;
  final String description;

  OnboardingItem({required this.image, required this.title, required this.description});


  static List<OnboardingItem> getOnboardingItems() {
    return [
      OnboardingItem(
      image: "assets/img/undraw_editable_re_4l94.png", 
      title: OnboardingPage.firstScreenTitle, 
      description: OnboardingPage.firstScreenDescription),
      OnboardingItem(
      image: "assets/img/undraw_message_sent_re_q2kl.png", 
      title: OnboardingPage.secondScreenTitle, 
      description: OnboardingPage.secondScreenDescription)
    ];
  }


}
