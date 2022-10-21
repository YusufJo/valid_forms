// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:libphonenumber_generator/constant/country_info.dart';

class CountryNameNormalizer {
  CountryNameNormalizer._();

  factory CountryNameNormalizer() => _instance;

  static final CountryNameNormalizer _instance = CountryNameNormalizer._();

  String call({required final String id, required final String code}) {
    if (id == '001') {
      return CountryInfo.values.firstWhere((c) => c.code == code).name;
    } else {
      return CountryInfo.values.firstWhere((c) => c.iso2 == id).name;
    }
  }
}
