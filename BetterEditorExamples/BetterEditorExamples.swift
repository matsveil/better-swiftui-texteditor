#if DEBUG

import SwiftUI
import BetterSwiftUITextEditor

/// A showcase view that demonstrates different configurations and customizations of BetterEditor.
/// This view contains multiple examples illustrating various features of the BetterEditor component,
/// such as basic usage, character limits, custom styling, return key handling, multiline support, and height constraints.
struct BetterEditorExamples: View {
    // MARK: - State Properties
    
    /// Text storage for the basic usage example
    @State private var basicText = ""
    
    /// Text storage for the character limit example
    @State private var characterLimitText = ""
    
    /// Text storage for the custom styling example
    @State private var customStyledText = ""
    
    /// Text storage for the return key handling example
    @State private var returnHandlingText = ""
    
    /// Text storage for the multiline example
    @State private var multilineText = ""
    
    /// Text storage for the line counting example
    @State private var lineCountingText = ""
    
    /// Text storage for the max height example
    @State private var maxHeightText = ""
    
    /// Text storage for the constrained chat example
    @State private var chatText = ""
    
    /// Tracks the number of lines in the line counting example
    @State private var lineCount = 0
    
    /// Controls whether the interface is displayed in dark mode
    @State private var isDarkMode = false
    
    /// Collection of messages submitted via the return key handling example
    @State private var submittedMessages: [String] = []
    
    /// Collection of chat messages for the constrained chat example
    @State private var chatMessages: [String] = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    titleView
                    
                    Group {
                        // Basic example - demonstrates the simplest implementation of BetterEditor
                        sectionHeader("Basic Usage")
                        basicExample
                        
                        // Character limit example - shows how to implement and style character limits
                        sectionHeader("Character Limit & Count")
                        characterLimitExample
                        
                        // Max height example - demonstrates height constraints
                        sectionHeader("Height Constraints")
                        maxHeightExample
                        
                        // Custom styling example - demonstrates visual customizations
                        sectionHeader("Custom Styling")
                        customStylingExample
                        
                        // Return key handling example - shows how to handle Return key presses
                        sectionHeader("Return Key Handling")
                        returnKeyHandlingExample
                        
                        // Multiline example - demonstrates a larger text area for multi-paragraph content
                        sectionHeader("Multiline Notes with Max Height")
                        multilineExample
                        
                        // Line counting example - demonstrates tracking the number of lines
                        sectionHeader("Line Counting")
                        lineCountingExample
                        
                        // Constrained chat example - demonstrates a chat-like interface with height limits
                        sectionHeader("Chat Interface with Height Limit")
                        constrainedChatExample
                    }
                }
                .padding()
            }
            .navigationTitle("BetterEditor Examples")
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    // Toggle for switching between light and dark mode
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Label(
                            isDarkMode ? "Light Mode" : "Dark Mode",
                            systemImage: isDarkMode ? "sun.max.fill" : "moon.fill"
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Section Components
    
    /// Title view for the showcase
    private var titleView: some View {
        Text("BetterEditor Component Showcase")
            .font(.headline)
            .padding(.vertical)
    }
    
    /// Creates a standardized section header with a title and divider
    /// - Parameter title: The title text to display in the header
    /// - Returns: A view containing the formatted section header
    private func sectionHeader(_ title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Divider()
        }
    }
    
    // MARK: - Examples
    
    /// Basic usage example of BetterEditor with minimal configuration.
    /// This example shows the simplest implementation with default styling.
    private var basicExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Simple editor with default styling")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Basic BetterEditor with just text binding and placeholder
            BetterEditor(
                text: $basicText,
                placeholder: "Enter some text..."
            )
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    /// Character limit example showcasing how to restrict input length.
    /// This example demonstrates:
    /// - Setting a maximum character count (140)
    /// - Displaying the current character count
    /// - Styling the character count when limit is exceeded
    private var characterLimitExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("140 character limit with count display")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // BetterEditor configured with character limit and count display
            BetterEditor(
                text: $characterLimitText,
                placeholder: "Tweet your thoughts...",
                characterLimit: 140,
                showCharacterCount: true
            )
            // Customize the color of the character count when limit is exceeded
            .betterEditorCharacterCountLimitExceededColor(.red)
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Button to clear the input text
            Button("Clear") {
                characterLimitText = ""
            }
            .buttonStyle(.bordered)
            .font(.caption)
        }
    }
    
    /// Max height example demonstrating height constraints.
    /// This example shows:
    /// - Setting a maximum height (100 points)
    /// - How the editor becomes scrollable when content exceeds the limit
    /// - Combining max height with character counting
    private var maxHeightExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Editor with 100pt max height - becomes scrollable when content exceeds limit")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // BetterEditor with height constraint
            BetterEditor(
                text: $maxHeightText,
                placeholder: "Type a lot of text to see scrolling behavior...\nKeep typing to exceed the height limit\nThe editor will become scrollable",
                showCharacterCount: true,
                maxHeight: 100
            )
            .betterEditorCharacterCountColor(.blue)
            .padding(12)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
            
            // Buttons to demonstrate the feature
            HStack {
                Button("Add Sample Text") {
                    maxHeightText += "This is a sample line of text that will help demonstrate the scrolling behavior when the content exceeds the maximum height limit.\n"
                }
                .buttonStyle(.bordered)
                .font(.caption)
                
                Button("Clear") {
                    maxHeightText = ""
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
        }
    }
    
    /// Custom styling example showing visual customization options.
    /// This example demonstrates:
    /// - Custom font for text
    /// - Custom text color
    /// - Custom placeholder color
    /// - Custom character count styling
    /// - Custom background and border styling
    private var customStylingExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Custom colors and fonts")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // BetterEditor with extensive styling customizations
            BetterEditor(
                text: $customStyledText,
                placeholder: "Express yourself...",
                showCharacterCount: true,
                maxHeight: 120
            )
            // Core SwiftUI styling
            .font(.custom("Helvetica", size: 16))
            .foregroundStyle(Color.purple)
            // BetterEditor-specific styling modifiers
            .betterEditorPlaceholderColor(Color.purple.opacity(0.5))
            .betterEditorCharacterCountColor(Color.purple.opacity(0.7))
            .betterEditorCharacterCountFont(.system(.caption, design: .monospaced))
            // Container styling
            .padding(12)
            .background(Color.purple.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    /// Return key handling example demonstrating submission functionality.
    /// This example shows:
    /// - Using onSubmit to handle Return key presses
    /// - Collecting submitted messages
    /// - Displaying submission history
    /// - Supporting shift+return for new lines
    private var returnKeyHandlingExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Press Return to submit, Shift+Return for newline")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // BetterEditor configured with submit action
            BetterEditor(
                text: $returnHandlingText,
                placeholder: "Type a message...",
                maxHeight: 80
            )
            // Configure the action to take when user presses Return
            .betterEditorOnSubmit {
                if !returnHandlingText.isEmpty {
                    submittedMessages.append(returnHandlingText)
                    returnHandlingText = ""
                }
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Display submitted messages if any exist
            if !submittedMessages.isEmpty {
                Text("Submitted messages:")
                    .font(.caption)
                    .padding(.top, 8)
                
                // List of submitted messages
                ForEach(submittedMessages, id: \.self) { message in
                    Text(message)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                // Button to clear all submitted messages
                Button("Clear Messages") {
                    submittedMessages.removeAll()
                }
                .buttonStyle(.bordered)
                .font(.caption)
                .padding(.top, 4)
            }
        }
    }
    
    /// Multiline example optimized for longer text content with height constraints.
    /// This example demonstrates:
    /// - Maximum height constraint for multiline content
    /// - Multi-paragraph placeholder text
    /// - Custom font size for better readability
    /// - Scrollable behavior when content exceeds height
    private var multilineExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes editor with 150pt max height - perfect for longer content")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // BetterEditor configured for multiline text entry with height constraint
            BetterEditor(
                text: $multilineText,
                placeholder: "Write your notes here...\nSupports multiple lines\nExpands as you type\nBecomes scrollable when exceeding max height",
                maxHeight: 150
            )
            // Set a specific text font for better readability
            .betterEditorTextFont(.body)
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Helper buttons
            HStack {
                Button("Add Paragraph") {
                    multilineText += "\n\nThis is a new paragraph that demonstrates how the editor handles longer content. When the text exceeds the maximum height, the editor becomes scrollable while maintaining a consistent interface."
                }
                .buttonStyle(.bordered)
                .font(.caption)
                
                Button("Clear") {
                    multilineText = ""
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
        }
    }
    
    /// Line counting example demonstrating how to track the number of lines.
    /// This example shows:
    /// - Using the numberOfLines binding to track line count
    /// - Displaying the current line count
    /// - Visual feedback when line count changes
    private var lineCountingExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Track the number of lines in real-time")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // BetterEditor configured with line counting
            BetterEditor(
                text: $lineCountingText,
                placeholder: "Type multiple lines \nWow, so many lines",
                numberOfLines: $lineCount,
                maxHeight: 120
            )
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Display current line count
            HStack {
                Text("Current line count: \(lineCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Button to clear the text
                Button("Clear") {
                    lineCountingText = ""
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
        }
    }
    
    /// Constrained chat example demonstrating a chat-like interface.
    /// This example shows:
    /// - Chat-style interface with height constraints
    /// - Message submission and display
    /// - Practical use of maxHeight in a real-world scenario
    private var constrainedChatExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Chat interface with 60pt input height limit")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Chat messages display
            if !chatMessages.isEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(chatMessages, id: \.self) { message in
                            HStack {
                                Text(message)
                                    .padding(8)
                                    .background(Color.green.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .frame(maxHeight: 120)
                .background(Color.gray.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Chat input with constrained height
            HStack(alignment: .bottom, spacing: 8) {
                BetterEditor(
                    text: $chatText,
                    placeholder: "Type a message...",
                    maxHeight: 60
                )
                .betterEditorOnSubmit {
                    if !chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        chatMessages.append(chatText)
                        chatText = ""
                    }
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button("Send") {
                    if !chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        chatMessages.append(chatText)
                        chatText = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            if !chatMessages.isEmpty {
                Button("Clear Chat") {
                    chatMessages.removeAll()
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
        }
    }
}

/// SwiftUI preview for the BetterEditorExamples view
#Preview {
    BetterEditorExamples()
}

#endif
