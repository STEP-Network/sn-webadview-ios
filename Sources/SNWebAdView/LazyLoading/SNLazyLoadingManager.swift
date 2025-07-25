import SwiftUI
import Combine

/// Lazy loading manager for optimizing ad performance
public class SNLazyLoadingManager: ObservableObject {
    
    // MARK: - Singleton
    public static let shared = SNLazyLoadingManager()
    
    // MARK: - Public Configuration
    
    /// Distance in points before a view becomes visible to start fetching ads
    public var fetchThreshold: CGFloat = 800
    
    /// Distance in points before a view becomes visible to start displaying ads  
    public var displayThreshold: CGFloat = 200
    
    /// Distance in points after a view leaves the screen to unload ads
    public var unloadThreshold: CGFloat = 1600
    
    /// Whether to unload ads when they're far from view to save memory
    public var unloadingEnabled: Bool = false
    
    // MARK: - Private Properties
    @Published private var visibilityStates: [String: VisibilityState] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Internal Types
    internal struct VisibilityState {
        var isVisible: Bool = false
        var isFetched: Bool = false
        var isDisplayed: Bool = false
        var frame: CGRect = .zero
        var scrollBounds: CGRect = .zero
        var lastUpdateTime: Date = Date()
    }
    
    // MARK: - Initializer
    private init() {
        debugPrint("[SNLazyLoadingManager] Lazy loading manager initialized")
    }
    
    // MARK: - Public Methods
    
    /// Register an ad unit for lazy loading
    /// - Parameter adUnitId: The ad unit identifier
    public func registerAdUnit(_ adUnitId: String) {
        if visibilityStates[adUnitId] == nil {
            visibilityStates[adUnitId] = VisibilityState()
            debugPrint("[SNLazyLoadingManager] Registered ad unit: \(adUnitId)")
        }
    }
    
    /// Unregister an ad unit from lazy loading
    /// - Parameter adUnitId: The ad unit identifier
    public func unregisterAdUnit(_ adUnitId: String) {
        visibilityStates.removeValue(forKey: adUnitId)
        debugPrint("[SNLazyLoadingManager] Unregistered ad unit: \(adUnitId)")
    }
    
    /// Update visibility state for an ad unit
    /// - Parameters:
    ///   - adUnitId: The ad unit identifier
    ///   - frame: Current frame of the ad view
    ///   - scrollBounds: Current scroll view bounds
    public func updateVisibility(for adUnitId: String, frame: CGRect, scrollBounds: CGRect) {
        guard var state = visibilityStates[adUnitId] else { return }
        
        // Throttle updates to avoid excessive calculations
        let now = Date()
        if now.timeIntervalSince(state.lastUpdateTime) < 0.1 { // 100ms throttle
            return
        }
        
        state.frame = frame
        state.scrollBounds = scrollBounds
        state.lastUpdateTime = now
        
        // Calculate visibility
        let wasVisible = state.isVisible
        state.isVisible = calculateVisibility(frame: frame, scrollBounds: scrollBounds)
        
        // Handle fetch threshold
        if !state.isFetched && shouldFetch(frame: frame, scrollBounds: scrollBounds) {
            state.isFetched = true
            debugPrint("[SNLazyLoadingManager] Fetch triggered for: \(adUnitId)")
        }
        
        // Handle display threshold
        if !state.isDisplayed && shouldDisplay(frame: frame, scrollBounds: scrollBounds) {
            state.isDisplayed = true
            debugPrint("[SNLazyLoadingManager] Display triggered for: \(adUnitId)")
        }
        
        // Handle unloading
        if unloadingEnabled && state.isDisplayed && shouldUnload(frame: frame, scrollBounds: scrollBounds) {
            state.isFetched = false
            state.isDisplayed = false
            debugPrint("[SNLazyLoadingManager] Unload triggered for: \(adUnitId)")
        }
        
        visibilityStates[adUnitId] = state
        
        // Log visibility changes
        if wasVisible != state.isVisible {
            debugPrint("[SNLazyLoadingManager] Visibility changed for \(adUnitId): \(state.isVisible)")
        }
    }
    
    /// Check if an ad unit should be fetched
    /// - Parameter adUnitId: The ad unit identifier
    /// - Returns: Whether the ad should be fetched
    public func shouldFetchAd(for adUnitId: String) -> Bool {
        return visibilityStates[adUnitId]?.isFetched ?? false
    }
    
    /// Check if an ad unit should be displayed
    /// - Parameter adUnitId: The ad unit identifier
    /// - Returns: Whether the ad should be displayed
    public func shouldDisplayAd(for adUnitId: String) -> Bool {
        return visibilityStates[adUnitId]?.isDisplayed ?? false
    }
    
    // MARK: - Private Methods
    
    private func calculateVisibility(frame: CGRect, scrollBounds: CGRect) -> Bool {
        return frame.intersects(scrollBounds)
    }
    
    private func shouldFetch(frame: CGRect, scrollBounds: CGRect) -> Bool {
        let expandedBounds = scrollBounds.insetBy(dx: 0, dy: -fetchThreshold)
        return frame.intersects(expandedBounds)
    }
    
    private func shouldDisplay(frame: CGRect, scrollBounds: CGRect) -> Bool {
        let expandedBounds = scrollBounds.insetBy(dx: 0, dy: -displayThreshold)
        return frame.intersects(expandedBounds)
    }
    
    private func shouldUnload(frame: CGRect, scrollBounds: CGRect) -> Bool {
        let expandedBounds = scrollBounds.insetBy(dx: 0, dy: -unloadThreshold)
        return !frame.intersects(expandedBounds)
    }
}

// MARK: - SwiftUI Extensions
extension View {
    /// Enable lazy loading for ads in this view hierarchy
    /// - Parameters:
    ///   - fetchThreshold: Distance to start fetching (default: 800pt)
    ///   - displayThreshold: Distance to start displaying (default: 200pt)
    ///   - unloadingEnabled: Whether to unload distant ads (default: false)
    /// - Returns: View with lazy loading enabled
    public func snLazyLoadAds(
        fetchThreshold: CGFloat = 800,
        displayThreshold: CGFloat = 200,
        unloadingEnabled: Bool = false
    ) -> some View {
        let manager = SNLazyLoadingManager.shared
        manager.fetchThreshold = fetchThreshold
        manager.displayThreshold = displayThreshold
        manager.unloadingEnabled = unloadingEnabled
        
        return self.environment(\.snWebAdManager, manager)
    }
}

// MARK: - Debug Helper
private func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let isDebugEnabled = UserDefaults.standard.bool(forKey: "isDebugEnabled")
    if isDebugEnabled {
        print(items, separator: separator, terminator: terminator)
    }
}
