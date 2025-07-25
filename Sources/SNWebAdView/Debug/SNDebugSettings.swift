import Foundation
import SwiftUI

/// Debug settings and utilities for SNWebAdView SDK
public class SNDebugSettings: ObservableObject {
    
    // MARK: - Singleton
    public static let shared = SNDebugSettings()
    
    // MARK: - Published Properties
    @Published public var isDebugEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isDebugEnabled, forKey: "isDebugEnabled")
            debugPrint("[SNDebugSettings] Debug mode changed to: \(isDebugEnabled)")
        }
    }
    
    @Published public var showAdBorders: Bool = false {
        didSet {
            debugPrint("[SNDebugSettings] Show ad borders changed to: \(showAdBorders)")
        }
    }
    
    @Published public var logNetworkRequests: Bool = false {
        didSet {
            debugPrint("[SNDebugSettings] Log network requests changed to: \(logNetworkRequests)")
        }
    }
    
    // MARK: - Private Properties
    private let debugPrefix = "[SN]"
    
    // MARK: - Initializer
    private init() {
        self.isDebugEnabled = UserDefaults.standard.bool(forKey: "isDebugEnabled")
        debugPrint("[SNDebugSettings] Debug settings initialized")
    }
    
    // MARK: - Public Methods
    
    /// Enable debug mode
    public func enableDebugMode() {
        isDebugEnabled = true
    }
    
    /// Disable debug mode
    public func disableDebugMode() {
        isDebugEnabled = false
    }
    
    /// Toggle debug mode
    public func toggleDebugMode() {
        isDebugEnabled.toggle()
    }
    
    /// Log debug message with SN prefix
    /// - Parameter message: Message to log
    public func log(_ message: String) {
        if isDebugEnabled {
            print("\(debugPrefix) \(message)")
        }
    }
    
    /// Log debug message with custom prefix
    /// - Parameters:
    ///   - message: Message to log
    ///   - prefix: Custom prefix to use
    public func log(_ message: String, prefix: String) {
        if isDebugEnabled {
            print("[\(prefix)] \(message)")
        }
    }
    
    /// Log warning message
    /// - Parameter message: Warning message to log
    public func logWarning(_ message: String) {
        if isDebugEnabled {
            print("\(debugPrefix) ⚠️ WARNING: \(message)")
        }
    }
    
    /// Log error message
    /// - Parameter message: Error message to log
    public func logError(_ message: String) {
        if isDebugEnabled {
            print("\(debugPrefix) ❌ ERROR: \(message)")
        }
    }
    
    /// Log success message
    /// - Parameter message: Success message to log
    public func logSuccess(_ message: String) {
        if isDebugEnabled {
            print("\(debugPrefix) ✅ SUCCESS: \(message)")
        }
    }
    
    /// Get current debug configuration as dictionary
    /// - Returns: Dictionary containing current debug settings
    public func getDebugConfiguration() -> [String: Any] {
        return [
            "isDebugEnabled": isDebugEnabled,
            "showAdBorders": showAdBorders,
            "logNetworkRequests": logNetworkRequests,
            "sdkVersion": getSdkVersion()
        ]
    }
    
    /// Print current debug configuration to console
    public func printDebugConfiguration() {
        let config = getDebugConfiguration()
        log("=== SNWebAdView Debug Configuration ===")
        for (key, value) in config {
            log("\(key): \(value)")
        }
        log("=====================================")
    }
    
    /// Reset all debug settings to defaults
    public func resetToDefaults() {
        isDebugEnabled = false
        showAdBorders = false
        logNetworkRequests = false
        log("Debug settings reset to defaults")
    }
    
    // MARK: - Internal Methods
    
    /// Set debug mode from SDK configuration
    /// - Parameter enabled: Whether debug mode should be enabled
    internal func setDebugMode(_ enabled: Bool) {
        isDebugEnabled = enabled
    }
    
    // MARK: - Private Methods
    
    private func getSdkVersion() -> String {
        // In a real implementation, this would come from Bundle or version file
        return "1.0.0"
    }
}

// MARK: - SwiftUI Environment
private struct SNDebugSettingsKey: EnvironmentKey {
    static let defaultValue = SNDebugSettings.shared
}

extension EnvironmentValues {
    /// Access to SNDebugSettings in SwiftUI environment
    public var snDebugSettings: SNDebugSettings {
        get { self[SNDebugSettingsKey.self] }
        set { self[SNDebugSettingsKey.self] = newValue }
    }
}

// MARK: - SwiftUI View Extension
extension View {
    /// Inject SNDebugSettings into the environment
    /// - Returns: View with debug settings in environment
    public func snDebugSettings() -> some View {
        self.environment(\.snDebugSettings, SNDebugSettings.shared)
    }
}

// MARK: - Global Debug Helper
/// Global debug print function with SN prefix
/// - Parameters:
///   - items: Items to print
///   - separator: Separator between items
///   - terminator: String to print at the end
@_disfavoredOverload
public func snDebugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let isDebugEnabled = UserDefaults.standard.bool(forKey: "isDebugEnabled")
    if isDebugEnabled {
        print("[SN]", items, separator: separator, terminator: terminator)
    }
}

// MARK: - Debug Helper (Internal)
internal func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let isDebugEnabled = UserDefaults.standard.bool(forKey: "isDebugEnabled")
    if isDebugEnabled {
        print(items, separator: separator, terminator: terminator)
    }
}
