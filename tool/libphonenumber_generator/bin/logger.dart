// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:ansicolor/ansicolor.dart';

abstract class Logger {
  static final _pen = AnsiPen();

  static void info(String message) {
    _pen.white(bold: true);
    print("${_pen(message)}\n");
    _pen.reset();
  }

  static void error(String message) {
    _pen.red(bold: true);
    print("${_pen(message)}\n");
    _pen.reset();
  }

  static void success(String message) {
    _pen.green(bold: true);
    print("${_pen(message)}\n");
    _pen.reset();
  }

  static void warning(String message) {
    _pen.yellow(bold: true);
    print("${_pen(message)}\n");
    _pen.reset();
  }
}
