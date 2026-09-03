# 🤖 CI/CD Configuration

This directory contains the GitHub Actions workflows for automated testing and building.

## 📁 Workflows

### [`flutter_ci.yml`](workflows/flutter_ci.yml)
**Main CI/CD Pipeline for Flutter Application**

#### Features:
- ✅ **Code Validation** - Flutter analyze, formatting check
- ✅ **Documentation Validation** - Gherkin scenarios extraction
- ✅ **Automatic Testing** - All tests + Gherkin tests
- ✅ **Android Build** - APK generation and artifact upload
- ✅ **Workflow Summary** - Detailed results reporting

#### Triggers:
- On every **push** to `main` branch
- On every **pull request** to `main` branch

#### Jobs:
1. **validate** (5 min) - Code analysis and formatting
2. **test** (10 min) - All tests execution
3. **build-android** (15 min) - APK build and upload
4. **summary** (2 min) - Workflow results summary

## 🚀 Usage

### View Workflow Results
Visit: `https://github.com/clercm-pro/football-stat-track/actions`

### Download APK
After a successful build, you can download the debug APK from the workflow artifacts.

## 🔧 Customization

### Change Flutter Version
Edit the `FLUTTER_VERSION` environment variable in the workflow file:
```yaml
env:
  FLUTTER_VERSION: 'stable'  # Uses latest stable Flutter version
```

**Note:** Latest stable Flutter supports intl 0.20.x (required by this project).

### Add iOS Build
Add a new job to the workflow:
```yaml
build-ios:
  name: Build iOS IPA
  runs-on: macos-latest
  steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
    - run: flutter build ios --debug
```

## 📊 Badges

Add this to your main README.md:
```markdown
![Flutter CI/CD](https://github.com/clercm-pro/football-stat-track/actions/workflows/flutter_ci.yml/badge.svg)
```

## 💡 Tips

- **Free for public repositories** - GitHub Actions is free for open source
- **2000 minutes/month** free for private repositories
- **Artifacts retention** - APK files are kept for 7 days
- **Manual triggers** - You can re-run workflows from the Actions tab

## 🔗 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Action](https://github.com/marketplace/actions/flutter-action)
- [subosito/flutter-action](https://github.com/subosito/flutter-action)
