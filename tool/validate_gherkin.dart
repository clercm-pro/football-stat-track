#!/usr/bin/env dart

/// Gherkin Validator Tool
/// Validates that code changes have proper @gherkin annotations
///
/// Usage: dart run tool/validate_gherkin.dart [--staged]
///   --staged: Only check staged files (for git pre-commit hook)

import 'dart:io';
import 'package:path/path.dart' as path;

void main(List<String> args) {
  final bool checkStagedOnly = args.contains('--staged');
  
  print('🔍 Validating Gherkin coverage...');
  
  final filesToCheck = <String>[];
  
  if (checkStagedOnly) {
    // Get staged files from git
    final result = Process.runSync('git', ['diff', '--cached', '--name-only', '--diff-filter=ACM']);
    if (result.exitCode == 0) {
      filesToCheck.addAll(result.stdout.toString().split('\n').where((f) => f.endsWith('.dart')).toList());
    }
  } else {
    // Check all Dart files in lib/
    final libDir = Directory('lib');
    if (libDir.existsSync()) {
      filesToCheck.addAll(_findDartFiles(libDir));
    }
  }
  
  if (filesToCheck.isEmpty) {
    print('ℹ️ No Dart files to validate');
    return;
  }
  
  print('📁 Checking ${filesToCheck.length} Dart files...');
  
  final issues = <String>[];
  final validFiles = <String>[];
  
  for (final filePath in filesToCheck) {
    if (!File(filePath).existsSync()) continue;
    
    final content = File(filePath).readAsStringSync();
    final hasGherkin = content.contains('@gherkin');
    
    // For now, we just note which files have gherkin
    // In future, we can add more sophisticated checks
    if (hasGherkin) {
      validFiles.add(filePath);
    } else {
      // Check if this is a screen file (more likely to need documentation)
      if (filePath.contains('screens/')) {
        issues.add('⚠️ $filePath: No @gherkin annotations found (screen file)');
      }
    }
  }
  
  print('✅ ${validFiles.length} files with @gherkin annotations');
  
  if (issues.isNotEmpty) {
    print('\n⚠️  Issues found:');
    for (final issue in issues) {
      print('  $issue');
    }
    print('\n💡 Suggestion: Add @gherkin annotations to document these files');
    print('💡 Example: See tool/README.md for annotation format');
    // Don't fail - just warn for now
    // exit(1); // Uncomment to make validation strict
  } else {
    print('✅ All screen files have @gherkin annotations');
  }
  
  // Check if FEATURES.md needs to be regenerated
  print('\n🔄 Checking if FEATURES.md needs update...');
  final featuresFile = File('docs/specs/FEATURES.md');
  if (featuresFile.existsSync()) {
    final featuresContent = featuresFile.readAsStringSync();
    final hasGeneratedSection = featuresContent.contains('## 🔧 Code-Embedded Gherkin Scenarios');
    
    if (!hasGeneratedSection && validFiles.isNotEmpty) {
      print('ℹ️ Consider running: dart run tool/extract_gherkin.dart');
    }
  }
  
  print('\n✅ Validation complete!');
}

/// Recursively find all Dart files in a directory
List<String> _findDartFiles(Directory dir) {
  final dartFiles = <String>[];
  
  try {
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        dartFiles.add(entity.path);
      }
    }
  } catch (e) {
    // Directory might not exist
  }
  
  return dartFiles;
}
