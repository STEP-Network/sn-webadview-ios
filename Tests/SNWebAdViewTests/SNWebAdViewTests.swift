import XCTest
@testable import SNWebAdView

final class SNWebAdViewTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Reset SDK configuration before each test
        SNWebAdSDK.configure(
            didomiAPIKey: "test-api-key",
            baseURL: "https://test-template.com",
            debugMode: true
        )
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
    }
    
    func testSDKConfiguration() throws {
        // Test that SDK can be configured
        XCTAssertTrue(SNWebAdSDK.isConfigurationValid)
    }
    
    func testWebAdViewCreation() throws {
        // Test that WebAdView can be created
        let adView = SNWebAdView(adUnitId: "test-ad-unit")
        XCTAssertNotNil(adView)
    }
    
    func testCustomTargeting() throws {
        // Test custom targeting functionality
        let adView = SNWebAdView(adUnitId: "test-ad-unit")
            .customTargeting("section", "sports")
            .customTargeting("tags", ["news", "breaking"])
        
        XCTAssertNotNil(adView)
    }
    
    func testLazyLoadingManager() throws {
        // Test lazy loading manager initialization
        let manager = SNLazyLoadingManager.shared
        XCTAssertNotNil(manager)
        XCTAssertEqual(manager.fetchThreshold, 800)
        XCTAssertEqual(manager.displayThreshold, 200)
        XCTAssertFalse(manager.unloadingEnabled)
    }
    
    func testDebugSettings() throws {
        // Test debug settings functionality
        let debugSettings = SNDebugSettings.shared
        XCTAssertNotNil(debugSettings)
        
        debugSettings.enableDebugMode()
        XCTAssertTrue(debugSettings.isDebugEnabled)
        
        debugSettings.disableDebugMode()
        XCTAssertFalse(debugSettings.isDebugEnabled)
    }
    
    func testDidomiWrapper() throws {
        // Test Didomi wrapper functionality
        let wrapper = SNDidomiWrapper.shared
        XCTAssertNotNil(wrapper)
        
        // Test that JavaScript generation doesn't crash
        let javascript = wrapper.getJavaScriptForWebView()
        XCTAssertNotNil(javascript)
    }
}
