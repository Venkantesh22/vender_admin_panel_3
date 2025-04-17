import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class AnimatedDrawerTile extends StatefulWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedDrawerTile({
    super.key,
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _AnimatedDrawerTileState createState() => _AnimatedDrawerTileState();
}

class _AnimatedDrawerTileState extends State<AnimatedDrawerTile> {
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
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
        ),
        margin: const EdgeInsets.all(3),
        child: ListTile(
          onTap: widget.onTap,
          leading: widget.icon != null
              ? Icon(widget.icon, color: Colors.white)
              : null,
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontSize: Dimensions.dimenisonNo16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ),
    );
  }
}
