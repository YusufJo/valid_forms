// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../model/phone_number_metadata.dart';
import '../model/territory.dart';

enum _NumberType {
  fixedLine,
  mobile;
}

class SourceCodeGenerator {
  const SourceCodeGenerator({
    required final PhoneNumberMetadata metadata,
    required final Uri outputPath,
  })  : _metadata = metadata,
        _outputPath = outputPath;

  final PhoneNumberMetadata _metadata;
  final Uri _outputPath;

  void call() {
    final emitter =
        DartEmitter(orderDirectives: true, useNullSafetySyntax: true);
    final header = _header(emitter: emitter);
    final fixedLinePatternsMap = _fixedLinePatternsMap(emitter: emitter);
    final mobilePatternsMap = _mobilePatternsMap(emitter: emitter);
    final internationalPhoneNumberEnum =
        _internationalPhoneNumberEnum(emitter: emitter);

    final code = Code([
      header,
      fixedLinePatternsMap,
      mobilePatternsMap,
      internationalPhoneNumberEnum,
    ].map((e) => e.toString()).join('\n'));
    final formatter = DartFormatter();
    final content = formatter.format(code.toString());
    final outFile = File.fromUri(_outputPath);
    outFile.writeAsStringSync(content, flush: true);
  }

  StringSink _header({required final DartEmitter emitter}) {
    final content = """
/// ======================================
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// ======================================
// ignore_for_file: type=lint
""";
    final code = Code(content);
    return code.accept(emitter);
  }

  StringSink _mobilePatternsMap({required final DartEmitter emitter}) {
    final mobilePatternsBuilder = FieldBuilder();
    mobilePatternsBuilder.modifier = FieldModifier.final$;
    mobilePatternsBuilder.type = Reference('Map<$String, $RegExp>');
    mobilePatternsBuilder.name = '_mobilePatterns';
    mobilePatternsBuilder.assignment = Code('${_mobilePatternsMapValue()}');
    return mobilePatternsBuilder.build().accept(emitter);
  }

  Map<String, String> _mobilePatternsMapValue() {
    final result = <String, String>{};
    for (final territory in _metadata.territories) {
      final pattern = territory.mobilePattern;
      if (pattern == null) continue;
      final fullPattern = _patternBuilder(
        territory: territory,
        type: _NumberType.mobile,
      );
      result["'${territory.name}'"] = 'RegExp(r"$fullPattern")';
    }
    return result;
  }

  StringSink _fixedLinePatternsMap({required final DartEmitter emitter}) {
    final mobilePatternsBuilder = FieldBuilder();
    mobilePatternsBuilder.modifier = FieldModifier.final$;
    mobilePatternsBuilder.type = Reference('Map<$String, $RegExp>');
    mobilePatternsBuilder.name = '_fixedLinePatterns';
    mobilePatternsBuilder.assignment = Code('${_fixedLinePatternsMapValue()}');
    return mobilePatternsBuilder.build().accept(emitter);
  }

  Map<String, String> _fixedLinePatternsMapValue() {
    final result = <String, String>{};
    for (final territory in _metadata.territories) {
      final fullPattern = _patternBuilder(
        territory: territory,
        type: _NumberType.fixedLine,
      );
      result["'${territory.name}'"] = 'RegExp(r"$fullPattern")';
    }
    return result;
  }

  String _patternBuilder({
    required final Territory territory,
    required final _NumberType type,
  }) {
    final countryCodePattern = "\\+${territory.countryCode}";
    final nationalPrefix = territory.nationalPrefix;
    late final String nationalPrefixPattern;
    if (nationalPrefix == null) {
      nationalPrefixPattern = '';
    } else {
      if (nationalPrefix.length > 1) {
        nationalPrefixPattern = '(?:$nationalPrefix)?';
      } else {
        nationalPrefixPattern = '$nationalPrefix?';
      }
    }
    late String basePattern;
    switch (type) {
      case _NumberType.fixedLine:
        basePattern = territory.fixedLinePattern;
        break;
      case _NumberType.mobile:
        basePattern = territory.mobilePattern!;
        break;
    }
    return "^$countryCodePattern(?:$nationalPrefixPattern$basePattern)\$";
  }

  StringSink _internationalPhoneNumberEnum({
    required final DartEmitter emitter,
  }) {
    final enumValues = _metadata.territories
        .map((e) => e.name)
        .map((e) => EnumValue((b) => b.name = e));

    final fixedLinePatternGetter = MethodBuilder();
    fixedLinePatternGetter.name = 'fixedLinePattern';
    fixedLinePatternGetter.type = MethodType.getter;
    fixedLinePatternGetter.returns = Reference('$RegExp');
    fixedLinePatternGetter.lambda = true;
    fixedLinePatternGetter.body = Code('_fixedLinePatterns[name]!');

    final mobilePatternGetter = MethodBuilder();
    mobilePatternGetter.name = 'mobilePattern';
    mobilePatternGetter.type = MethodType.getter;
    mobilePatternGetter.returns = Reference('$RegExp?');
    mobilePatternGetter.lambda = true;
    mobilePatternGetter.body = Code('_mobilePatterns[name]');

    final enumClass = EnumBuilder();
    enumClass.name = 'InternationalPhoneNumber';
    enumClass.values.addAll(enumValues);
    enumClass.values.sort((f, s) => f.name.compareTo(s.name));
    enumClass.methods.add(fixedLinePatternGetter.build());
    enumClass.methods.add(mobilePatternGetter.build());
    return enumClass.build().accept(emitter);
  }
}
