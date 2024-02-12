

import 'package:flutter/material.dart';
import 'package:pilasconelhueco/onboarding/onboardingdata.dart';
import 'package:pilasconelhueco/shared/labels.dart';
import 'package:pilasconelhueco/shared/styles.dart';

class OnboardingBody extends StatelessWidget {

  final String image;
  final String title;
  final String description;

  const OnboardingBody({super.key, required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          const SizedBox(height: 80,),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          ),
          SizedBox(width: 220, child: Text(description, textAlign: TextAlign.center,))
        ],
      );
  }
  
}



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  
  @override
  OnboardingScreenState createState() {
    return OnboardingScreenState();
  }

}


class OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingItem> items = OnboardingItem.getOnboardingItems();


  @override
  Widget build(BuildContext context) {  
    return Scaffold(
    
        body: SafeArea(
          child: PageView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              OnboardingItem item = items[index];
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      Column(
                        children: [
                          Text(AlcaldiaSantaMartaText.mainText, style: TextStyle(color: ColorsPalet.primaryColor, fontWeight: FontWeight.bold),),
                          Text(AlcaldiaSantaMartaText.secondText, style: TextStyle(color: ColorsPalet.primaryColor, fontSize: 11.1)),
                        ],
                      ),
                      OnboardingBody(image: item.image, title: item.title, description: item.description),
                      const SizedBox(height: 40,),
                      Center(
                        child: SizedBox(
                          width: 53,
                          height: 13,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                    width: 23,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (i == index) ? ColorsPalet.primaryColor : ColorsPalet.itemColor,
                                    ),
                                  ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      (index == items.length - 1) 
                        ? GestureDetector(
                              onTap: () {
                                
                              },
                              child: Text(OnboardingPage.continueText, 
                                          style: const TextStyle(fontSize: 15, 
                                                          fontWeight: FontWeight.bold),),) 
                        : const SizedBox(),
                        const SizedBox(height: 20,),
                  ],
                ),
              );
            },
          ),
        ),
      );
  }

}

