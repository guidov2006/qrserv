import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'cachemanager.dart';
import 'server.dart';

class FileManager {
  static String currentFile = '';
  static String currentFullPath = '';
  static String currentPath = '';
  static int currentLength = 0;

  static bool fileImported = false;
  static bool multipleFiles = false;
  final bool allowMultipleFiles = (Platform.isAndroid);

  Map<String, dynamic> readInfo() {
    return {
      'name': currentFile,
      'path': currentFullPath,
      'pathpart': currentPath,
      'length': currentLength
    };
  }

  Future selectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultipleFiles,
        onFileLoading: (selectionStatus) {
          // TODO: potentially use for status
          print(selectionStatus);
        });
    print(result);

    if (result != null) {
      print(result.files);
      print(result.files.length);

      multipleFiles = (result.files.length > 1);

      for (int i = 0; i < result.files.length; i++) {
        print('-------- FILE --------');
        print(result.files[i].name);
        print(result.files[i].path);
        print(result.files[i].size);
      }
      print(multipleFiles);

      if (multipleFiles) {
        // TODO: implement zip functionality, remove each file as they get added from cache, set archive as main file, list added files in tooltip
      } else {
        // Cache handling
        if (currentFullPath != '' &&
            currentFullPath != (result.files.first.path ?? '') &&
            Server().fileExists(currentFullPath)) {
          CacheManager().deleteCache(context, currentFullPath);
        }

        // Set file information
        FileManager.currentFile = result.files.first.name;
        FileManager.currentFullPath = result.files.first.path ?? '';
        FileManager.currentPath = dirname(result.files.first.path ?? '');
        FileManager.currentLength = result.files.first.size;
        FileManager.fileImported = true;
      }
    }
  }
}
