# SNWebAdView iOS SDK

A powerful Swift Package for integrating web-based ads into iOS applications using SwiftUI. Built for publishers working with STEP Network's Yield Manager platform.

## Features

- 🎯 **SwiftUI Native** - Built specifically for SwiftUI applications
- 🚀 **Lazy Loading** - Intelligent performance optimization with customizable thresholds
- 🎨 **Automatic Sizing** - Dynamic ad sizing based on content delivered by STEP Network
- 🔒 **Consent Management** - Built-in GDPR/CCPA compliance via Didomi SDK
- 🎛️ **Custom Targeting** - Flexible targeting parameters for improved ad relevance
- 🐛 **Debug Tools** - Comprehensive debugging and logging capabilities
- 📱 **iOS 14+** - Support for modern iOS versions with backward compatibility

## Quick Start

### 1. Installation

Add SNWebAdView to your project using Swift Package Manager:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/STEP-Network/sn-webadview-ios", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/STEP-Network/sn-webadview-ios`
3. Choose version and add to your target

### 2. Configuration

Configure the SDK in your app's entry point:

```swift
import SwiftUI
import SNWebAdView

@main
struct MyApp: App {
    init() {
        // Configure with your STEP Network credentials
        SNWebAdSDK.configure(
            didomiAPIKey: "your-didomi-api-key",
            baseURL: "https://your-ad-template-url.com",
            debugMode: false
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 3. Basic Usage

Display ads in your SwiftUI views:

```swift
import SwiftUI
import SNWebAdView

struct ContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Your content
                Text("Article content here...")
                
                // Display ad
                SNWebAdView(adUnitId: "div-gpt-ad-banner")
                    .customTargeting("section", "sports")
                    .showAdLabel(true)
                
                // More content
                Text("More article content...")
            }
        }
        .snLazyLoadAds() // Enable lazy loading optimization
    }
}
```

## Advanced Usage

### Custom Targeting

Add targeting parameters to improve ad relevance:

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .customTargeting("section", "sports")
    .customTargeting("category", "football")
    .customTargeting("tags", ["breaking", "news", "sports"])
    .customTargeting("premium", "true")
```

### Size Constraints

Control container sizing while maintaining automatic ad sizing:

```swift
SNWebAdView(adUnitId: "div-gpt-ad-responsive")
    .minWidth(300)
    .maxWidth(.infinity)
    .initialHeight(100)
    .maxHeight(250)
```

### Lazy Loading Configuration

Optimize performance with custom lazy loading settings:

```swift
ScrollView {
    // Content with ads
}
.snLazyLoadAds(
    fetchThreshold: 1000,     // Start loading 1000pt before visible
    displayThreshold: 300,    // Show ad 300pt before visible
    unloadingEnabled: true    // Unload distant ads to save memory
)
```

### Debug Mode

Enable debug logging and testing features:

```swift
// Enable in SDK configuration
SNWebAdSDK.configure(
    didomiAPIKey: "your-api-key",
    baseURL: "your-template-url",
    debugMode: true  // Enables debug logging and test targeting
)

// Or toggle programmatically
SNDebugSettings.shared.enableDebugMode()
```

## Requirements

- iOS 14.0 or later
- Swift 5.5 or later
- Xcode 13.0 or later

## Dependencies

- [Didomi SDK](https://github.com/didomi/swift-sdk) - For GDPR/CCPA consent management

## Documentation

- [Integration Guide](Documentation/Integration-Guide.md) - Detailed implementation instructions
- [API Reference](Documentation/API-Reference.md) - Complete API documentation
- [Example App](Examples/ExampleApp/) - Sample implementation

## STEP Network Integration

**⚠️ Important:** Before using this SDK, coordinate with STEP Network regarding:

- Available ad unit IDs for your account
- Custom targeting parameters configuration
- Expected ad sizes and behavior
- Geographic and content targeting requirements

The SDK handles the technical integration, but ad content and targeting are managed by STEP Network's Yield Manager platform.

## Support

For technical issues:
1. Check the [Integration Guide](Documentation/Integration-Guide.md)
2. Review the [API Reference](Documentation/API-Reference.md)
3. Enable debug mode to see detailed logging

For STEP Network account or ad configuration issues, contact your STEP Network representative.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.
