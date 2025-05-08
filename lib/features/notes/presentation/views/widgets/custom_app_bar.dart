import 'package:flutter/material.dart';
import 'package:notes_app/features/notes/presentation/views/search_view.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  final String title;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onPressed ?? () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SearchView();
              }));
            },
            child: CustomIcon(
              onPressed: onPressed,
              icon: icon,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}