#!/usr/bin/env dart

/// Test Generator Tool
/// Generates Flutter widget tests from Gherkin scenarios
///
/// Usage: dart run tool/generate_tests.dart

import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  print('🧪 Generating tests from Gherkin scenarios...');
  
  final featuresFile = File('docs/specs/FEATURES.md');
  
  if (!featuresFile.existsSync()) {
    print('❌ FEATURES.md not found!');
    print('💡 Run dart run tool/extract_gherkin.dart first');
    return;
  }
  
  final content = featuresFile.readAsStringSync();
  final scenarios = _parseGherkinScenarios(content);
  
  print('📊 Found ${scenarios.length} scenarios');
  
  // Group scenarios by feature
  final scenariosByFeature = <String, List<GherkinScenario>>{};
  for (final scenario in scenarios) {
    if (!scenariosByFeature.containsKey(scenario.featureId)) {
      scenariosByFeature[scenario.featureId] = [];
    }
    scenariosByFeature[scenario.featureId]!.add(scenario);
  }
  
  // Generate test files
  final testsDir = Directory('test/gherkin');
  if (!testsDir.existsSync()) {
    testsDir.createSync(recursive: true);
  }
  
  for (final entry in scenariosByFeature.entries) {
    final featureId = entry.key;
    final featureScenarios = entry.value;
    
    // Create a test file for this feature
    final testFileName = _sanitizeFileName(featureId) + '_test.dart';
    final testFile = File(path.join(testsDir.path, testFileName));
    
    final testContent = _generateTestFile(featureId, featureScenarios);
    testFile.writeAsStringSync(testContent);
    
    print('✅ Generated: ${testFile.path}');
  }
  
  print('\n🎉 Test generation complete!');
  print('💡 Run tests with: flutter test test/gherkin/');
}

/// Parse Gherkin scenarios from FEATURES.md
List<GherkinScenario> _parseGherkinScenarios(String content) {
  final scenarios = <GherkinScenario>[];
  final lines = content.split('\n');
  
  GherkinScenario? currentScenario;
  String? currentFeatureId;
  String? currentFeatureTitle;
  
  for (final line in lines) {
    final trimmed = line.trim();
    
    // Skip empty lines and separators
    if (trimmed.isEmpty || trimmed == '---' || trimmed.startsWith('|')) {
      continue;
    }
    
    // Feature tag line (e.g., @BUG-COM-01 @high @regression)
    if (trimmed.startsWith('@') && !trimmed.contains('Feature:')) {
      // Extract feature ID (first tag that's not @gherkin)
      final tags = trimmed.split(' ').where((t) => t.startsWith('@')).toList();
      for (final tag in tags) {
        if (tag != '@gherkin' && tag != '@') {
          currentFeatureId = tag.substring(1); // Remove @
          break;
        }
      }
      continue;
    }
    
    // Feature title line
    if (trimmed.startsWith('Feature:')) {
      currentFeatureTitle = trimmed.substring('Feature:'.length).trim();
      continue;
    }
    
    // Scenario line
    if (trimmed.startsWith('Scenario:') || trimmed.startsWith('@') && trimmed.contains('Scenario:')) {
      // This is a scenario line
      final scenarioIdMatch = RegExp(r'@([A-Z0-9-]+)-\d+').firstMatch(trimmed);
      final scenarioId = scenarioIdMatch?.group(1) ?? currentFeatureId ?? 'UNKNOWN';
      
      final scenarioTitle = trimmed.startsWith('Scenario:') 
          ? trimmed.substring('Scenario:'.length).trim()
          : trimmed.substring(trimmed.indexOf('Scenario:') + 'Scenario:'.length).trim();
      
      currentScenario = GherkinScenario(
        featureId: currentFeatureId ?? 'UNKNOWN',
        featureTitle: currentFeatureTitle ?? 'Untitled',
        scenarioId: scenarioId,
        title: scenarioTitle,
        steps: [],
        tags: [],
      );
      scenarios.add(currentScenario);
      continue;
    }
    
    // Step lines (Given, When, Then, And)
    if (currentScenario != null) {
      if (trimmed.startsWith('Given ') || 
          trimmed.startsWith('When ') || 
          trimmed.startsWith('Then ') || 
          trimmed.startsWith('And ') ||
          trimmed.startsWith('But ')) {
        currentScenario.steps.add(trimmed);
        continue;
      }
      
      // Background section
      if (trimmed.startsWith('Background:')) {
        // Skip for now
        continue;
      }
    }
    
    // Tag lines for scenarios
    if (currentScenario != null && trimmed.startsWith('@') && trimmed.contains('-')) {
      currentScenario.tags.add(trimmed);
    }
  }
  
  return scenarios;
}

/// Generate test file content
String _generateTestFile(String featureId, List<GherkinScenario> scenarios) {
  final buffer = StringBuffer();
  
  // Header
  buffer.writeln('import \'package:flutter/material.dart\';');
  buffer.writeln('import \'package:flutter_test/flutter_test.dart\';');
  buffer.writeln('import \'package:flutter_riverpod/flutter_riverpod.dart\';');
  buffer.writeln('');
  buffer.writeln('// DO NOT EDIT MANUALLY - Generated from Gherkin scenarios');
  buffer.writeln('// Source: docs/specs/FEATURES.md');
  buffer.writeln('// To update: Edit Gherkin scenarios and run dart run tool/generate_tests.dart');
  buffer.writeln('');
  
  // Test group
  buffer.writeln('void main() {');
  
  for (final scenario in scenarios) {
    // Generate test name
    final testName = '@${scenario.scenarioId} - ${scenario.title}';
    buffer.writeln('  testWidgets(\'$testName\', (final WidgetTester tester) async {');
    buffer.writeln('    // TODO: Implement test based on Gherkin scenario');
    buffer.writeln('    // Scenario: ${scenario.title}');
    
    // Add step comments
    for (final step in scenario.steps) {
      buffer.writeln('    // $step');
    }
    
    buffer.writeln('    // Test implementation needed');
    buffer.writeln('  });');
    buffer.writeln('');
  }
  
  buffer.writeln('}');
  
  return buffer.toString();
}

/// Sanitize feature ID for use in filename
String _sanitizeFileName(String fileName) {
  return fileName
      .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')
      .toLowerCase()
      .replaceAll(RegExp(r'__+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

/// Gherkin Scenario data class
class GherkinScenario {
  final String featureId;
  final String featureTitle;
  final String scenarioId;
  final String title;
  final List<String> steps;
  final List<String> tags;
  
  GherkinScenario({
    required this.featureId,
    required this.featureTitle,
    required this.scenarioId,
    required this.title,
    required this.steps,
    required this.tags,
  });
}
