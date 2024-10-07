import 'package:flutter/material.dart';
import 'consts.dart';

class MyPadding extends Padding{
  const MyPadding({super.key, required super.child}): super(padding: defaultPadding);
}

class MyText extends Text {
  const MyText(super.data, {super.key}): super(style: defaultTextStyle);


}