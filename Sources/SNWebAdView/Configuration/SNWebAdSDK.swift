import Foundation
import Didomi

/// Main SDK configuration class for SNWebAdView
public class SNWebAdSDK {
    
    // MARK: - Private Properties
    private static var isConfigured = false
    
    // MARK: - Internal Configuration Storage
    internal static var didomiAPIKey: String = ""
    internal static var baseURL: String = ""
    internal static var debugMode: Bool = false
    
    // MARK: - Public Configuration
    
    /// Configure the SNWebAdView SDK with publisher-specific settings
    /// - Parameters:
    ///   - didomiAPIKey: Publisher's Didomi API key for consent management
    ///   - baseURL: Template URL for ad loading (e.g., "https://publisher-template.com")
    ///   - disableDidomiRemoteConfig: Whether to disable Didomi remote configuration
    ///   - debugMode: Enable debug logging and targeting parameters
    public static func configure(
        didomiAPIKey: String,
        baseURL: String,
        disableDidomiRemoteConfig: Bool = false,
        debugMode: Bool = false
    ) {
        guard !isConfigured else {
            print("[SNWebAdSDK] Warning: SDK already configured. Ignoring repeated configuration.")
            return
        }
        
        // Store configuration
        self.didomiAPIKey = didomiAPIKey
        self.baseURL = baseURL
        self.debugMode = debugMode
        
        // Configure debug logging
        if debugMode {
            UserDefaults.standard.set(true, forKey: "isDebugEnabled")
        }
        
        // Initialize Didomi with publisher's configuration
        initializeDidomi(
            apiKey: didomiAPIKey,
            disableRemoteConfig: disableDidomiRemoteConfig
        )
        
        isConfigured = true
        
        debugPrint("[SNWebAdSDK] SDK configured successfully")
        debugPrint("[SNWebAdSDK] Base URL: \(baseURL)")
        debugPrint("[SNWebAdSDK] Debug Mode: \(debugMode)")
    }
    
    // MARK: - Internal Methods
    
    /// Get the configured base URL with fallback
    internal static func getBaseURL() -> String {
        return baseURL.isEmpty ? 
            "https://adops.stepdev.dk/wp-content/ad-template.html?didomi-disable-notice=true" : 
            baseURL
    }
    
    /// Check if SDK is configured
    internal static var isConfigurationValid: Bool {
        return isConfigured && !didomiAPIKey.isEmpty && !baseURL.isEmpty
    }
    
    // MARK: - Private Methods
    
    private static func initializeDidomi(apiKey: String, disableRemoteConfig: Bool) {
        let parameters = DidomiInitializeParameters(
            apiKey: apiKey,
            disableDidomiRemoteConfig: disableRemoteConfig
        )
        
        Didomi.shared.initialize(parameters)
        
        // Set up consent change listener
        Didomi.shared.onReady {
            debugPrint("[SNWebAdSDK] Didomi SDK is ready")
            
            let didomiEventListener = EventListener()
            didomiEventListener.onConsentChanged = { event in
                debugPrint("[SNWebAdSDK] Consent event received")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("DidomiConsentChanged"), 
                        object: nil
                    )
                }
            }
            
            Didomi.shared.addEventListener(listener: didomiEventListener)
        }
    }
}
