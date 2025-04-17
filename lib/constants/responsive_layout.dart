import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final double mobileBreakpoint;
  final double tabletBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.mobileBreakpoint = 600,
    this.tabletBreakpoint = 1100,
  });

  /// Returns true if the screen width is less than [mobileBreakpoint].
  static bool isMobile(BuildContext context, {double mobileBreakpoint = 600}) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  /// Returns true if the screen width is between [mobileBreakpoint] (inclusive)
  /// and [tabletBreakpoint] (exclusive).
  static bool isTablet(BuildContext context,
          {double mobileBreakpoint = 600, double tabletBreakpoint = 1100}) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isMoAndTab(BuildContext context,
          {double mobileBreakpoint = 0, double tabletBreakpoint = 1100}) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  /// Returns true if the screen width is greater than or equal to [tabletBreakpoint].
  static bool isTapAndDesktop(BuildContext context,
          {double tabletBreakpoint = 1100}) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static bool isDesktop(BuildContext context,
          {double tabletBreakpoint = 1100}) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) {
      return desktop;
    } else if (width >= mobileBreakpoint && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
