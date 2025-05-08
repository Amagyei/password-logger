// lib/components/search_bar.dart
import 'package:flutter/material.dart';

class ClientSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const ClientSearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search client sites...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}