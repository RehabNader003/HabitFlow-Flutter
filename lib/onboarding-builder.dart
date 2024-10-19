import 'package:flutter/material.dart';
import 'package:project_app/onboarding-model.dart';

class OnboardingBuilder extends StatelessWidget {
  final OnBoardingModel onBoardingModel; // Ensure this is a required field

  const OnboardingBuilder({super.key, required this.onBoardingModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "${onBoardingModel.pic}",
          ),
          const SizedBox(height: 25),
          Text(
            "${onBoardingModel.title}",
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "${onBoardingModel.disc}",
            style: const TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
