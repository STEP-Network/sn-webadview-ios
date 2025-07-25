# SNWebAdView API Reference

A comprehensive reference for all public APIs in the SNWebAdView iOS SDK.

## SNWebAdSDK

The main SDK configuration class for initializing the SDK with publisher-specific settings.

### Method Summary

| Name        | Description                                           |
|-------------|-------------------------------------------------------|
| `configure` | Initialize the SDK with publisher-specific settings  |

---

### `configure`

Initialize the SNWebAdView SDK with Didomi API key and base URL configuration.

#### Signature

```swift
SNWebAdSDK.configure(didomiAPIKey:baseURL:disableDidomiRemoteConfig:debugMode:)
```

#### Types

```swift
/**
 * @param didomiAPIKey: String - Publisher's Didomi API key for consent management
 * @param baseURL: String - Template URL for ad loading provided by STEP Network
 * @param disableDidomiRemoteConfig: Bool - Disable remote Didomi configuration (default: false)
 * @param debugMode: Bool - Enable debug logging and test targeting (default: false)
 * @returns void
 */
```

#### Example

```swift
SNWebAdSDK.configure(
    didomiAPIKey: "d0661bea-d696-4069-b308-11057215c4c4",
    baseURL: "https://adops.stepdev.dk/wp-content/ad-template.html",
    debugMode: true
)
```

---

## SNWebAdView

Main SwiftUI component for displaying web-based ads with automatic sizing and consent management.

### Initializer Summary

| Name   | Description                           |
|--------|---------------------------------------|
| `init` | Create new WebAdView with ad unit ID  |

### Method Summary

| Name               | Description                                    |
|--------------------|------------------------------------------------|
| `customTargeting`  | Add custom targeting parameters               |
| `showAdLabel`      | Display advertisement label                   |
| `adLabelFont`      | Set advertisement label font                  |
| `initialWidth`     | Set initial container width                   |
| `initialHeight`    | Set initial container height                  |
| `minWidth`         | Set minimum container width                   |
| `maxWidth`         | Set maximum container width                   |
| `minHeight`        | Set minimum container height                  |
| `maxHeight`        | Set maximum container height                  |

---

### `init`

Create a new SNWebAdView with the specified ad unit ID.

#### Signature

```swift
SNWebAdView(adUnitId: String)
```

#### Types

```swift
/**
 * @param adUnitId: String - Ad unit identifier provided by STEP Network
 * @returns SNWebAdView instance
 */
```

#### Example

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
```

---

### `customTargeting`

Add custom targeting parameters to improve ad relevance and campaign targeting. Parameters must be configured by STEP Network within Google Ad Manager.

#### Signature

```swift
.customTargeting(_ key: String, _ value: String) -> SNWebAdView
.customTargeting(_ key: String, _ values: [String]) -> SNWebAdView
```

#### Types

```swift
/**
 * @param key: String - Targeting parameter key (must be configured in GAM)
 * @param value: String - Single targeting value
 * @param values: [String] - Array of targeting values
 * @returns Modified SNWebAdView instance
 */
```

#### Example

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .customTargeting("section", "sports")
    .customTargeting("tags", ["breaking", "news", "politics"])
```

---

### `showAdLabel`

Display an advertisement label above the ad content.

#### Signature

```swift
.showAdLabel(_ show: Bool = true, text: String = "annonce") -> SNWebAdView
```

#### Types

```swift
/**
 * @param show: Bool - Whether to show the label (default: true)
 * @param text: String - Label text content (default: "annonce")
 * @returns Modified SNWebAdView instance
 */
```

#### Example

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .showAdLabel(true, text: "Advertisement")
```

---

### `adLabelFont`

Set the font for the advertisement label.

#### Signature

```swift
.adLabelFont(_ font: Font) -> SNWebAdView
```

#### Types

```swift
/**
 * @param font: Font - SwiftUI Font for the label
 * @returns Modified SNWebAdView instance
 */
```

#### Example

```swift
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .showAdLabel(true)
    .adLabelFont(.system(size: 12, weight: .medium))
```

---

### Size Constraint Methods

Control the container dimensions for UI layout stability. These constraints affect the container layout only - actual ad content dimensions are controlled by STEP Network's Yield Manager.

#### `initialWidth` / `initialHeight`

Set initial dimensions for the container.

#### Signature

```swift
.initialWidth(_ width: CGFloat) -> SNWebAdView
.initialHeight(_ height: CGFloat) -> SNWebAdView
```

#### `minWidth` / `maxWidth` / `minHeight` / `maxHeight`

Set flexible constraints that adapt to different screen sizes.

#### Signature

```swift
.minWidth(_ width: CGFloat) -> SNWebAdView
.maxWidth(_ width: CGFloat) -> SNWebAdView
.minHeight(_ height: CGFloat) -> SNWebAdView
.maxHeight(_ height: CGFloat) -> SNWebAdView
```

#### Example

```swift
SNWebAdView(adUnitId: "div-gpt-ad-responsive")
    .minWidth(300)
    .maxWidth(.infinity)
    .initialHeight(100)
    .maxHeight(250)
```

---

## SNLazyLoadingManager

Singleton manager that optimizes ad performance through intelligent lazy loading.

### Property Summary

| Name               | Description                                |
|--------------------|--------------------------------------------|
| `shared`           | Singleton instance                         |
| `fetchThreshold`   | Distance to start fetching ads             |
| `displayThreshold` | Distance to start displaying ads           |
| `unloadThreshold`  | Distance to unload ads                     |
| `unloadingEnabled` | Whether to unload distant ads              |

### Method Summary

| Name               | Description                                |
|--------------------|--------------------------------------------|
| `registerAdUnit`   | Register ad unit for lazy loading          |
| `unregisterAdUnit` | Unregister ad unit from lazy loading       |
| `updateVisibility` | Update visibility state for ad unit        |
| `shouldFetchAd`    | Check if ad should be fetched              |
| `shouldDisplayAd`  | Check if ad should be displayed            |

---

### Properties

#### `fetchThreshold`

Distance in points before a view becomes visible to start fetching ads.

#### Signature

```swift
var fetchThreshold: CGFloat { get set }
```

**Default:** `800`

#### `displayThreshold`

Distance in points before a view becomes visible to start displaying ads.

#### Signature

```swift
var displayThreshold: CGFloat { get set }
```

**Default:** `200`

#### `unloadThreshold`

Distance in points after a view leaves the screen to unload ads.

#### Signature

```swift
var unloadThreshold: CGFloat { get set }
```

**Default:** `1600`

#### `unloadingEnabled`

Whether to unload ads when they're far from view to save memory.

#### Signature

```swift
var unloadingEnabled: Bool { get set }
```

**Default:** `false`

---

### Methods

#### `registerAdUnit`

Register an ad unit for lazy loading management.

#### Signature

```swift
func registerAdUnit(_ adUnitId: String)
```

#### `shouldFetchAd` / `shouldDisplayAd`

Check loading state for an ad unit.

#### Signature

```swift
func shouldFetchAd(for adUnitId: String) -> Bool
func shouldDisplayAd(for adUnitId: String) -> Bool
```

---

## View Extensions

SwiftUI View extensions for enabling lazy loading functionality.

### `snLazyLoadAds`

Enable lazy loading for ads in the view hierarchy.

#### Signature

```swift
func snLazyLoadAds(
    fetchThreshold: CGFloat = 800,
    displayThreshold: CGFloat = 200,
    unloadingEnabled: Bool = false
) -> some View
```

#### Types

```swift
/**
 * @param fetchThreshold: CGFloat - Distance to start fetching (default: 800pt)
 * @param displayThreshold: CGFloat - Distance to start displaying (default: 200pt)  
 * @param unloadingEnabled: Bool - Whether to unload distant ads (default: false)
 * @returns View with lazy loading enabled
 */
```

#### Example

```swift
ScrollView {
    LazyVStack {
        // Content with ads
    }
}
.snLazyLoadAds(
    fetchThreshold: 1000,
    displayThreshold: 300,
    unloadingEnabled: true
)
```

---

## SNDebugSettings

Debug configuration and logging utilities.

### Property Summary

| Name                  | Description                        |
|-----------------------|------------------------------------|
| `shared`              | Singleton instance                 |
| `isDebugEnabled`      | Whether debug mode is enabled      |
| `showAdBorders`       | Show visual borders around ads     |
| `logNetworkRequests`  | Log network request details        |

### Method Summary

| Name                     | Description                           |
|--------------------------|---------------------------------------|
| `enableDebugMode`        | Enable debug logging                  |
| `disableDebugMode`       | Disable debug logging                 |
| `toggleDebugMode`        | Toggle debug mode state               |
| `log`                    | Log debug message                     |
| `logWarning`             | Log warning message                   |
| `logError`               | Log error message                     |
| `logSuccess`             | Log success message                   |
| `getDebugConfiguration`  | Get current debug settings            |
| `printDebugConfiguration`| Print debug settings to console       |
| `resetToDefaults`        | Reset all settings to defaults        |

---

### Methods

#### `enableDebugMode` / `disableDebugMode` / `toggleDebugMode`

Control debug mode state.

#### Signature

```swift
func enableDebugMode()
func disableDebugMode()
func toggleDebugMode()
```

#### `log`

Log debug messages with customizable prefixes.

#### Signature

```swift
func log(_ message: String)
func log(_ message: String, prefix: String)
func logWarning(_ message: String)
func logError(_ message: String)
func logSuccess(_ message: String)
```

#### Example

```swift
let debug = SNDebugSettings.shared
debug.enableDebugMode()
debug.log("Custom debug message")
debug.logWarning("Something might be wrong")
debug.logError("An error occurred")
```

---

## SNDidomiWrapper

Wrapper for Didomi consent management integration.

### Method Summary

| Name                    | Description                              |
|-------------------------|------------------------------------------|
| `shared`                | Singleton instance                       |
| `hasConsent`            | Check if user has given consent          |
| `getJavaScriptForWebView` | Get JavaScript for WebView integration |
| `showConsentNotice`     | Display consent notice to user           |
| `showPreferences`       | Show consent preferences center          |
| `getConsentStatus`      | Get detailed consent status information  |
| `resetConsent`          | Reset user consent (testing purposes)   |

---

### Methods

#### `hasConsent`

Check if the user has given consent for data processing.

#### Signature

```swift
func hasConsent() -> Bool
```

#### `getJavaScriptForWebView`

Get JavaScript code for Didomi WebView integration.

#### Signature

```swift
func getJavaScriptForWebView() -> String
```

#### `showConsentNotice` / `showPreferences`

Display consent management UI to the user.

#### Signature

```swift
func showConsentNotice()
func showPreferences()
```

#### `getConsentStatus`

Get detailed information about current consent status.

#### Signature

```swift
func getConsentStatus() -> [String: Any]
```

#### Returns

Dictionary containing:
- `hasConsentForAll`: Bool
- `hasConsentForPurposes`: Bool  
- `hasConsentForVendors`: Bool
- `consentString`: String

#### Example

```swift
let consent = SNDidomiWrapper.shared
let hasConsent = consent.hasConsent()
let status = consent.getConsentStatus()

if !hasConsent {
    consent.showConsentNotice()
}
```

---

## Global Functions

### `snDebugPrint`

Global debug printing function with SN prefix.

#### Signature

```swift
func snDebugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n")
```

#### Example

```swift
snDebugPrint("Debug message with SN prefix")
```

---

## Types

### `AdLoadState`

Enumeration representing the loading state of an ad.

#### Cases

```swift
public enum AdLoadState: String, CaseIterable, Equatable, Identifiable {
    case idle = "idle"         // Ad not yet loading
    case loading = "loading"   // Ad is currently loading  
    case loaded = "loaded"     // Ad has loaded successfully
    case error = "error"       // Ad failed to load
}
```

---

## Important Notes

### STEP Network Integration

- **Custom targeting parameters** must be configured by STEP Network within Google Ad Manager before they become usable for campaign targeting
- **Ad unit IDs** must be provided by STEP Network for your specific setup
- **Container size constraints** are for UI layout only and do not influence actual ad dimensions
- **Ad sizing is controlled remotely** by STEP Network's Yield Manager

### Size Override Capability

While the SDK provides automatic sizing, you can intentionally override this behavior:

```swift
// This WILL lock the ad to exactly 300x250
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .frame(width: 300, height: 250)

// This allows flexibility while providing bounds  
SNWebAdView(adUnitId: "div-gpt-ad-banner")
    .frame(maxWidth: .infinity, maxHeight: 300)
```

**⚠️ Coordination Required:** If you need fixed dimensions, coordinate with STEP Network to ensure Yield Manager delivers ads compatible with your size constraints.
