#!/usr/bin/env dart

/// Gherkin Extractor Tool
/// Extracts @gherkin annotations from Dart files and generates FEATURES.md
///
/// Usage: dart run tool/extract_gherkin.dart

import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  print('🔍 Extracting Gherkin scenarios from Dart files...');
  
  final gherkinScenarios = <String, List<String>>{};
  final filesWithGherkin = <String>[];
  
  // Scan all Dart files in lib/ directory
  final libDir = Directory('lib');
  final allDartFiles = _findDartFiles(libDir);
  
  print('📁 Scanning ${allDartFiles.length} Dart files...');
  
  for (final file in allDartFiles) {
    final content = File(file).readAsStringSync();
    final scenarios = _extractGherkinFromFile(content, file);
    
    if (scenarios.isNotEmpty) {
      filesWithGherkin.add(file);
      for (final scenario in scenarios) {
        _addScenario(gherkinScenarios, scenario);
      }
    }
  }
  
  print('✅ Found Gherkin scenarios in ${filesWithGherkin.length} files');
  print('✅ Total scenarios: ${_countScenarios(gherkinScenarios)}');
  
  // Generate or update FEATURES.md
  _generateFeaturesFile(gherkinScenarios);
  
  print('\n🎉 Gherkin extraction complete!');
  print('📄 Updated: docs/specs/FEATURES.md');
}

/// Recursively find all Dart files in a directory
List<String> _findDartFiles(Directory dir) {
  final dartFiles = <String>[];
  
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity.path);
    }
  }
  
  return dartFiles;
}

/// Extract Gherkin scenarios from file content
List<String> _extractGherkinFromFile(String content, String filePath) {
  final scenarios = <String>[];
  final lines = content.split('\n');
  
  bool inGherkinBlock = false;
  String currentBlock = '';
  
  for (final line in lines) {
    // Check if line starts with /// (Dart doc comment)
    if (line.startsWith('///')) {
      final contentAfterPrefix = line.substring(3); // Remove ///
      final trimmedContent = contentAfterPrefix.trim();
      
      // Check if this line contains @gherkin (start of block)
      if (trimmedContent.contains('@gherkin')) {
        inGherkinBlock = true;
        // Remove @gherkin tag from the line
        final cleanLine = trimmedContent.replaceAll('@gherkin', '').trim();
        if (cleanLine.isNotEmpty) {
          currentBlock = cleanLine + '\n';
        }
        continue;
      }
      
      // Inside Gherkin block - collect all /// lines
      if (inGherkinBlock) {
        // If the line after /// is not empty, add it
        if (trimmedContent.isNotEmpty) {
          currentBlock += trimmedContent + '\n';
        } else {
          // Empty /// line - add as blank line
          currentBlock += '\n';
        }
        continue;
      }
    }
    
    // Not a /// line
    if (inGherkinBlock) {
      // End of Gherkin block when we hit non-comment, non-empty line
      if (line.trim().isNotEmpty) {
        if (currentBlock.isNotEmpty) {
          scenarios.add(currentBlock);
        }
        inGherkinBlock = false;
        currentBlock = '';
      }
      // If it's an empty line, add it to the block
      else if (line.trim().isEmpty) {
        currentBlock += '\n';
      }
    }
  }
  
  // Add the last block if we were in one
  if (inGherkinBlock && currentBlock.isNotEmpty) {
    scenarios.add(currentBlock);
  }
  
  return scenarios;
}

/// Add scenario to the map, grouping by feature
void _addScenario(Map<String, List<String>> scenariosMap, String scenario) {
  final lines = scenario.split('\n');
  
  String? currentFeatureId;
  
  for (final line in lines) {
    final trimmedLine = line.trim();
    
    // Look for feature ID in tag lines
    if (trimmedLine.startsWith('@') && !trimmedLine.contains('gherkin')) {
      // This is a feature tag (e.g., @BUG-COM-01)
      currentFeatureId = trimmedLine.substring(1); // Remove @
      
      // Initialize list for this feature
      if (!scenariosMap.containsKey(currentFeatureId)) {
        scenariosMap[currentFeatureId] = [];
      }
      
      // Add the scenario
      scenariosMap[currentFeatureId]!.add(scenario);
      return;
    }
    
    // Look for Feature: line
    if (trimmedLine.startsWith('Feature:')) {
      // Extract feature ID from the feature line
      // Example: "Feature: ProfileScreen compilation without debug methods"
      // We'll use a sanitized version as key
      currentFeatureId = trimmedLine.substring('Feature:'.length).trim();
      
      if (!scenariosMap.containsKey(currentFeatureId)) {
        scenariosMap[currentFeatureId] = [];
      }
      
      scenariosMap[currentFeatureId]!.add(scenario);
      return;
    }
  }
  
  // If we couldn't find a feature ID, add to "Uncategorized"
  if (!scenariosMap.containsKey('Uncategorized')) {
    scenariosMap['Uncategorized'] = [];
  }
  scenariosMap['Uncategorized']!.add(scenario);
}

/// Count total scenarios
int _countScenarios(Map<String, List<String>> scenariosMap) {
  return scenariosMap.values.fold(0, (sum, list) => sum + list.length);
}

/// Generate or update FEATURES.md
void _generateFeaturesFile(Map<String, List<String>> gherkinScenarios) {
  final featuresDir = Directory('docs/specs');
  if (!featuresDir.existsSync()) {
    featuresDir.createSync(recursive: true);
  }
  
  final featuresFile = File('docs/specs/FEATURES.md');
  String existingContent = '';
  
  if (featuresFile.existsSync()) {
    existingContent = featuresFile.readAsStringSync();
  }
  
  // Build new content for extracted scenarios
  final extractedContent = StringBuffer();
  
  // Add header for extracted section
  extractedContent.writeln('## 🔧 Code-Embedded Gherkin Scenarios');
  extractedContent.writeln('');
  extractedContent.writeln('*Auto-generated from `@gherkin` annotations in code*');
  extractedContent.writeln('');
  extractedContent.writeln('| Metric | Value |');
  extractedContent.writeln('|--------|-------|');
  extractedContent.writeln('| **Scenarios** | ${_countScenarios(gherkinScenarios)} |');
  extractedContent.writeln('| **Features** | ${gherkinScenarios.length} |');
  extractedContent.writeln('| **Generated** | ${DateTime.now().toIso8601String()} |');
  extractedContent.writeln('');
  
  // Add extracted scenarios
  for (final entry in gherkinScenarios.entries) {
    final scenarios = entry.value;
    final uniqueScenarios = scenarios.toSet().toList();
    
    for (final scenario in uniqueScenarios) {
      extractedContent.writeln('');
      extractedContent.writeln(scenario.trim());
      extractedContent.writeln('');
    }
  }
  
  // Remove any existing Code-Embedded Gherkin Scenarios sections
  final cleanedContent = _removeExistingScenariosSections(existingContent);
  
  // Combine with existing content
  final newContent = StringBuffer();
  
  // If there's existing content, preserve it
  if (cleanedContent.isNotEmpty) {
    newContent.writeln(cleanedContent);
    newContent.writeln('');
    newContent.writeln('---');
    newContent.writeln('');
  } else {
    // No existing content, start fresh
    newContent.writeln('# 📄 Scénarios Gherkin - Football Stat Track');
    newContent.writeln('');
  }
  
  // Append extracted scenarios
  newContent.writeln(extractedContent.toString());
  
  // Write the file
  featuresFile.writeAsStringSync(newContent.toString());
  
  print('✅ Written ${gherkinScenarios.length} features with ${_countScenarios(gherkinScenarios)} scenarios');
}

/// Remove existing Code-Embedded Gherkin Scenarios sections from content
String _removeExistingScenariosSections(String content) {
  final lines = content.split('\n');
  final filteredLines = <String>[];
  bool inScenariosSection = false;
  
  for (final line in lines) {
    final trimmed = line.trim();
    
    // Check if we're entering a Code-Embedded Gherkin Scenarios section
    if (trimmed == '## 🔧 Code-Embedded Gherkin Scenarios' ||
        trimmed.startsWith('## 🔧 Code-Embedded Gherkin Scenarios')) {
      inScenariosSection = true;
      continue; // Skip this line and everything until next section
    }
    
    // If we're in a scenarios section, skip until we find a separator or new section
    if (inScenariosSection) {
      if (trimmed == '---' || trimmed.startsWith('#')) {
        inScenariosSection = false;
        // Keep the separator or new section marker
        if (trimmed == '---') {
          continue; // Skip the separator, we'll add a new one
        }
      }
      continue;
    }
    
    filteredLines.add(line);
  }
  
  return filteredLines.join('\n');
}
