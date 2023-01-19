// ignore_for_file: avoid_print

import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty || !Directory(args.first).existsSync()) {
    print('Please give me a exist directory.');

    return;
  }

  final rootDirectoryPath = args.first;
  allocate(directoryPath: rootDirectoryPath);

  print('\nAll good!');
}

void allocate({required String directoryPath}) {
  final currentDirectory = Directory(directoryPath);

  final List<FileSystemEntity> entities = currentDirectory.listSync();
  final List<String> createdDirectoryNames = [];

  for (final entity in entities) {
    if (entity is Directory) {
      allocate(directoryPath: entity.path);
      continue;
    }

    final fileName = entity.path.split('/').last;

    final isTimesImage = fileName.split('@').isNotEmpty;
    if (!isTimesImage) {
      continue;
    }

    final directoryPath = currentDirectory.path;
    if (fileName.contains('@2x')) {
      checkAndCreateDirectory(
        directoryPath: directoryPath,
        newDirectoryName: '2.0x',
        createdDirectoryNames: createdDirectoryNames,
      );
      entity.renameSync('${currentDirectory.path}/2.0x/${fileName.replaceFirst('@2x', '')}');
    } else if (fileName.contains('@3x')) {
      checkAndCreateDirectory(
        directoryPath: directoryPath,
        newDirectoryName: '3.0x',
        createdDirectoryNames: createdDirectoryNames,
      );
      entity.renameSync('${currentDirectory.path}/3.0x/${fileName.replaceFirst('@3x', '')}');
    } else if (fileName.contains('@4x')) {
      checkAndCreateDirectory(
        directoryPath: directoryPath,
        newDirectoryName: '4.0x',
        createdDirectoryNames: createdDirectoryNames,
      );
      entity.renameSync('${currentDirectory.path}/4.0x/${fileName.replaceFirst('@4x', '')}');
    }
  }
  print('The asset resources were moved to suitable directories. ($directoryPath)');
}

void checkAndCreateDirectory({
  required String directoryPath,
  required String newDirectoryName,
  required List<String> createdDirectoryNames,
}) {
  if (createdDirectoryNames.contains(newDirectoryName)) {
    return;
  }

  Directory('$directoryPath/$newDirectoryName/').createSync();
  createdDirectoryNames.add(newDirectoryName);
}
