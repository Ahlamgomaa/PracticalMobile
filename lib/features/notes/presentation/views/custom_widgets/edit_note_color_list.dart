import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/constants.dart';
import 'package:notes_app/features/notes/presentation/views/custom_widgets/colors_list_view.dart';

class ColorListView extends StatefulWidget {
  final ValueChanged<Color> onColorSelected;
  final Color initialColor;

  const ColorListView({
    super.key,
    required this.onColorSelected,
    required this.initialColor,
  });

  @override
  State<ColorListView> createState() => _ColorListViewState();
}

class _ColorListViewState extends State<ColorListView> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = kColors.indexOf(widget.initialColor);
    if (currentIndex == -1) currentIndex = 0; 
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35 * 2,
      child: ListView.builder(
        itemCount: kColors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() => currentIndex = index);
                widget.onColorSelected(kColors[index]);
              },
              child: ColorItem(
                isActive: currentIndex == index,
                color: kColors[index],
              ),
            ),
          );
        },
      ),
    );
  }
}