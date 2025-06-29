//
//  BetterEditor.swift
//  Snippy
//
//  Created by Matsvei Liapich on 5/16/25.
//

import SwiftUI

#if os(macOS)
import AppKit
#endif

// MARK: - Environment Keys

struct BetterEditorPlaceholderColorKey: EnvironmentKey {
    static let defaultValue: Color = .gray.opacity(0.7)
}

struct BetterEditorTextFontKey: EnvironmentKey {
    static let defaultValue: Font? = .body
}

struct BetterEditorCharacterCountColorKey: EnvironmentKey {
    static let defaultValue: Color = .secondary
}

struct BetterEditorCharacterCountLimitExceededColorKey: EnvironmentKey {
    static let defaultValue: Color = .red
}

struct BetterEditorCharacterCountFontKey: EnvironmentKey {
    static let defaultValue: Font = .caption
}

struct BetterEditorOnSubmitKey: EnvironmentKey {
    static let defaultValue: (@MainActor () -> Void)? = nil
}

struct BetterEditorScrollIndicatorsKey: EnvironmentKey {
    static let defaultValue: Visibility = .automatic
}

// MARK: - Environment Value Extensions

public extension EnvironmentValues {
    var betterEditorPlaceholderColor: Color {
        get { self[BetterEditorPlaceholderColorKey.self] }
        set { self[BetterEditorPlaceholderColorKey.self] = newValue }
    }
    
    var betterEditorTextFont: Font? {
        get { self[BetterEditorTextFontKey.self] }
        set { self[BetterEditorTextFontKey.self] = newValue }
    }
    
    var betterEditorCharacterCountColor: Color {
        get { self[BetterEditorCharacterCountColorKey.self] }
        set { self[BetterEditorCharacterCountColorKey.self] = newValue }
    }
    
    var betterEditorCharacterCountLimitExceededColor: Color {
        get { self[BetterEditorCharacterCountLimitExceededColorKey.self] }
        set { self[BetterEditorCharacterCountLimitExceededColorKey.self] = newValue }
    }
    
    var betterEditorCharacterCountFont: Font {
        get { self[BetterEditorCharacterCountFontKey.self] }
        set { self[BetterEditorCharacterCountFontKey.self] = newValue }
    }
    
    var betterEditorOnSubmit: (@MainActor () -> Void)? {
        get { self[BetterEditorOnSubmitKey.self] }
        set { self[BetterEditorOnSubmitKey.self] = newValue }
    }
    
    var betterEditorScrollIndicators: Visibility {
        get { self[BetterEditorScrollIndicatorsKey.self] }
        set { self[BetterEditorScrollIndicatorsKey.self] = newValue }
    }
}

// MARK: - View Modifiers

public extension View {
    /// Sets the color of the placeholder text in BetterEditor
    func betterEditorPlaceholderColor(_ color: Color) -> some View {
        environment(\.betterEditorPlaceholderColor, color)
    }
    
    /// Sets the font of the text in BetterEditor
    func betterEditorTextFont(_ font: Font) -> some View {
        environment(\.betterEditorTextFont, font)
    }
    
    /// Sets the color of the character count text in BetterEditor
    func betterEditorCharacterCountColor(_ color: Color) -> some View {
        environment(\.betterEditorCharacterCountColor, color)
    }
    
    /// Sets the color of the character count text when limit is exceeded in BetterEditor
    func betterEditorCharacterCountLimitExceededColor(_ color: Color) -> some View {
        environment(\.betterEditorCharacterCountLimitExceededColor, color)
    }
    
    /// Sets the font of the character count text in BetterEditor
    func betterEditorCharacterCountFont(_ font: Font) -> some View {
        environment(\.betterEditorCharacterCountFont, font)
    }
    
    /// Sets the action to perform when the Return key is pressed without modifiers
    func betterEditorOnSubmit(_ action: @escaping @MainActor () -> Void) -> some View {
        environment(\.betterEditorOnSubmit, action)
    }
    
    /// Sets the visibility of scroll indicators in BetterEditor
    func betterEditorScrollIndicators(_ visibility: Visibility) -> some View {
        environment(\.betterEditorScrollIndicators, visibility)
    }
}

// MARK: - Extensions

private extension Optional where Wrapped == Color {
    func resolve(with defaultColor: Color) -> Color {
        return self ?? defaultColor
    }
}

/// A custom SwiftUI text editor with enhanced features like placeholder support,
/// custom styling, and custom return key handling.
///
/// `BetterEditor` addresses common limitations of SwiftUI's built-in `TextEditor` by providing:
/// - Placeholder text when empty
/// - Automatic height adjustment based on content
/// - Custom return key handling (submit on Return, newline on Shift+Return)
public struct BetterEditor: View {
    // MARK: - Properties
    
    /// The text binding that connects to the parent view's state
    @Binding private var text: String
    
    /// Text displayed when the editor is empty
    private let placeholder: String
    
    /// Optional maximum character count limit
    private let characterLimit: Int?
    
    /// Whether to show the character count below the editor
    private let showCharacterCount: Bool
    
    /// Binding to track the number of lines
    private let numberOfLines: Binding<Int>?
    
    /// Optional maximum height for the editor
    private let maxHeight: CGFloat?
    
    /// Tracks the calculated line height for proper sizing
    @State private var lineHeight: CGFloat = 0
    
    /// Tracks the total height of the text content
    @State private var totalHeight: CGFloat = 0
    
    /// Tracks whether the editor currently has focus
    @FocusState private var isFocused: Bool
    
    /// Environment values for styling
    @Environment(\.font) private var font
    @Environment(\.betterEditorPlaceholderColor) private var placeholderColor
    @Environment(\.betterEditorTextFont) private var textFont
    @Environment(\.betterEditorCharacterCountColor) private var characterCountColor
    @Environment(\.betterEditorCharacterCountLimitExceededColor) private var characterCountLimitExceededColor
    @Environment(\.betterEditorCharacterCountFont) private var characterCountFont
    @Environment(\.betterEditorOnSubmit) private var onSubmit
    @Environment(\.betterEditorScrollIndicators) private var scrollIndicators
    
    // MARK: - Initialization
    
    /// Creates a new BetterEditor with customizable properties
    /// - Parameters:
    ///   - text: Binding to the string value being edited
    ///   - placeholder: Text to display when the editor is empty
    ///   - characterLimit: Optional maximum number of characters allowed (default: nil)
    ///   - showCharacterCount: Whether to display character count (default: false)
    ///   - numberOfLines: Optional binding to track the number of lines (default: nil)
    ///   - maxHeight: Optional maximum height in points; editor becomes scrollable when content exceeds this limit (default: nil)
    ///
    /// To customize appearance, use the following modifiers:
    /// - `.font(_:)` - Sets the text font
    /// - `.foregroundStyle(_:)` or `.foregroundColor(_:)` - Sets the text color
    /// - `.betterEditorPlaceholderColor(_:)` - Sets the placeholder color
    /// - `.betterEditorCharacterCountColor(_:)` - Sets the character count color
    /// - `.betterEditorCharacterCountLimitExceededColor(_:)` - Sets the color when limit is exceeded
    /// - `.betterEditorCharacterCountFont(_:)` - Sets the character count font
    /// - `.betterEditorOnSubmit(_:)` - Sets the action to perform when Return is pressed
    /// - `.betterEditorScrollIndicators(_:)` - Sets the visibility of scroll indicators
    public init(
        text: Binding<String>,
        placeholder: String,
        characterLimit: Int? = nil,
        showCharacterCount: Bool = false,
        numberOfLines: Binding<Int>? = nil,
        maxHeight: CGFloat? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
        self.showCharacterCount = showCharacterCount
        self.numberOfLines = numberOfLines
        self.maxHeight = maxHeight
    }
    
    // MARK: - Body
    
    public var body: some View {
        let finalFont = textFont ?? font ?? .body
        
        return VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .topLeading) {
                
                if #available(iOS 18.0, macOS 15.0, *) {
                    // Main text editor
                    TextEditor(text: Binding(
                        get: { text },
                        set: { newValue in
                            // Apply character limit if specified
                            if let limit = characterLimit, newValue.count > limit {
                                text = String(newValue.prefix(limit))
                            } else {
                                text = newValue
                            }
                        }
                    ))
                    .writingToolsBehavior(.complete)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(scrollIndicators)
                    .frame(minHeight: lineHeight)
                    .frame(maxHeight: maxHeight)
                    .fixedSize(horizontal: false, vertical: true) // Auto-expand vertically
                    .focused($isFocused)
                    .font(finalFont)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    updateHeights(to: geometry.size.height)
                                }
                                .onChange(of: geometry.size.height) { newHeight in
                                    updateHeights(to: newHeight)
                                }
                        }
                    )
#if os(macOS)
                    // Custom key handler for macOS to handle Return key events
                    .background(
                        MacOSKeyHandler(isFocused: isFocused)
                    )
#endif
                } else {
                    // Main text editor
                    TextEditor(text: Binding(
                        get: { text },
                        set: { newValue in
                            // Apply character limit if specified
                            if let limit = characterLimit, newValue.count > limit {
                                text = String(newValue.prefix(limit))
                            } else {
                                text = newValue
                            }
                        }
                    ))
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(scrollIndicators)
                    .frame(minHeight: lineHeight)
                    .frame(maxHeight: maxHeight)
                    .fixedSize(horizontal: false, vertical: true) // Auto-expand vertically
                    .focused($isFocused)
                    .font(finalFont)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    updateHeights(to: geometry.size.height)
                                }
                                .onChange(of: geometry.size.height) { newHeight in
                                    updateHeights(to: newHeight)
                                }
                        }
                    )
#if os(macOS)
                    // Custom key handler for macOS to handle Return key events
                    .background(
                        MacOSKeyHandler(isFocused: isFocused)
                    )
#endif
                }
                
                // Placeholder text shown when editor is empty
                if text.isEmpty {
                    ZStack {
                        // Hidden single line for height calculation
                        Text("A") // Single character to measure line height
                            .font(finalFont)
                            .padding(.leading, 5)
                            .padding(.top, {
#if os(iOS)
                                return 8 // Additional padding for iOS
#else
                                return 0
#endif
                            }())
                            .padding(.bottom, {
#if os(iOS)
                                return 9.66666666666667 // Additional padding for iOS
#else
                                return 0
#endif
                            }())
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            DispatchQueue.main.async {
                                                lineHeight = geometry.size.height
                                            }
                                        }
                                }
                            )
                            .hidden() // Hide the measurement view
                        
                        // Actual placeholder text
                        Text(placeholder)
                            .foregroundColor(placeholderColor)
                            .font(finalFont)
                            .padding(.leading, 5)
                            .padding(.top, {
#if os(iOS)
                                return 8 // Additional padding for iOS
#else
                                return 0
#endif
                            }())
                            .padding(.bottom, {
#if os(iOS)
                                return 9.66666666666667 // Additional padding for iOS
#else
                                return 0
#endif
                            }())
                    }
                    .allowsHitTesting(false) // Prevent interaction with placeholder
                }
            }
            
            // Character count display
            if showCharacterCount {
                HStack {
                    if let limit = characterLimit {
                        Text("\(text.count)/\(limit)")
                            .font(characterCountFont)
                            .foregroundColor(text.count > limit ?
                                             characterCountLimitExceededColor :
                                                characterCountColor)
                    } else {
                        Text("\(text.count) characters")
                            .font(characterCountFont)
                            .foregroundColor(characterCountColor)
                    }
                    Spacer()
                }
                .padding(.horizontal, 5)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateHeights(to height: CGFloat) {
        totalHeight = height
        guard lineHeight > 0 else { return }
        
        // 1️⃣ Compute the static padding you added around each line:
        let paddingTotal: CGFloat = {
#if os(iOS)
            return 17.66666666666667 // 8 + 9.6667
#else
            return 0
#endif
        }()
        
        // 2️⃣ The true text-only line height:
        let textLineHeight = lineHeight - paddingTotal
        
        // 3️⃣ Remove padding from the total, then floor the division:
        let contentHeight = max(0, totalHeight - paddingTotal)
        let lines = max(1, Int(contentHeight / textLineHeight))
        
        numberOfLines?.wrappedValue = lines
    }
}

#if os(macOS)
import AppKit

/// Custom NSViewRepresentable that intercepts keyboard events on macOS
/// to handle the Return key specially (submit on Return, newline on Shift+Return)
struct MacOSKeyHandler: NSViewRepresentable {
    /// Whether the parent editor has focus
    let isFocused: Bool
    
    /// Callback to invoke when Return is pressed without modifier keys
    @Environment(\.betterEditorOnSubmit) private var onSubmit
    
    /// Custom NSView subclass that monitors keyboard events
    class KeyHandlerView: NSView {
        /// Callback when Return is pressed
        var onSubmit: (@MainActor () -> Void)?
        
        /// Whether the parent editor has focus
        var isFocused: Bool = false
        
        /// Event monitor reference for keyboard events
        var monitor: Any? = nil
        
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            
            // Setup or tear down the monitor based on window presence
            if window != nil {
                setupMonitor()
            } else {
                removeMonitor()
            }
        }
        
        /// Sets up the keyboard event monitor
        func setupMonitor() {
            removeMonitor() // Remove existing monitor if any
            
            monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
                guard let self = self, self.isFocused else { return event }
                
                // Check if it's the Return key (keyCode 36)
                if event.keyCode == 36 {
                    // If Shift is held, allow default behavior (insert newline)
                    if event.modifierFlags.contains(.shift) {
                        return event
                    } else {
                        // Trigger submit action and consume the event
                        if let onSubmit = self.onSubmit {
                            Task { @MainActor in
                                onSubmit()
                            }
                        }
                        return nil
                    }
                }
                return event
            }
        }
        
        /// Removes the keyboard event monitor
        func removeMonitor() {
            if let existingMonitor = monitor {
                NSEvent.removeMonitor(existingMonitor)
                monitor = nil
            }
        }
        
        deinit {
            // Monitor is removed in viewDidMoveToWindow when window becomes nil
        }
    }
    
    /// Creates the NSView instance for this representable
    func makeNSView(context: Context) -> KeyHandlerView {
        let view = KeyHandlerView()
        view.onSubmit = onSubmit
        view.isFocused = isFocused
        return view
    }
    
    /// Updates the NSView when SwiftUI state changes
    func updateNSView(_ nsView: KeyHandlerView, context: Context) {
        nsView.onSubmit = onSubmit
        nsView.isFocused = isFocused
    }
    
    /// Cleans up resources when the view is removed
    static func dismantleNSView(_ nsView: KeyHandlerView, coordinator: ()) {
        nsView.removeMonitor()
    }
}
#endif

#if DEBUG
struct ContentView: View {
    @State private var text = ""
    @State private var numberOfLines = 0
    var body: some View {
        VStack {
            VStack {
                BetterEditor(text: $text, placeholder: "Placeholder", numberOfLines: $numberOfLines, maxHeight: 400)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1))
            }
            .padding()
            
            Text("Lines: \(numberOfLines)")
            
            Spacer()
            
        }
    }
}

#Preview {
    ContentView()
        .frame(height: 800)
}
#endif
