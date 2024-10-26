class OnBoardingModel {
  String? pic;
  String? disc;
  String? title;

  OnBoardingModel({this.pic, this.disc, this.title});
}

List<OnBoardingModel> data = [
  OnBoardingModel(
    pic: "assets/images/welcom.gif",
    title: 'Welcome to HabitFlow!',
    disc:
        'Take control of your habits and transform your life with HabitFlow. Let\'s get started!',
  ),
  OnBoardingModel(
    pic: "assets/images/Plan2gif.gif",
    title: 'Track Your Progress',
    disc:
        'With intuitive progress tracking, HabitFlow makes it easy to stay focused and accountable.',
  ),
  OnBoardingModel(
    pic: "assets/images/bealtra.gif",
    title: 'Stay Motivated',
    disc:
        'Unlock your potential with HabitFlow by building new habits and sticking to your goals!',
  )
];
