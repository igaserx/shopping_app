import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withValues(alpha: 1.5),
            image: DecorationImage(
              image: NetworkImage(
                // Placeholder image.
                "https://imgs.search.brave.com/KduxKtHYttxgnVKrBZtuw6dPVUsgiHObDPnGHeocDnY/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi9iL2I2L0lt/YWdlX2NyZWF0ZWRf/d2l0aF9hX21vYmls/ZV9waG9uZS5wbmcv/MTIwMHB4LUltYWdl/X2NyZWF0ZWRfd2l0/aF9hX21vYmlsZV9w/aG9uZS5wbmc",
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Text("Category"),
      ],
    );
  }
}
