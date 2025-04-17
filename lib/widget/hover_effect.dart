// import 'package:flutter/material.dart';

// class HoverListTile extends StatefulWidget {
//   final Widget title;
  

//   HoverListTile({
//     required this.title,
   
//   });

//   @override
//   _HoverListTileState createState() => _HoverListTileState();
// }

// class _HoverListTileState extends State<HoverListTile> {
//   bool _isHovering = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => _onHover(true),
//       onExit: (_) => _onHover(false),
//       child: Container(
//         color: _isHovering ? Colors.grey[200] : Colors.transparent,
//         child: ListTile(
//           title: widget.title,
//           subtitle: widget.subtitle,
//           leading: widget.leading,
//           trailing: widget.trailing,
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