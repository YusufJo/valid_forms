// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class Territory {
  const Territory({
    required this.name,
    required this.countryCode,
    this.nationalPrefix,
    required this.fixedLinePattern,
    this.mobilePattern,
  });

  static final _newLinePattern = RegExp(r'\\\\n');
  static final _spacesPattern = RegExp(r'\s+');

  final String name;
  final String countryCode;
  final String? nationalPrefix;
  final String fixedLinePattern;
  final String? mobilePattern;

  factory Territory.fromMap(Map<String, dynamic> map) {
    return Territory(
      name: map['id'] as String,
      countryCode: map['countryCode'] as String,
      nationalPrefix: map['nationalPrefix'] as String?,
      fixedLinePattern: _patternParser(key: 'fixedLine', map: map) as String,
      mobilePattern: _patternParser(key: 'mobile', map: map),
    );
  }

  static String? _patternParser({
    required final String key,
    required final Map<String, dynamic> map,
  }) {
    final value = map[key] as Map<String, dynamic>?;
    if (value == null) return null;
    final nationalNumberPattern =
        value['nationalNumberPattern'] as Map<String, dynamic>;
    final rawPattern = nationalNumberPattern[r'$t'] as String;
    return rawPattern
        .replaceAll(_newLinePattern, '')
        .replaceAll(_spacesPattern, '');
  }
}
