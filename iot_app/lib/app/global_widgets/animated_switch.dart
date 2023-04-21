import 'package:flutter/material.dart';

import '../theme/color_theme.dart';

class AnimatedSwitch extends StatelessWidget {
  final List<bool> isToggled;
  final int index;
  final void Function() onTap;

  const AnimatedSwitch({
    Key? key,
    required this.isToggled,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2,
              color: isToggled[index] ? Colors.white.withOpacity(0.6) : GFTheme.black1,
            )),
        child: Stack(
          children: [
            AnimatedCrossFade(
              firstChild: Container(
                height: 28,
                width: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
              ),
              secondChild: Container(
                height: 28,
                width: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              crossFadeState: isToggled[index]
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(
                milliseconds: 50,
              ),
            ),
            AnimatedAlign(
              duration: const Duration(
                milliseconds: 100,
              ),
              alignment: isToggled[index]
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                height: 42 * 0.5,
                width: 42 * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToggled[index]
                      ? GFTheme.white1
                      : GFTheme.black1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
