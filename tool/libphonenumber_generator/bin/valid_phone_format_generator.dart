// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:libphonenumber_generator/libphonenumber_generator.dart';
import 'logger.dart';

Future<void> main(List<String> arguments) async {
  final parsedArgs = _parseArgs(args: arguments);
  final tempDir = await Directory.systemTemp.createTemp();
  final xmlFile = await _downloadMetadata(tempDir: tempDir);
  final jsonFile =
      await _convertMetadataToJson(tempDir: tempDir, xmlFile: xmlFile);
  _generateSourceCode(
      tempDir: tempDir, jsonFile: jsonFile, outPath: parsedArgs['output']);
}

ArgResults _parseArgs({required final List<String> args}) {
  final parser = ArgParser();
  parser.addOption(
    'output',
    abbr: 'o',
    mandatory: true,
    help: 'Path to generated file.',
    valueHelp: 'PATH',
  );

  late final ArgResults argResults;
  try {
    argResults = parser.parse(args);
  } on FormatException catch (e) {
    Logger.error(e.message);
    Logger.info(parser.usage);
    exit(1);
  }
  return argResults;
}

Future<File> _downloadMetadata({required final Directory tempDir}) async {
  Logger.info('Downloading metadata...');
  final downloader = MetadataDownloader(tempDir: tempDir);
  try {
    final file = await downloader();
    Logger.success('Metadata was downloaded.');
    return file;
  } catch (e) {
    Logger.error('An error occurred while downloading metadata.');
    Logger.info(e.toString());
    await tempDir.delete(recursive: true);
    Logger.warning('Done.');
    exit(1);
  }
}

Future<File> _convertMetadataToJson({
  required final Directory tempDir,
  required final File xmlFile,
}) async {
  Logger.info('Converting metadata...');
  final converter = XmlToJsonConverter(tempDir: tempDir, xmlFile: xmlFile);
  try {
    final jsonFile = await converter();
    Logger.success('Metadata was converted successfully.');
    return jsonFile;
  } catch (e) {
    Logger.error('An error occurred converting metadata.');
    Logger.info(e.toString());
    Logger.info('Deleting temp files ...');
    await tempDir.delete(recursive: true);
    Logger.warning('Done.');
    exit(1);
  }
}

Future<void> _generateSourceCode({
  required final Directory tempDir,
  required final File jsonFile,
  required final String outPath,
}) async {
  Logger.info('Generating source code...');
  try {
    final rawData = await jsonFile.readAsString();
    final jsonData = json.decode(rawData);
    final metaData = PhoneNumberMetadata.fromMap(jsonData);
    final outputPath = Uri(path: outPath);
    final generator = SourceCodeGenerator(
      metadata: metaData,
      outputPath: outputPath,
    );
    generator();
    Logger.success('Source code was generated successfully.');
  } catch (e) {
    Logger.error('An error occurred converting metadata.');
    Logger.info(e.toString());
    exit(1);
  } finally {
    Logger.info('Deleting temp files ...');
    await tempDir.delete(recursive: true);
    Logger.success('Done.');
  }
}
