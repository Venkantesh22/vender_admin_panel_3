import 'package:flutter/material.dart';

class Dimensions {
  static late double screenHeight;
  static late double screenWidth;
  static late double screenHeightM;
  static late double screenWidthM;

// For Desktop screen
//   Width : 1232
//   Heigth : 598
// For Mobile screen
//   Width : 1232
//   Heigth : 754

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidthM = MediaQuery.of(context).size.width;
    screenHeightM = MediaQuery.of(context).size.height;
  }

  static double dimenisonNo4 =
      screenWidth <= 550 ? screenHeightM / 188.5 : screenWidth / 308;
  static double dimenisonNo5 =
      screenWidth <= 550 ? screenHeightM / 150.8 : screenWidth / 246.4;
  static double dimenisonNo8 =
      screenWidth <= 550 ? screenHeightM / 94.25 : screenWidth / 154;
  static double dimenisonNo10 =
      screenWidth <= 550 ? screenHeightM / 75.4 : screenWidth / 123.2;
  static double dimenisonNo12 =
      screenWidth <= 550 ? screenHeightM / 62.833 : screenWidth / 102.666;
  static double dimenisonNo13 = screenWidth <= 550
      ? screenHeightM / 58.615384615
      : screenWidth / 96.6153846;
  static double dimenisonNo14 =
      screenWidth <= 550 ? screenHeightM / 53.85714 : screenWidth / 88.00;
  static double dimenisonNo15 =
      screenWidth <= 550 ? screenHeightM / 50.266 : screenWidth / 82.133;
  static double dimenisonNo16 =
      screenWidth <= 550 ? screenHeightM / 47.125 : screenWidth / 77;
  static double dimenisonNo17 =
      screenWidth <= 550 ? screenHeightM / 43.88235 : screenWidth / 72.23529;
  static double dimenisonNo18 =
      screenWidth <= 550 ? screenHeightM / 41.88 : screenWidth / 68.44;
  static double dimenisonNo18_5 = screenWidth <= 550
      ? screenHeightM / 40.756756756
      : screenWidth / 66.59459;
  static double dimenisonNo20 =
      screenWidth <= 550 ? screenHeightM / 37.7 : screenWidth / 61.6;
  static double dimenisonNo22 =
      screenWidth <= 550 ? screenHeightM / 34.2727 : screenWidth / 56;
  static double dimenisonNo24 =
      screenWidth <= 550 ? screenHeightM / 31.4166 : screenWidth / 51.3333;
  static double dimenisonNo28 =
      screenWidth <= 550 ? screenHeightM / 31.4166 : screenWidth / 51.3333;
  static double dimenisonNo30 =
      screenWidth <= 550 ? screenHeightM / 26.9285714 : screenWidth / 44.00;
  static double dimenisonNo34 =
      screenWidth <= 550 ? screenHeightM / 24.1764 : screenWidth / 36.2352;
  static double dimenisonNo35 =
      screenWidth <= 550 ? screenHeightM / 21.54285 : screenWidth / 35.2;
  static double dimenisonNo36 =
      screenWidth <= 550 ? screenHeightM / 20.944 : screenWidth / 34.222;
  static double dimenisonNo38 =
      screenWidth <= 550 ? screenHeightM / 19.8421 : screenWidth / 32.42105;
  static double dimenisonNo40 =
      screenWidth <= 550 ? screenHeightM / 18.85 : screenWidth / 30.8;
  static double dimenisonNo45 =
      screenWidth <= 550 ? screenHeightM / 16.755 : screenWidth / 27.377;
  static double dimenisonNo50 =
      screenWidth <= 550 ? screenHeightM / 15.08 : screenWidth / 24.64;
  static double dimenisonNo55 =
      screenWidth <= 550 ? screenHeightM / 13.70909090909 : screenWidth / 22.4;
  static double dimenisonNo60 =
      screenWidth <= 550 ? screenHeightM / 12.566 : screenWidth / 20.533;
  static double dimenisonNo70 =
      screenWidth <= 550 ? screenHeightM / 10.7714 : screenWidth / 17.6;
  static double dimenisonNo80 =
      screenWidth <= 550 ? screenHeightM / 9.425 : screenWidth / 15.4;
  static double dimenisonNo90 =
      screenWidth <= 550 ? screenHeightM / 8.37777 : screenWidth / 13.6888888;
  static double dimenisonNo100 =
      screenWidth <= 550 ? screenHeightM / 7.54 : screenWidth / 12.32;
  static double dimenisonNo110 =
      screenWidth <= 550 ? screenHeightM / 6.854 : screenWidth / 11.2;
  static double dimenisonNo120 = screenWidth <= 550
      ? screenHeightM / 6.283333333333333
      : screenWidth / 10.2666666;
  static double dimenisonNo130 =
      screenWidth <= 550 ? screenHeightM / 5.8 : screenWidth / 9.4769;
  static double dimenisonNo140 =
      screenWidth <= 550 ? screenHeightM / 5.3857 : screenWidth / 8.8;
  static double dimenisonNo150 =
      screenWidth <= 550 ? screenHeightM / 5.0266 : screenWidth / 8.2133;
  static double dimenisonNo180 =
      screenWidth <= 550 ? screenHeightM / 4.188 : screenWidth / 6.844;
  static double dimenisonNo200 =
      screenWidth <= 550 ? screenHeightM / 3.77 : screenWidth / 6.16;
  static double dimenisonNo210 =
      screenWidth <= 550 ? screenHeightM / 3.5904 : screenWidth / 5.866666;
  static double dimenisonNo230 =
      screenWidth <= 550 ? screenHeightM / 3.27 : screenWidth / 5.3565;
  static double dimenisonNo250 =
      screenWidth <= 550 ? screenHeightM / 3.016 : screenWidth / 4.928;
  static double dimenisonNo266 =
      screenWidth <= 550 ? screenHeightM / 2.834 : screenWidth / 4.6315;
  static double dimenisonNo280 =
      screenWidth <= 550 ? screenHeightM / 2.6928514 : screenWidth / 4.4;
  static double dimenisonNo300 =
      screenWidth <= 550 ? screenHeightM / 2.5133 : screenWidth / 4.1066;
  static double dimenisonNo350 =
      screenWidth <= 550 ? screenHeightM / 2.1542 : screenWidth / 3.52;
  static double dimenisonNo360 =
      screenWidth <= 550 ? screenHeightM / 2.0944444 : screenWidth / 3.4222;
  static double dimenisonNo400 =
      screenWidth <= 550 ? screenHeightM / 1.885 : screenWidth / 3.08;
  static double dimenisonNo450 =
      screenWidth <= 550 ? screenHeightM / 1.677 : screenWidth / 2.7377;
  static double dimenisonNo500 =
      screenWidth <= 550 ? screenHeightM / 1.508 : screenWidth / 2.464;
  static double dimenisonNo600 =
      screenWidth <= 550 ? screenHeightM / 1.2566 : screenWidth / 2.053333;
  static double dimenisonNo650 =
      screenWidth <= 550 ? screenHeightM / 1.16 : screenWidth / 1.895;

  static double dimenisonNo900 =
      screenWidth <= 550 ? 900 : screenWidth / 1.36888;
  static double dimenisonNo1100 =
      screenWidth <= 550 ? 1100 : screenWidth / 1.12;

  // static double dimenisonNo15 = screenHeight / 50.133;
  // static double dimenisonNo18 = screenHeight / 41.77;
  // static double dimenisonNo20 = screenHeight / 37.6;
  // static double dimenisonNo24 = screenHeight / 31.333;
  // static double dimenisonNo30 = screenHeight / 37.9;
  // static double dimenisonNo100 = screenHeight / 7.52;
  // static double dimenisonNo300 = screenHeight / 3.79;
}
