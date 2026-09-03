# 🛠️ Gherkin Extraction Tool

## Overview

This tool extracts Gherkin scenarios from Dart code annotations and generates/updates `docs/specs/FEATURES.md` automatically.

## Usage

```bash
# Extract Gherkin scenarios from all Dart files and update FEATURES.md
dart run tool/extract_gherkin.dart
```

## How It Works

1. **Annotate your code** with `@gherkin` tags followed by Gherkin syntax
2. **Run the extractor** to generate/update FEATURES.md
3. **Preserves existing content** - adds new scenarios without removing manual ones

## Annotation Format

Add Gherkin scenarios in Dart doc comments using the `@gherkin` tag:

```dart
/// @gherkin
/// @FEATURE-ID @priority @tags
/// Feature: Description of the feature
///
///   Background:
///     Given some context
///
///   @SCENARIO-ID
///   Scenario: Description
///     Given condition
///     When action
///     Then result
class MyWidget extends StatelessWidget {
  // ...
}
```

## Example

```dart
/// @gherkin
/// @BUG-COM-01 @high @regression @compilation
/// Feature: ProfileScreen compilation without debug methods
///
///   Background:
///     Given Flutter 3.x+ project
///
///   @BUG-COM-01-1
///   Scenario: Compilation fails with debugFillProperties
///     Given ProfileScreen contains debugFillProperties method
///     When Running flutter build apk
///     Then Compilation fails with "DiagnosticPropertiesBuilder not found"
///
///   @BUG-COM-01-2
///   Scenario: Compilation succeeds without debug methods
///     Given ProfileScreen has no debugFillProperties method
///     When Running flutter build apk
///     Then Compilation succeeds
class ProfileScreen extends ConsumerWidget {
  // ...
}
```

## Output

The tool will:
- Extract all scenarios with `@gherkin` tag
- Group them by feature ID
- Append to `docs/specs/FEATURES.md`
- Preserve existing manual scenarios
- Add statistics header

## Benefits

✅ **100% Coverage** - Every bug/feature in code has a scenario
✅ **No Manual Maintenance** - Scenarios stay with the code
✅ **Always Up-to-Date** - Regenerate when code changes
✅ **Zero Regression Gaps** - If it's in code, it's in docs

## Workflow v5.0 "Quality First"

1. **Develop** with `@gherkin` annotations
2. **Run extractor** to update FEATURES.md
3. **Commit** code + generated docs together
4. **CI/CD** verifies scenarios exist (future)

## Future Enhancements

- [ ] Generate test files from Gherkin scenarios
- [ ] CI/CD check for 100% coverage
- [ ] IDE plugin for annotation assistance
- [ ] Support for more Gherkin syntax features

## Notes

- Lines must start with `///` to be parsed
- `@gherkin` tag marks the start of a Gherkin block
- All subsequent `///` lines are part of the scenario until a non-comment line
- Empty `///` lines create blank lines in the output
