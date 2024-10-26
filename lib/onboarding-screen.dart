// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:project_app/Login.dart';
import 'package:project_app/onboarding-builder.dart';
import 'package:project_app/onboarding-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: PageView.builder(
              controller: _pageController,
              itemCount: data.length,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    OnboardingBuilder(
                      onBoardingModel: data[index],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: data.length,
                      axisDirection: Axis.horizontal,
                      effect: const WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: Color(0xFF8985E9),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 50,
            left: 25,
            right: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage != data.length - 1
                    ? TextButton(
                        onPressed: () {
                          _pageController.animateToPage(data.length - 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          'Skip',
                          style:
                              TextStyle(fontSize: 20, color: Color(0xFF8985E9)),
                        ),
                      )
                    : Container(),
                ElevatedButton(
                  onPressed: () {
                    if (currentPage == data.length - 1) {
                      _completeOnboarding();
                    } else {
                      // Otherwise, go to the next page
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    currentPage == data.length - 1 ? 'Get Started' : 'Continue',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true); // Set the flag

    // Navigate to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
