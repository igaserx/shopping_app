import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget{
  const CustomButton({super.key,required this.color, required this.text, required this.onTap});
  final Color color ;
  final String text; 
  final VoidCallback onTap ;
@override
  Widget build(BuildContext context) {
return  InkWell(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color,
                      ),
                      child: Center(
                        child: Text(
                          text,
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
  }
}
