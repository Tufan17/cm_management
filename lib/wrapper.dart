import 'dart:io';

import 'package:cm_flutter/view/desktop/desktop_home_view.dart';
import 'package:cm_flutter/view/mobile/mobile_home_view.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return DesktopHome();
    } else {
      return MobileHome();
    }
  }
}
