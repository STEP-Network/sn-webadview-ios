import SwiftUI
import SNWebAdView

@main
struct ExampleApp: App {
    init() {
        // Configure the SDK with your STEP Network credentials
        // Replace these with your actual credentials provided by STEP Network
        SNWebAdSDK.configure(
            didomiAPIKey: "your-didomi-api-key-here",
            baseURL: "https://your-ad-template-url.com",
            disableDidomiRemoteConfig: false,
            debugMode: true  // Enable debug mode for development
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("SNWebAdView SDK Example")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                NavigationView {
                    List {
                        NavigationLink("Basic Ad Examples", destination: BasicAdExamplesView())
                        NavigationLink("Advanced Features", destination: AdvancedFeaturesView())
                        NavigationLink("Lazy Loading Demo", destination: LazyLoadingDemoView())
                        NavigationLink("Performance Test", destination: PerformanceTestView())
                        NavigationLink("Debug Console", destination: DebugConsoleView())
                        NavigationLink("Consent Management", destination: ConsentManagementView())
                    }
                    .navigationTitle("Examples")
                }
                
                Spacer()
                
                // Footer ad
                SNWebAdView(adUnitId: "div-gpt-ad-footer")
                    .customTargeting("position", "footer")
                    .customTargeting("screen", "main")
                    .frame(height: 50)
                    .showAdLabel(true, text: "Advertisement")
                    .background(Color.gray.opacity(0.1))
            }
        }
    }
}

// MARK: - Basic Ad Examples

struct BasicAdExamplesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Basic Ad Display Examples")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                // Simple banner ad
                VStack(alignment: .leading, spacing: 10) {
                    Text("Simple Banner Ad")
                        .font(.headline)
                    Text("Basic ad display with no additional configuration.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-banner-simple")
                        .frame(height: 100)
                        .background(Color.gray.opacity(0.1))
                }
                .padding(.horizontal)
                
                Divider()
                
                // Banner with label
                VStack(alignment: .leading, spacing: 10) {
                    Text("Banner with Advertisement Label")
                        .font(.headline)
                    Text("Ad display with advertisement label for transparency.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-banner-labeled")
                        .frame(height: 120)
                        .showAdLabel(true, text: "Advertisement")
                        .adLabelFont(.system(size: 11, weight: .medium))
                        .background(Color.gray.opacity(0.1))
                }
                .padding(.horizontal)
                
                Divider()
                
                // Responsive ad
                VStack(alignment: .leading, spacing: 10) {
                    Text("Responsive Ad")
                        .font(.headline)
                    Text("Ad that adapts to available space with size constraints.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-responsive")
                        .minWidth(300)
                        .maxWidth(.infinity)
                        .initialHeight(150)
                        .maxHeight(250)
                        .showAdLabel(true, text: "Sponsored Content")
                        .background(Color.gray.opacity(0.1))
                }
                .padding(.horizontal)
                
                Divider()
                
                // Leaderboard ad
                VStack(alignment: .leading, spacing: 10) {
                    Text("Leaderboard Ad")
                        .font(.headline)
                    Text("Wide leaderboard format ad with fixed dimensions.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-leaderboard")
                        .frame(width: 728, height: 90)
                        .frame(maxWidth: .infinity)
                        .showAdLabel(true)
                        .background(Color.gray.opacity(0.1))
                        .clipped()
                }
                .padding(.horizontal)
                
                Spacer(minLength: 50)
            }
        }
        .navigationTitle("Basic Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Advanced Features

struct AdvancedFeaturesView: View {
    @State private var selectedSection = "sports"
    @State private var selectedCategory = "football"
    @State private var isPremiumUser = false
    @State private var userAge = "25-34"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Advanced Targeting Features")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                // Configuration controls
                VStack(alignment: .leading, spacing: 15) {
                    Text("Targeting Configuration")
                        .font(.headline)
                    
                    HStack {
                        Text("Section:")
                        Spacer()
                        Picker("Section", selection: $selectedSection) {
                            Text("Sports").tag("sports")
                            Text("News").tag("news")
                            Text("Entertainment").tag("entertainment")
                            Text("Technology").tag("technology")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Text("Category:")
                        Spacer()
                        Picker("Category", selection: $selectedCategory) {
                            Text("Football").tag("football")
                            Text("Basketball").tag("basketball")
                            Text("Baseball").tag("baseball")
                            Text("Soccer").tag("soccer")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Text("Premium User:")
                        Spacer()
                        Toggle("", isOn: $isPremiumUser)
                    }
                    
                    HStack {
                        Text("Age Group:")
                        Spacer()
                        Picker("Age", selection: $userAge) {
                            Text("18-24").tag("18-24")
                            Text("25-34").tag("25-34")
                            Text("35-44").tag("35-44")
                            Text("45-54").tag("45-54")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Ad with custom targeting
                VStack(alignment: .leading, spacing: 10) {
                    Text("Targeted Ad")
                        .font(.headline)
                    Text("Ad using the targeting parameters configured above.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-targeted")
                        .customTargeting("section", selectedSection)
                        .customTargeting("category", selectedCategory)
                        .customTargeting("premium", isPremiumUser ? "true" : "false")
                        .customTargeting("age_group", userAge)
                        .customTargeting("example_type", "advanced_demo")
                        .frame(height: 180)
                        .showAdLabel(true, text: "Targeted Advertisement")
                        .background(Color.gray.opacity(0.1))
                }
                .padding(.horizontal)
                
                Divider()
                
                // Multi-value targeting
                VStack(alignment: .leading, spacing: 10) {
                    Text("Multi-Value Targeting")
                        .font(.headline)
                    Text("Ad with multiple targeting values for better matching.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-multi-target")
                        .customTargeting("tags", ["sports", "breaking", "featured"])
                        .customTargeting("interests", ["outdoor", "fitness", "competition"])
                        .customTargeting("content_type", "article")
                        .frame(height: 200)
                        .showAdLabel(true, text: "Personalized Ad")
                        .background(Color.gray.opacity(0.1))
                }
                .padding(.horizontal)
                
                Spacer(minLength: 50)
            }
        }
        .navigationTitle("Advanced Features")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Lazy Loading Demo

struct LazyLoadingDemoView: View {
    @State private var articles = generateSampleArticles(count: 50)
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                Text("Lazy Loading Performance Demo")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                ForEach(Array(articles.enumerated()), id: \.offset) { index, article in
                    VStack(spacing: 15) {
                        // Article content
                        VStack(alignment: .leading, spacing: 8) {
                            Text(article.title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            
                            Text(article.summary)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                            
                            HStack {
                                Text(article.category)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                                
                                Spacer()
                                
                                Text("Article \(index + 1)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        
                        // Show ad every 3 articles
                        if (index + 1) % 3 == 0 {
                            SNWebAdView(adUnitId: "div-gpt-ad-feed-\(index)")
                                .customTargeting("position", "feed")
                                .customTargeting("article_index", "\(index)")
                                .customTargeting("category", article.category.lowercased())
                                .frame(height: 150)
                                .showAdLabel(true, text: "Sponsored")
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .snLazyLoadAds(
            fetchThreshold: 800,
            displayThreshold: 200,
            unloadingEnabled: true,
            unloadThreshold: 1200
        )
        .navigationTitle("Lazy Loading")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Performance Test

struct PerformanceTestView: View {
    @State private var adCount = 10
    @State private var unloadingEnabled = true
    @State private var fetchThreshold: Double = 800
    @State private var displayThreshold: Double = 200
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Performance Test Configuration")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                // Configuration controls
                VStack(alignment: .leading, spacing: 15) {
                    Text("Lazy Loading Settings")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Number of Ads: \(adCount)")
                        Slider(value: Binding(
                            get: { Double(adCount) },
                            set: { adCount = Int($0) }
                        ), in: 5...50, step: 5)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fetch Threshold: \(Int(fetchThreshold))pt")
                        Slider(value: $fetchThreshold, in: 200...1500, step: 100)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Display Threshold: \(Int(displayThreshold))pt")
                        Slider(value: $displayThreshold, in: 50...500, step: 50)
                    }
                    
                    Toggle("Enable Unloading", isOn: $unloadingEnabled)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Performance test content
                LazyVStack(spacing: 30) {
                    ForEach(0..<adCount, id: \.self) { index in
                        VStack(spacing: 15) {
                            Text("Content Block \(index + 1)")
                                .font(.title3)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("This is sample content to simulate a real app with multiple content blocks and ads. The lazy loading system should optimize performance by only loading ads when they're needed.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                            
                            SNWebAdView(adUnitId: "div-gpt-ad-performance-\(index)")
                                .customTargeting("test_type", "performance")
                                .customTargeting("ad_index", "\(index)")
                                .customTargeting("total_ads", "\(adCount)")
                                .frame(height: 120)
                                .showAdLabel(true, text: "Test Ad \(index + 1)")
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .snLazyLoadAds(
            fetchThreshold: fetchThreshold,
            displayThreshold: displayThreshold,
            unloadingEnabled: unloadingEnabled,
            unloadThreshold: unloadingEnabled ? 1500 : nil
        )
        .navigationTitle("Performance Test")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Debug Console

struct DebugConsoleView: View {
    @State private var debugEnabled = SNDebugSettings.shared.isDebugEnabled
    @State private var configurationText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Debug Console")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                // Debug controls
                VStack(alignment: .leading, spacing: 15) {
                    Text("Debug Settings")
                        .font(.headline)
                    
                    Toggle("Enable Debug Mode", isOn: $debugEnabled)
                        .onChange(of: debugEnabled) { enabled in
                            if enabled {
                                SNDebugSettings.shared.enableDebugMode()
                            } else {
                                SNDebugSettings.shared.disableDebugMode()
                            }
                        }
                    
                    Button("Print Configuration") {
                        SNDebugSettings.shared.printDebugConfiguration()
                        updateConfigurationText()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Log Test Message") {
                        SNDebugSettings.shared.log("Test debug message from example app")
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Log Warning Message") {
                        SNDebugSettings.shared.logWarning("Test warning from example app")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Configuration display
                if !configurationText.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Configuration")
                            .font(.headline)
                        
                        Text(configurationText)
                            .font(.system(.caption, design: .monospaced))
                            .padding()
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(8)
                    }
                }
                
                // Debug ad
                VStack(alignment: .leading, spacing: 10) {
                    Text("Debug Ad Display")
                        .font(.headline)
                    Text("This ad will use debug targeting parameters.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-debug")
                        .customTargeting("debug_test", "true")
                        .customTargeting("screen", "debug_console")
                        .frame(height: 150)
                        .showAdLabel(true, text: "Debug Advertisement")
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Debug Console")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            updateConfigurationText()
        }
    }
    
    private func updateConfigurationText() {
        // This would be populated by the debug settings
        configurationText = """
            SDK Configuration:
            - Debug Mode: \(SNDebugSettings.shared.isDebugEnabled ? "Enabled" : "Disabled")
            - Base URL: [Configured]
            - Didomi API Key: [Configured]
            - Lazy Loading: Active
            """
    }
}

// MARK: - Consent Management

struct ConsentManagementView: View {
    @State private var consentStatus = "Unknown"
    @State private var hasConsent = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Consent Management Demo")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                // Consent status
                VStack(alignment: .leading, spacing: 15) {
                    Text("Current Consent Status")
                        .font(.headline)
                    
                    HStack {
                        Text("Status:")
                        Spacer()
                        Text(consentStatus)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Has Consent:")
                        Spacer()
                        Text(hasConsent ? "Yes" : "No")
                            .fontWeight(.medium)
                            .foregroundColor(hasConsent ? .green : .red)
                    }
                    
                    Button("Refresh Status") {
                        updateConsentStatus()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Consent actions
                VStack(alignment: .leading, spacing: 15) {
                    Text("Consent Actions")
                        .font(.headline)
                    
                    Button("Show Consent Notice") {
                        SNDidomiWrapper.shared.showConsentNotice()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Show Preferences") {
                        SNDidomiWrapper.shared.showPreferences()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Reset Consent (Testing)") {
                        SNDidomiWrapper.shared.resetConsent()
                        updateConsentStatus()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Consent-aware ad
                VStack(alignment: .leading, spacing: 10) {
                    Text("Consent-Aware Advertisement")
                        .font(.headline)
                    Text("This ad respects user consent preferences.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SNWebAdView(adUnitId: "div-gpt-ad-consent-demo")
                        .customTargeting("consent_demo", "true")
                        .customTargeting("has_consent", hasConsent ? "true" : "false")
                        .frame(height: 150)
                        .showAdLabel(true, text: "Privacy-Compliant Ad")
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Consent Management")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            updateConsentStatus()
        }
    }
    
    private func updateConsentStatus() {
        hasConsent = SNDidomiWrapper.shared.hasConsent()
        consentStatus = SNDidomiWrapper.shared.getConsentStatus()
    }
}

// MARK: - Sample Data

struct SampleArticle {
    let title: String
    let summary: String
    let category: String
}

func generateSampleArticles(count: Int) -> [SampleArticle] {
    let titles = [
        "Breaking: Major Sports Trade Announced",
        "Technology Breakthrough Changes Industry",
        "Entertainment News: Award Winners Revealed",
        "Health Study Shows Surprising Results",
        "Economy Update: Market Trends Analysis",
        "Science Discovery Opens New Possibilities",
        "Politics: New Policy Changes Announced",
        "Travel: Hidden Gems Worth Visiting",
        "Food: Restaurant Industry Innovations",
        "Education: Learning Methods Evolution"
    ]
    
    let summaries = [
        "A comprehensive look at the latest developments in this rapidly evolving story. Industry experts weigh in on the potential implications and what it means for the future.",
        "New research findings suggest a significant shift in how we understand this topic. The study involved thousands of participants and spanned multiple years.",
        "Following extensive analysis and community feedback, officials have announced major changes that will affect millions of people across the region.",
        "This groundbreaking development represents a major milestone in the field. Scientists and researchers around the world are taking notice of the implications."
    ]
    
    let categories = ["Sports", "Technology", "Entertainment", "Health", "Business", "Science", "Politics", "Travel", "Food", "Education"]
    
    return (0..<count).map { index in
        SampleArticle(
            title: titles[index % titles.count] + " \(index + 1)",
            summary: summaries[index % summaries.count],
            category: categories[index % categories.count]
        )
    }
}

#Preview {
    ContentView()
}
