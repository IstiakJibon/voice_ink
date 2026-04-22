import 'package:flutter/cupertino.dart';

extension NumExt on num {
  Widget get vertical => SizedBox(
        height: toDouble(),
      );

  Widget get horizontal => SizedBox(
        width: toDouble(),
      );
}
