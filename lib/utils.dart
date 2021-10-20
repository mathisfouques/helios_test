import 'package:flutter/material.dart';

const Color lightBlue = Color(0xFFD2E8FB);
const Color green = Color(0xFF35665A);
const Color lightGreen = Color(0xFF357563);
const Color lightGreenHalfOpacity = Color(0x77357563);
const Color grayishGreen = Color(0xFF93A5A0);

List<int> getThree(int page, int maxPage) {
  assert(maxPage > 1);

  if (page == 0) return [0, 1, 2];
  if (page == maxPage) return [maxPage - 2, maxPage - 1, maxPage];

  return [page - 1, page, page + 1];
}
