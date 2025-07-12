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

  static double dimensionNo4 =
      screenWidth <= 550 ? screenHeightM / 188.5 : screenWidth / 308;
  static double dimensionNo5 =
      screenWidth <= 550 ? screenHeightM / 150.8 : screenWidth / 246.4;
  static double dimensionNo8 =
      screenWidth <= 550 ? screenHeightM / 94.25 : screenWidth / 154;
  static double dimensionNo10 =
      screenWidth <= 550 ? screenHeightM / 75.4 : screenWidth / 123.2;
  static double dimensionNo12 =
      screenWidth <= 550 ? screenHeightM / 62.833 : screenWidth / 102.666;
  static double dimensionNo13 = screenWidth <= 550
      ? screenHeightM / 58.615384615
      : screenWidth / 96.6153846;
  static double dimensionNo14 =
      screenWidth <= 550 ? screenHeightM / 53.85714 : screenWidth / 88.00;
  static double dimensionNo15 =
      screenWidth <= 550 ? screenHeightM / 50.266 : screenWidth / 82.133;
  static double dimensionNo16 =
      screenWidth <= 550 ? screenHeightM / 47.125 : screenWidth / 77;
  static double dimensionNo17 =
      screenWidth <= 550 ? screenHeightM / 43.88235 : screenWidth / 72.23529;
  static double dimensionNo18 =
      screenWidth <= 550 ? screenHeightM / 41.88 : screenWidth / 68.44;
  static double dimensionNo18_5 = screenWidth <= 550
      ? screenHeightM / 40.756756756
      : screenWidth / 66.59459;
  static double dimensionNo20 =
      screenWidth <= 550 ? screenHeightM / 37.7 : screenWidth / 61.6;
  static double dimensionNo22 =
      screenWidth <= 550 ? screenHeightM / 34.2727 : screenWidth / 56;
  static double dimensionNo24 =
      screenWidth <= 550 ? screenHeightM / 31.4166 : screenWidth / 51.3333;
  static double dimensionNo28 =
      screenWidth <= 550 ? screenHeightM / 31.4166 : screenWidth / 51.3333;
  static double dimensionNo30 =
      screenWidth <= 550 ? screenHeightM / 26.9285714 : screenWidth / 44.00;
  static double dimensionNo34 =
      screenWidth <= 550 ? screenHeightM / 24.1764 : screenWidth / 36.2352;
  static double dimensionNo35 =
      screenWidth <= 550 ? screenHeightM / 21.54285 : screenWidth / 35.2;
  static double dimensionNo36 =
      screenWidth <= 550 ? screenHeightM / 20.944 : screenWidth / 34.222;
  static double dimensionNo38 =
      screenWidth <= 550 ? screenHeightM / 19.8421 : screenWidth / 32.42105;
  static double dimensionNo40 =
      screenWidth <= 550 ? screenHeightM / 18.85 : screenWidth / 30.8;
  static double dimensionNo45 =
      screenWidth <= 550 ? screenHeightM / 16.755 : screenWidth / 27.377;
  static double dimensionNo50 =
      screenWidth <= 550 ? screenHeightM / 15.08 : screenWidth / 24.64;
  static double dimensionNo55 =
      screenWidth <= 550 ? screenHeightM / 13.70909090909 : screenWidth / 22.4;
  static double dimensionNo60 =
      screenWidth <= 550 ? screenHeightM / 12.566 : screenWidth / 20.533;
  static double dimensionNo70 =
      screenWidth <= 550 ? screenHeightM / 10.7714 : screenWidth / 17.6;
  static double dimensionNo80 =
      screenWidth <= 550 ? screenHeightM / 9.425 : screenWidth / 15.4;
  static double dimensionNo84 =
      screenWidth <= 550 ? screenHeightM / 8.976190 : screenWidth / 14.66667;
  static double dimensionNo90 =
      screenWidth <= 550 ? screenHeightM / 8.37777 : screenWidth / 13.6888888;
  static double dimensionNo100 =
      screenWidth <= 550 ? screenHeightM / 7.54 : screenWidth / 12.32;
  static double dimensionNo110 =
      screenWidth <= 550 ? screenHeightM / 6.854 : screenWidth / 11.2;
  static double dimensionNo120 = screenWidth <= 550
      ? screenHeightM / 6.283333333333333
      : screenWidth / 10.2666666;
  static double dimensionNo130 =
      screenWidth <= 550 ? screenHeightM / 5.8 : screenWidth / 9.4769;
  static double dimensionNo140 =
      screenWidth <= 550 ? screenHeightM / 5.3857 : screenWidth / 8.8;
  static double dimensionNo150 =
      screenWidth <= 550 ? screenHeightM / 5.0266 : screenWidth / 8.2133;
  static double dimensionNo160 =
      screenWidth <= 550 ? screenHeightM / 4.65625 : screenWidth / 7.7;
  static double dimensionNo180 =
      screenWidth <= 550 ? screenHeightM / 4.188 : screenWidth / 6.844;
  static double dimensionNo200 =
      screenWidth <= 550 ? screenHeightM / 3.77 : screenWidth / 6.16;
  static double dimensionNo210 =
      screenWidth <= 550 ? screenHeightM / 3.5904 : screenWidth / 5.866666;
  static double dimensionNo230 =
      screenWidth <= 550 ? screenHeightM / 3.27 : screenWidth / 5.3565;
  static double dimensionNo250 =
      screenWidth <= 550 ? screenHeightM / 3.016 : screenWidth / 4.928;
  static double dimensionNo266 =
      screenWidth <= 550 ? screenHeightM / 2.834 : screenWidth / 4.6315;
  static double dimensionNo280 =
      screenWidth <= 550 ? screenHeightM / 2.6928514 : screenWidth / 4.4;
  static double dimensionNo300 =
      screenWidth <= 550 ? screenHeightM / 2.5133 : screenWidth / 4.1066;
  static double dimensionNo350 =
      screenWidth <= 550 ? screenHeightM / 2.1542 : screenWidth / 3.52;
  static double dimensionNo360 =
      screenWidth <= 550 ? screenHeightM / 2.0944444 : screenWidth / 3.4222;
  static double dimensionNo400 =
      screenWidth <= 550 ? screenHeightM / 1.885 : screenWidth / 3.08;
  static double dimensionNo450 =
      screenWidth <= 550 ? screenHeightM / 1.677 : screenWidth / 2.7377;
  static double dimensionNo480 =
      screenWidth <= 550 ? screenHeightM / 2.56666 : screenWidth / 1.57083;
  static double dimensionNo500 =
      screenWidth <= 550 ? screenHeightM / 1.508 : screenWidth / 2.464;
  static double dimensionNo600 =
      screenWidth <= 550 ? screenHeightM / 1.2566 : screenWidth / 2.053333;
  static double dimensionNo650 =
      screenWidth <= 550 ? screenHeightM / 1.16 : screenWidth / 1.895;

  static double dimensionNo900 =
      screenWidth <= 550 ? 900 : screenWidth / 1.36888;
  static double dimensionNo1100 =
      screenWidth <= 550 ? 1100 : screenWidth / 1.12;

  // static double dimensionNo15 = screenHeight / 50.133;
  // static double dimensionNo18 = screenHeight / 41.77;
  // static double dimensionNo20 = screenHeight / 37.6;
  // static double dimensionNo24 = screenHeight / 31.333;
  // static double dimensionNo30 = screenHeight / 37.9;
  // static double dimensionNo100 = screenHeight / 7.52;
  // static double dimensionNo300 = screenHeight / 3.79;
}
