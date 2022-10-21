// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'package:http/http.dart' as http;

class MetadataDownloader {
  const MetadataDownloader({required Directory tempDir})
      : _tempDir = tempDir;

  final Directory _tempDir;

  static const _phoneNumberMetadataUrl =
      'https://raw.githubusercontent.com/google/libphonenumber/master/resources/PhoneNumberMetadata.xml';
  static const _outputFileName = 'PhoneNumberMetadata.xml';

  Future<File> call() async {
    final tempFile = await _tempFile;
    final response = await http.get(Uri.parse(_phoneNumberMetadataUrl));
    await tempFile.writeAsBytes(response.bodyBytes);
    return tempFile;
  }

  Future<File> get _tempFile async {
    final tempFilePath =
        _tempDir.path + Platform.pathSeparator + _outputFileName;
    return File(tempFilePath);
  }
}
