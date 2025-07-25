# SNWebAdView Integration Guide

A comprehensive guide to integrating the SNWebAdView iOS SDK into your SwiftUI application.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Initial Setup](#initial-setup)
4. [Basic Implementation](#basic-implementation)
5. [Advanced Features](#advanced-features)
6. [Performance Optimization](#performance-optimization)
7. [Debugging and Testing](#debugging-and-testing)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

- **iOS:** 14.0 or later
- **Xcode:** 13.0 or later  
- **Swift:** 5.5 or later
- **Framework:** SwiftUI

### STEP Network Requirements

Before integrating the SDK, coordinate with STEP Network to obtain:

- **Didomi API Key** - For consent management integration
- **Base Template URL** - Your customized ad template endpoint
- **Ad Unit IDs** - Specific identifiers for your ad placements
- **Custom Targeting Parameters** - Any additional targeting keys configured in Google Ad Manager

## Installation

### Swift Package Manager (Recommended)

1. **In Xcode:**
   - File → Add Package Dependencies...
   - Enter: `https://github.com/STEP-Network/sn-webadview-ios`
   - Select version and add to your target

2. **In Package.swift:**
   ```swift
   dependencies: [
       .package(url: "https://github.com/STEP-Network/sn-webadview-ios", from: "1.0.0")
   ],
   targets: [
       .target(
           name: "YourTarget",
           dependencies: ["SNWebAdView"]
       )
   ]
   ```

### CocoaPods (Alternative)

```ruby
# Podfile
target 'YourApp' do
  pod 'SNWebAdView', '~> 1.0'
end
```

## Initial Setup

### 1. SDK Configuration

Configure the SDK in your app's entry point with your STEP Network credentials:

```swift
import SwiftUI
import SNWebAdView

@main
struct MyPublisherApp: App {
    init() {
        // Configure SDK with your STEP Network credentials
        SNWebAdSDK.configure(
            didomiAPIKey: "your-didomi-api-key",           // Provided by STEP Network
            baseURL: "https://your-ad-template-url.com",    // Your template endpoint
            disableDidomiRemoteConfig: false,              // Usually false
            debugMode: false                               // Enable for development
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Import in Views

Import the SDK in any SwiftUI view where you want to display ads:

```swift
import SwiftUI
import SNWebAdView
```

## Basic Implementation

### Simple Ad Display

The most basic implementation requires only an ad unit ID:

```swift
struct ArticleView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Article content...")
                
                // Simple ad display
                SNWebAdView(adUnitId: "div-gpt-ad-banner")
                
                Text("More content...")
            }
        }
    }
}
```

### Ad with Label

Display an advertisement label for transparency:

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .showAdLabel(true, text: "Advertisement")
    .adLabelFont(.system(size: 11, weight: .medium))
```

### Container Sizing

Control the container dimensions for UI layout stability:

```swift
SNWebAdView(adUnitId: "div-gpt-ad-leaderboard")
    .frame(height: 90)                    // Fixed height
    .maxWidth(.infinity)                  // Fill available width
```

Or with flexible constraints:

```swift
SNWebAdView(adUnitId: "div-gpt-ad-responsive")
    .minWidth(300)
    .maxWidth(728)
    .initialHeight(100)
    .maxHeight(250)
```

## Advanced Features

### Custom Targeting

Add targeting parameters to improve ad relevance. **Important:** All targeting keys must be configured by STEP Network in Google Ad Manager.

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .customTargeting("section", "sports")              // Single value
    .customTargeting("category", "football")
    .customTargeting("tags", ["breaking", "news"])     // Multiple values
    .customTargeting("premium", userIsPremium ? "true" : "false")
```

### Dynamic Targeting from Content

```swift
struct ArticleAdView: View {
    let article: Article
    
    var body: some View {
        SNWebAdView(adUnitId: "div-gpt-ad-inline")
            .customTargeting("section", article.category)
            .customTargeting("author", article.author.slug)
            .customTargeting("tags", article.tags)
            .customTargeting("publish_date", article.publishedDate.formatted())
    }
}
```

### User-Based Targeting

```swift
SNWebAdView(adUnitId: "div-gpt-ad-personalized")
    .customTargeting("user_type", userManager.userType)
    .customTargeting("subscription", userManager.subscriptionLevel)
    .customTargeting("age_group", userManager.demographicGroup)
    .customTargeting("interests", userManager.interests)
```

## Performance Optimization

### Lazy Loading Setup

Enable intelligent lazy loading to optimize performance:

```swift
struct FeedView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(articles) { article in
                    ArticleRowView(article: article)
                    
                    // Ad every 3 articles
                    if article.index % 3 == 0 {
                        SNWebAdView(adUnitId: "div-gpt-ad-feed")
                            .customTargeting("position", "feed-\(article.index)")
                    }
                }
            }
        }
        .snLazyLoadAds(                    // Enable lazy loading
            fetchThreshold: 800,           // Start loading 800pt before visible
            displayThreshold: 200,         // Show ad 200pt before visible
            unloadingEnabled: false        // Don't unload by default
        )
    }
}
```

### Memory Management

For memory-constrained scenarios or long scrolling lists:

```swift
.snLazyLoadAds(
    fetchThreshold: 600,
    displayThreshold: 150,
    unloadingEnabled: true,        // Unload distant ads
    unloadThreshold: 1200          // Unload 1200pt after leaving view
)
```

**Note:** When using unloading, consider locking ad heights to prevent layout shifting:

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .frame(height: 250)            // Fixed height prevents shifting
```

### Advanced Lazy Loading Control

```swift
// Custom configuration per screen
struct NewsListView: View {
    var body: some View {
        ScrollView {
            // Content
        }
        .snLazyLoadAds(
            fetchThreshold: 1000,          // Longer threshold for slower connections
            displayThreshold: 300,         // More time to load
            unloadingEnabled: true         // Save memory on long lists
        )
    }
}
```

## Debugging and Testing

### Enable Debug Mode

```swift
// In SDK configuration
SNWebAdSDK.configure(
    didomiAPIKey: "your-api-key",
    baseURL: "your-template-url",
    debugMode: true                    // Enables debug features
)
```

Or toggle programmatically:

```swift
// Enable debug logging
SNDebugSettings.shared.enableDebugMode()

// Print current configuration
SNDebugSettings.shared.printDebugConfiguration()

// Custom debug logging
SNDebugSettings.shared.log("Custom debug message")
SNDebugSettings.shared.logWarning("Potential issue detected")
```

### Debug Features

When debug mode is enabled:

- **Console Logging:** Detailed logs with `[SN]` prefix
- **Test Targeting:** Automatic `yb_target: 'alwayson-standard'` parameter
- **Network Logging:** Request/response details (if enabled)
- **Performance Metrics:** Lazy loading state changes

### Testing Consent Flow

```swift
// Test consent management
let consent = SNDidomiWrapper.shared

// Check current consent status
let hasConsent = consent.hasConsent()
let status = consent.getConsentStatus()

// Show consent notice for testing
consent.showConsentNotice()

// Reset consent for testing
consent.resetConsent()
```

## Best Practices

### 1. STEP Network Coordination

**Before Implementation:**
- Confirm all ad unit IDs with STEP Network
- Verify custom targeting parameters are configured in Google Ad Manager
- Understand expected ad sizes for each placement
- Coordinate testing procedures

### 2. Performance Best Practices

**ScrollView Optimization:**
```swift
ScrollView {
    LazyVStack(spacing: 20) {          // Use LazyVStack for large lists
        ForEach(content) { item in
            ContentView(item: item)
            
            // Strategic ad placement
            if shouldShowAd(after: item) {
                SNWebAdView(adUnitId: getAdUnitId(for: item))
                    .frame(height: expectedAdHeight)   // Prevent layout shifting
            }
        }
    }
}
.snLazyLoadAds()                       // Always enable lazy loading
```

**Memory Management:**
```swift
// For long-scrolling content
.snLazyLoadAds(unloadingEnabled: true)

// For short content
.snLazyLoadAds(unloadingEnabled: false)
```

### 3. User Experience

**Loading States:**
```swift
struct AdContainerView: View {
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .frame(height: 100)
            }
            
            SNWebAdView(adUnitId: "div-gpt-ad-banner")
                .onAppear { isLoading = false }
        }
    }
}
```

**Responsive Design:**
```swift
// Adapt to different screen sizes
SNWebAdView(adUnitId: "div-gpt-ad-responsive")
    .minWidth(300)
    .maxWidth(.infinity)
    .frame(maxHeight: UIScreen.main.bounds.width > 600 ? 250 : 200)
```

### 4. Error Handling

```swift
struct RobustAdView: View {
    @State private var hasError = false
    
    var body: some View {
        Group {
            if hasError {
                // Fallback content
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 100)
                    .overlay(Text("Ad Space"))
            } else {
                SNWebAdView(adUnitId: "div-gpt-ad-banner")
                    .onReceive(NotificationCenter.default.publisher(for: .adLoadError)) { _ in
                        hasError = true
                    }
            }
        }
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Ads Not Loading

**Symptoms:** Blank ad spaces, no content appearing

**Solutions:**
```swift
// Check SDK configuration
guard SNWebAdSDK.isConfigurationValid else {
    print("SDK not properly configured")
    return
}

// Enable debug mode to see logs
SNWebAdSDK.configure(
    didomiAPIKey: "your-key",
    baseURL: "your-url",
    debugMode: true
)

// Verify network connectivity
// Check that ad unit IDs are correct and active
```

#### 2. Layout Issues

**Symptoms:** Content jumping, inconsistent sizing

**Solutions:**
```swift
// Use fixed heights for consistent layout
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .frame(height: 250)

// Or set initial size to prevent shifting
SNWebAdView(adUnitId: "div-gpt-ad-responsive")
    .initialHeight(200)
    .maxHeight(300)
```

#### 3. Performance Issues

**Symptoms:** Slow scrolling, memory warnings

**Solutions:**
```swift
// Enable unloading for long lists
.snLazyLoadAds(unloadingEnabled: true)

// Increase thresholds to reduce loading frequency
.snLazyLoadAds(
    fetchThreshold: 1200,
    displayThreshold: 400
)

// Limit concurrent ads
// Use LazyVStack instead of VStack
```

#### 4. Consent Issues

**Symptoms:** Ads not personalizing, consent errors

**Solutions:**
```swift
// Check consent status
let hasConsent = SNDidomiWrapper.shared.hasConsent()
let status = SNDidomiWrapper.shared.getConsentStatus()

// Verify Didomi configuration
SNWebAdSDK.configure(
    didomiAPIKey: "correct-api-key",  // Verify this is correct
    baseURL: "your-url",
    disableDidomiRemoteConfig: false  // Usually should be false
)
```

### Debug Checklist

When issues occur:

1. **Enable Debug Mode:**
   ```swift
   SNDebugSettings.shared.enableDebugMode()
   ```

2. **Check Configuration:**
   ```swift
   SNDebugSettings.shared.printDebugConfiguration()
   ```

3. **Verify Console Logs:**
   - Look for `[SN]` prefixed messages
   - Check for error messages
   - Verify ad loading events

4. **Test Consent Flow:**
   ```swift
   SNDidomiWrapper.shared.showConsentNotice()
   ```

5. **Validate Network Requests:**
   - Enable network logging in debug settings
   - Check base URL accessibility
   - Verify ad unit IDs with STEP Network

### Getting Help

1. **Check Debug Logs:** Enable debug mode and review console output
2. **Verify Configuration:** Ensure all STEP Network credentials are correct
3. **Test Basic Implementation:** Start with minimal code and add features incrementally
4. **Coordinate with STEP Network:** For ad configuration or targeting issues

## Migration Notes

### From Manual Implementation

If you're migrating from a manual WebView implementation:

1. **Remove Manual Files:** Delete custom WebView, lazy loading, and consent management code
2. **Update Imports:** Replace custom imports with `import SNWebAdView`
3. **Update Configuration:** Move configuration to SDK setup
4. **Update Components:** Replace custom components with `SNWebAdView`
5. **Test Thoroughly:** Verify all targeting and sizing behavior

### Version Updates

When updating SDK versions:

1. **Check Changelog:** Review breaking changes and new features
2. **Update Configuration:** Check for new configuration options
3. **Test Integration:** Verify existing implementations still work
4. **Update Documentation:** Ensure your integration guide reflects changes

---

This integration guide provides comprehensive instructions for implementing SNWebAdView in your iOS application. For additional support, refer to the [API Reference](API-Reference.md) and contact your STEP Network representative for account-specific configurations.
