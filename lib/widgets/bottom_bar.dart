import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VolnaBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const VolnaBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      'assets/svg/phone.svg',
      'assets/svg/messenger.svg',
      'assets/svg/favorites.svg',
      'assets/svg/volna points.svg',
      'assets/svg/insta.svg',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                items[index],
                color: Colors.white,
                width: 30,
                height: 30,
              ),
            ),
          );
        }),
      ),
    );
  }
}
