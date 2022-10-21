// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:xml2json/xml2json.dart';

class XmlToJsonConverter {
  const XmlToJsonConverter({
    required final Directory tempDir,
    required final File xmlFile,
  })  : _tempDir = tempDir,
        _xmlFile = xmlFile;

  static const _outputFileName = 'PhoneNumberMetadata.json';

  final Directory _tempDir;
  final File _xmlFile;

  Future<File> call() async {
    final tempFile = await _tempFile;
    final converter = Xml2Json();
    converter.parse(_xmlFile.readAsStringSync());
    tempFile.writeAsStringSync(converter.toGData());
    return tempFile;
  }

  Future<File> get _tempFile async {
    final tempFilePath =
        _tempDir.path + Platform.pathSeparator + _outputFileName;
    return File(tempFilePath);
  }
}
