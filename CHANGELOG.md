# Changelog

All notable changes to the SNWebAdView SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial SDK development and documentation

## [1.0.0] - 2024-01-15

### Added
- **Initial Release** - SNWebAdView iOS SDK for STEP Network publishers
- **Core Components:**
  - `SNWebAdView` - Main SwiftUI component for displaying ads with automatic sizing
  - `SNWebAdSDK` - SDK configuration and initialization management
  - `SNLazyLoadingManager` - Intelligent lazy loading system for performance optimization
  - `SNDidomiWrapper` - Consent management integration with Didomi SDK
  - `SNDebugSettings` - Comprehensive debugging and logging utilities

### Features
- **SwiftUI Integration** - Native SwiftUI component with environment support
- **Automatic Sizing** - Dynamic ad sizing with configurable constraints
- **Custom Targeting** - Support for custom targeting parameters in Google Ad Manager
- **Lazy Loading** - Configurable lazy loading with visibility thresholds
- **Memory Management** - Optional ad unloading for memory optimization
- **Consent Management** - GDPR/CCPA compliance through Didomi SDK integration
- **Debug Support** - Comprehensive logging and debugging tools
- **Container Sizing** - Flexible container constraints for layout stability

### Technical Specifications
- **Minimum iOS Version:** 14.0
- **Swift Version:** 5.5+
- **Framework:** SwiftUI
- **Dependencies:** Didomi SDK for consent management
- **Package Manager:** Swift Package Manager support

### Documentation
- Complete API Reference documentation
- Comprehensive Integration Guide
- README with quick start instructions
- Example usage patterns and best practices

### Configuration Options
- **Configurable Base URL** - Custom ad template endpoint
- **Didomi API Key** - Publisher-specific consent management configuration
- **Debug Mode** - Development and testing support
- **Remote Configuration** - Optional Didomi remote config disable

### Performance Features
- **Lazy Loading Thresholds:**
  - Configurable fetch threshold (default: 1000pt)
  - Configurable display threshold (default: 200pt)
  - Optional unloading with configurable threshold (default: 1500pt)
- **Memory Optimization** - Intelligent ad lifecycle management
- **Throttled Updates** - Performance-optimized visibility checking

### Debug Features
- **Structured Logging** - Consistent debug output with `[SN]` prefix
- **Configuration Validation** - Runtime configuration checking
- **Performance Metrics** - Lazy loading state monitoring
- **Test Targeting** - Automatic test parameters in debug mode

### Publisher Integration
- **Swift Package Manager** - Easy installation and dependency management
- **Namespace Protection** - All public APIs prefixed with `SN` to prevent conflicts
- **Environment Integration** - SwiftUI environment support for global configuration
- **STEP Network Coordination** - Designed for seamless STEP Network publisher onboarding

---

## Version History Summary

| Version | Release Date | Key Features |
|---------|-------------|--------------|
| 1.0.0   | 2024-01-15  | Initial release with core ad display, lazy loading, and consent management |

---

## Upgrade Guide

### Upgrading to 1.0.0

This is the initial release. For publishers migrating from manual WebView implementations:

#### Breaking Changes
- **None** - Initial release

#### Migration Steps
1. **Install SDK** via Swift Package Manager or CocoaPods
2. **Configure SDK** in app initialization with STEP Network credentials
3. **Replace Manual Components** with `SNWebAdView`
4. **Update Targeting** to use `.customTargeting()` modifier
5. **Enable Lazy Loading** with `.snLazyLoadAds()` modifier

#### New Configuration Required
```swift
// Add to app initialization
SNWebAdSDK.configure(
    didomiAPIKey: "your-didomi-api-key",
    baseURL: "https://your-ad-template-url.com"
)
```

#### Updated Component Usage
```swift
// Replace manual WebView implementation
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .customTargeting("section", "sports")
    .frame(height: 250)
```

---

## Support and Compatibility

### iOS Version Support
- **Current:** iOS 14.0 and later
- **Recommended:** iOS 15.0 and later for optimal performance

### Xcode Version Support
- **Minimum:** Xcode 13.0
- **Recommended:** Xcode 14.0 and later

### Swift Version Support
- **Minimum:** Swift 5.5
- **Recommended:** Swift 5.7 and later

---

## Known Issues

### Version 1.0.0

- **None currently identified**

---

## Future Roadmap

### Planned Features (Future Versions)

#### Version 1.1.0 (Planned)
- **Enhanced Analytics** - Built-in viewability and performance metrics
- **A/B Testing Support** - SDK-level testing framework integration
- **Advanced Caching** - Intelligent ad content caching for improved performance
- **Additional Size Constraints** - More flexible sizing options

#### Version 1.2.0 (Planned)
- **Video Ad Support** - Enhanced support for video ad formats
- **Custom Event Tracking** - Publisher-defined event reporting
- **Advanced Targeting** - Location-based and behavioral targeting helpers

#### Version 2.0.0 (Planned)
- **iOS 13.0 Support** - Backward compatibility (if requested)
- **UIKit Bridge** - UIKit wrapper for non-SwiftUI projects
- **Advanced Memory Management** - Enhanced performance optimization tools

---

## Contributing

This SDK is developed and maintained by STEP Network for publisher integration. For feature requests, bug reports, or integration assistance, please contact your STEP Network representative.

### Reporting Issues

When reporting issues, please include:

1. **SDK Version** - The version number you're using
2. **iOS Version** - Device iOS version
3. **Xcode Version** - Development environment version
4. **Debug Logs** - Console output with debug mode enabled
5. **Reproduction Steps** - Clear steps to reproduce the issue
6. **Expected Behavior** - What should happen
7. **Actual Behavior** - What actually happens

### Debug Information Collection

```swift
// Enable debug mode and collect logs
SNDebugSettings.shared.enableDebugMode()
SNDebugSettings.shared.printDebugConfiguration()

// Include this output in issue reports
```

---

## License and Legal

This SDK is proprietary software provided by STEP Network for authorized publishers. See LICENSE file for detailed terms and conditions.

### Third-Party Dependencies

- **Didomi SDK** - Consent management platform (see Didomi license terms)

### Privacy and Compliance

This SDK is designed to comply with:
- **GDPR** - General Data Protection Regulation
- **CCPA** - California Consumer Privacy Act  
- **COPPA** - Children's Online Privacy Protection Act
- **App Store Guidelines** - Apple App Store Review Guidelines

Publishers are responsible for ensuring compliance with applicable privacy laws and regulations in their specific use case and jurisdiction.
