// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:samay_admin_plan/utility/dimenison.dart';

// class CatergryButton extends StatefulWidget {
//   final String text;
//   final VoidCallback onTap;
//   final bool isSelected; // Added selection flag

//   const CatergryButton({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.isSelected = false, // Default to false
//   });

//   @override
//   State<CatergryButton> createState() => _CatergryButtonState();
// }

// class _CatergryButtonState extends State<CatergryButton> {
//   bool _isHovering = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => _onHover(true),
//       onExit: (_) => _onHover(false),
//       child: InkWell(
//         onTap: widget.onTap,
//         child: Container(
//           decoration: BoxDecoration(
//             color: widget.isSelected
//                 ? const Color.fromARGB(255, 130, 128, 128)
//                     .withOpacity(0.7) // Blue background when selected
//                 : (_isHovering
//                     ? const Color.fromARGB(255, 209, 207, 207).withOpacity(0.1)
//                     : Colors.transparent),
//             borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
//           ),
//           margin: const EdgeInsets.all(3),
//           padding: EdgeInsets.fromLTRB(
//             Dimensions.dimensionNo16,
//             Dimensions.dimensionNo10,
//             Dimensions.dimensionNo10,
//             Dimensions.dimensionNo10,
//           ),
//           child: Text(
//             widget.text,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: Dimensions.dimensionNo16,
//               fontFamily: GoogleFonts.roboto().fontFamily,
//               fontWeight: FontWeight.w400,
//               letterSpacing: 0.15,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onHover(bool isHovering) {
//     setState(() {
//       _isHovering = isHovering;
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class CatergryButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const CatergryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<CatergryButton> createState() => _CatergryButtonState();
}

class _CatergryButtonState extends State<CatergryButton> {
  bool _isHovering = false;

  Color get _backgroundColor {
    if (widget.isSelected) {
      return const Color.fromARGB(255, 130, 128, 128).withOpacity(0.7);
    } else if (_isHovering) {
      return const Color.fromARGB(255, 209, 207, 207).withOpacity(0.1);
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
        ),
        margin: const EdgeInsets.all(3),
        child: ListTile(
          onTap: widget.onTap,
          title: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.dimensionNo16,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }
}
