import SwiftUI
import WebKit
import Combine
import Didomi

// MARK: - Debug Helper
private func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let isDebugEnabled = UserDefaults.standard.bool(forKey: "isDebugEnabled")
    if isDebugEnabled {
        print(items, separator: separator, terminator: terminator)
    }
}

// MARK: - Ad Load State
public enum AdLoadState: String, CaseIterable, Equatable, Identifiable {
    case idle = "idle"
    case loading = "loading" 
    case loaded = "loaded"
    case error = "error"
    
    public var id: String { rawValue }
}

// MARK: - Environment Key for Lazy Loading Manager
struct AdVisibilityManagerKey: EnvironmentKey {
    static let defaultValue: SNLazyLoadingManager? = nil
}

extension EnvironmentValues {
    var snWebAdManager: SNLazyLoadingManager? {
        get { self[AdVisibilityManagerKey.self] }
        set { self[AdVisibilityManagerKey.self] = newValue }
    }
}

// MARK: - Helper for Publishers
extension Publisher {
    func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Output>) -> (Root) -> AnyCancellable {
        return { object in
            self.sink(receiveCompletion: { _ in },
                     receiveValue: { [weak object] value in
                object?[keyPath: keyPath] = value
            })
        }
    }
}

// MARK: - Preference Keys for Geometry Tracking
struct AdFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct ScrollViewBoundsPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// MARK: - SNWebAdView
/// Main SwiftUI component for displaying web-based ads with automatic sizing and consent management
public struct SNWebAdView: View {
    
    // MARK: - Public Properties
    private let adUnitId: String
    
    // MARK: - Private Properties  
    @State private var loadState: AdLoadState = .idle
    @State private var webView: WKWebView?
    @State private var currentSize: CGSize = .zero
    @State private var customTargetingParams: [String: [String]] = [:]
    @State private var showLabel: Bool = false
    @State private var labelText: String = "annonce"
    @State private var labelFont: Font = .caption
    
    // Size constraints
    @State private var initialWidth: CGFloat?
    @State private var initialHeight: CGFloat?
    @State private var minWidth: CGFloat?
    @State private var maxWidth: CGFloat?
    @State private var minHeight: CGFloat?
    @State private var maxHeight: CGFloat?
    
    // Environment
    @Environment(\.snWebAdManager) private var lazyLoadingManager
    
    // MARK: - Initializer
    
    /// Create a new SNWebAdView with the specified ad unit ID
    /// - Parameter adUnitId: The ad unit identifier provided by STEP Network
    public init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(spacing: 4) {
            if showLabel {
                HStack {
                    Text(labelText)
                        .font(labelFont)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    Spacer()
                }
            }
            
            WebAdViewRepresentable(
                adUnitId: adUnitId,
                baseURL: SNWebAdSDK.getBaseURL(),
                customTargetingParams: customTargetingParams,
                loadState: $loadState,
                currentSize: $currentSize,
                webView: $webView
            )
            .frame(
                width: calculateWidth(),
                height: calculateHeight()
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DidomiConsentChanged"))) { _ in
            reloadAd()
        }
        .onAppear {
            debugPrint("[SNWebAdView] WebAdView appeared for ad unit: \(adUnitId)")
        }
    }
    
    // MARK: - Private Methods
    
    private func calculateWidth() -> CGFloat? {
        if let width = initialWidth {
            return width
        }
        
        if let min = minWidth, let max = maxWidth {
            return min == max ? min : nil
        }
        
        return minWidth
    }
    
    private func calculateHeight() -> CGFloat? {
        if let height = initialHeight {
            return height
        }
        
        if let min = minHeight, let max = maxHeight {
            return min == max ? min : nil
        }
        
        return minHeight
    }
    
    private func reloadAd() {
        debugPrint("[SNWebAdView] Reloading ad due to consent change")
        webView?.reload()
    }
}

// MARK: - SNWebAdView Modifiers
extension SNWebAdView {
    
    /// Add custom targeting parameter with single value
    /// - Parameters:
    ///   - key: Targeting parameter key (must be configured in Google Ad Manager)
    ///   - value: Targeting parameter value
    /// - Returns: Modified SNWebAdView
    public func customTargeting(_ key: String, _ value: String) -> SNWebAdView {
        var copy = self
        copy.customTargetingParams[key] = [value]
        return copy
    }
    
    /// Add custom targeting parameter with multiple values
    /// - Parameters:
    ///   - key: Targeting parameter key (must be configured in Google Ad Manager)
    ///   - values: Array of targeting parameter values
    /// - Returns: Modified SNWebAdView
    public func customTargeting(_ key: String, _ values: [String]) -> SNWebAdView {
        var copy = self
        copy.customTargetingParams[key] = values
        return copy
    }
    
    /// Show advertisement label above the ad
    /// - Parameters:
    ///   - show: Whether to show the label
    ///   - text: Label text (default: "annonce")
    /// - Returns: Modified SNWebAdView
    public func showAdLabel(_ show: Bool = true, text: String = "annonce") -> SNWebAdView {
        var copy = self
        copy.showLabel = show
        copy.labelText = text
        return copy
    }
    
    /// Set advertisement label font
    /// - Parameter font: Font for the advertisement label
    /// - Returns: Modified SNWebAdView
    public func adLabelFont(_ font: Font) -> SNWebAdView {
        var copy = self
        copy.labelFont = font
        return copy
    }
    
    /// Set initial width for the container
    /// - Parameter width: Initial width in points
    /// - Returns: Modified SNWebAdView
    public func initialWidth(_ width: CGFloat) -> SNWebAdView {
        var copy = self
        copy.initialWidth = width
        return copy
    }
    
    /// Set initial height for the container
    /// - Parameter height: Initial height in points
    /// - Returns: Modified SNWebAdView
    public func initialHeight(_ height: CGFloat) -> SNWebAdView {
        var copy = self
        copy.initialHeight = height
        return copy
    }
    
    /// Set minimum width constraint for the container
    /// - Parameter width: Minimum width in points
    /// - Returns: Modified SNWebAdView
    public func minWidth(_ width: CGFloat) -> SNWebAdView {
        var copy = self
        copy.minWidth = width
        return copy
    }
    
    /// Set maximum width constraint for the container
    /// - Parameter width: Maximum width in points
    /// - Returns: Modified SNWebAdView
    public func maxWidth(_ width: CGFloat) -> SNWebAdView {
        var copy = self
        copy.maxWidth = width
        return copy
    }
    
    /// Set minimum height constraint for the container
    /// - Parameter height: Minimum height in points
    /// - Returns: Modified SNWebAdView
    public func minHeight(_ height: CGFloat) -> SNWebAdView {
        var copy = self
        copy.minHeight = height
        return copy
    }
    
    /// Set maximum height constraint for the container
    /// - Parameter height: Maximum height in points
    /// - Returns: Modified SNWebAdView
    public func maxHeight(_ height: CGFloat) -> SNWebAdView {
        var copy = self
        copy.maxHeight = height
        return copy
    }
}

// MARK: - WebAdViewRepresentable
private struct WebAdViewRepresentable: UIViewRepresentable {
    let adUnitId: String
    let baseURL: String
    let customTargetingParams: [String: [String]]
    
    @Binding var loadState: AdLoadState
    @Binding var currentSize: CGSize
    @Binding var webView: WKWebView?
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        
        self.webView = webView
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        loadAd(in: webView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func loadAd(in webView: WKWebView) {
        guard SNWebAdSDK.isConfigurationValid else {
            debugPrint("[SNWebAdView] SDK not configured. Call SNWebAdSDK.configure() first.")
            return
        }
        
        loadState = .loading
        
        // Get Didomi consent data
        let didomiJavaScript = Didomi.shared.getJavaScriptForWebView()
        
        // Build targeting parameters
        var targetingString = ""
        for (key, values) in customTargetingParams {
            let valuesString = values.map { "'\($0)'" }.joined(separator: ", ")
            targetingString += "googletag.pubads().setTargeting('\(key)', [\(valuesString)]);\n"
        }
        
        // Add debug targeting if in debug mode
        if SNWebAdSDK.debugMode {
            targetingString += "googletag.pubads().setTargeting('yb_target', ['alwayson-standard']);\n"
        }
        
        // Build the complete URL with parameters
        let fullURL = "\(baseURL)&adUnitId=\(adUnitId)&targeting=\(targetingString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&didomiJS=\(didomiJavaScript.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        if let url = URL(string: fullURL) {
            let request = URLRequest(url: url)
            webView.load(request)
            debugPrint("[SNWebAdView] Loading ad: \(adUnitId)")
        } else {
            loadState = .error
            debugPrint("[SNWebAdView] Invalid URL for ad unit: \(adUnitId)")
        }
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebAdViewRepresentable
        
        init(_ parent: WebAdViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.loadState = .loaded
            debugPrint("[SNWebAdView] Ad loaded successfully: \(parent.adUnitId)")
            
            // Get content size
            webView.evaluateJavaScript("document.body.scrollHeight") { result, _ in
                if let height = result as? CGFloat {
                    DispatchQueue.main.async {
                        self.parent.currentSize.height = height
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadState = .error
            debugPrint("[SNWebAdView] Ad failed to load: \(error.localizedDescription)")
        }
    }
}
