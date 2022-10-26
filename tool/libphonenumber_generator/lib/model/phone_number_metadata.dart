// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'territory.dart';

class PhoneNumberMetadata {
  const PhoneNumberMetadata({required this.territories});

  final List<Territory> territories;

  factory PhoneNumberMetadata.fromMap(Map<String, dynamic> map) {
    final phoneNumberMetaDataMap =
        map['phoneNumberMetadata'] as Map<String, dynamic>;
    final territoriesMap =
        phoneNumberMetaDataMap['territories'] as Map<String, dynamic>;
    final territories =
        List<Map<String, dynamic>>.from(territoriesMap['territory'])
            .where((value) {
      final id = value['id'] as String;
      return id != '001';
    }).map(Territory.fromMap);

    return PhoneNumberMetadata(
      territories: territories.toList(),
    );
  }
}
