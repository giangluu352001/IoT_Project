import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextThemes{
static var kHeadTextStyle = GoogleFonts.lato(
  textStyle: const TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    height: 1.2,
  ),
);
static var kSubHeadTextStyle = GoogleFonts.dmSans(
  textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  ),
);

static var kSub2HeadTextStyle = GoogleFonts.dmSans(
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  ),
);
}



const kDefaultShadow = BoxShadow(
  offset: Offset(0, 0),
  blurRadius: 20,
  color: Colors.black26,
);

var kLightShadow = BoxShadow(
  offset: const Offset(0, 3),
  blurRadius: 15,
  color: Colors.grey.shade200,
);
