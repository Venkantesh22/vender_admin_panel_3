import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:samay_admin_plan/features/setting/widget/list_time.dart';

class SettingDrawer extends StatelessWidget {
  final List<String> menuTitles;
  final List<IconData> menuIcons;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SettingDrawer({
    super.key,
    required this.menuTitles,
    required this.menuIcons,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 55, 54, 54),
      child: ListView.builder(
        itemCount: menuTitles.length,
        itemBuilder: (context, index) {
          return AnimatedDrawerTile(
            title: menuTitles[index],
            icon: menuIcons[index],
            isSelected: selectedIndex == index,
            onTap: () {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                onItemSelected(index);
              });
            },
          );
        },
      ),
    );
  }
}
