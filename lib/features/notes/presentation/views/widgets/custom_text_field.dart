// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:notes_app/core/utils/constants.dart';


class CustomTextField extends StatefulWidget {
   const CustomTextField({super.key, 
    this.label,
    this.hint,
    this.maxlines = 1,
    this.onSaved,
    this.onChanged,
    this.controller,
    this.debounceDuration,
    this.searchIcon = false, required int maxLines,
  });

  final String? label;
  final String? hint;
  final int maxlines;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Duration? debounceDuration;
  final bool searchIcon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        if (widget.debounceDuration != null) {
          _debounceSearch(() {
            widget.onChanged?.call(value);
          });
        } else {
          widget.onChanged?.call(value);
        }
      },
      onSaved: widget.onSaved,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Field is required';
        }
        return null;
      },
      cursorColor: kPrimaryColor,
      maxLines: widget.maxlines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: const TextStyle(color: kPrimaryColor),
        hintStyle: const TextStyle(color: kPrimaryColor),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(kPrimaryColor),
        suffixIcon: widget.searchIcon ? const Icon(Icons.search, color: kPrimaryColor) : null,
      ),
    );
  }

  Timer? _debounceTimer;

  void _debounceSearch(VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration ?? const Duration(milliseconds: 500), callback);
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color ?? Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
