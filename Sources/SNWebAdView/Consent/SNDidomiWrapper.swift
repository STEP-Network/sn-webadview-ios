import Foundation
import Didomi

/// Wrapper for Didomi consent management integration
public class SNDidomiWrapper {
    
    // MARK: - Singleton
    public static let shared = SNDidomiWrapper()
    
    // MARK: - Private Properties
    private var isInitialized = false
    
    // MARK: - Initializer
    private init() {
        debugPrint("[SNDidomiWrapper] Didomi wrapper initialized")
    }
    
    // MARK: - Public Methods
    
    /// Check if user has given consent
    /// - Returns: Whether the user has consented to data processing
    public func hasConsent() -> Bool {
        guard isInitialized else {
            debugPrint("[SNDidomiWrapper] Didomi not initialized")
            return false
        }
        
        let hasConsent = Didomi.shared.isConsentRequired() ? 
            !Didomi.shared.shouldUserStatusBeCollected() : true
        
        debugPrint("[SNDidomiWrapper] Consent status: \(hasConsent)")
        return hasConsent
    }
    
    /// Get JavaScript code for WebView integration
    /// - Returns: JavaScript code string for Didomi WebView integration
    public func getJavaScriptForWebView() -> String {
        guard isInitialized else {
            debugPrint("[SNDidomiWrapper] Didomi not initialized, returning empty JS")
            return ""
        }
        
        let javascript = Didomi.shared.getJavaScriptForWebView()
        debugPrint("[SNDidomiWrapper] Generated JavaScript for WebView")
        return javascript
    }
    
    /// Show consent notice to user
    public func showConsentNotice() {
        guard isInitialized else {
            debugPrint("[SNDidomiWrapper] Cannot show consent notice - Didomi not initialized")
            return
        }
        
        Didomi.shared.showNotice()
        debugPrint("[SNDidomiWrapper] Consent notice displayed")
    }
    
    /// Show consent preferences center
    public func showPreferences() {
        guard isInitialized else {
            debugPrint("[SNDidomiWrapper] Cannot show preferences - Didomi not initialized")
            return
        }
        
        Didomi.shared.showPreferences()
        debugPrint("[SNDidomiWrapper] Consent preferences displayed")
    }
    
    /// Get current consent status information
    /// - Returns: Dictionary with consent status details
    public func getConsentStatus() -> [String: Any] {
        guard isInitialized else {
            return ["error": "Didomi not initialized"]
        }
        
        let status = Didomi.shared.getCurrentUserStatus()
        
        return [
            "hasConsentForAll": !Didomi.shared.shouldUserStatusBeCollected(),
            "hasConsentForPurposes": status.purposes.count > 0,
            "hasConsentForVendors": status.vendors.count > 0,
            "consentString": Didomi.shared.getJavaScriptForWebView()
        ]
    }
    
    /// Reset user consent (for testing purposes)
    public func resetConsent() {
        guard isInitialized else {
            debugPrint("[SNDidomiWrapper] Cannot reset consent - Didomi not initialized")
            return
        }
        
        Didomi.shared.clearUser()
        debugPrint("[SNDidomiWrapper] User consent reset")
    }
    
    // MARK: - Internal Methods
    
    /// Mark Didomi as initialized (called by SDK configuration)
    internal func markAsInitialized() {
        isInitialized = true
        debugPrint("[SNDidomiWrapper] Didomi marked as initialized")
    }
    
    /// Check if Didomi is ready
    internal var isReady: Bool {
        return isInitialized && Didomi.shared.isReady()
    }
    
    /// Set up consent change listener
    internal func setupConsentListener(callback: @escaping () -> Void) {
        guard isInitialized else {
            debugPrint("[SNDidomiWrapper] Cannot setup listener - Didomi not initialized")
            return
        }
        
        Didomi.shared.onReady {
            debugPrint("[SNDidomiWrapper] Didomi is ready, setting up consent listener")
            
            let eventListener = EventListener()
            eventListener.onConsentChanged = { event in
                debugPrint("[SNDidomiWrapper] Consent changed event received")
                DispatchQueue.main.async {
                    callback()
                }
            }
            
            Didomi.shared.addEventListener(listener: eventListener)
        }
    }
}
