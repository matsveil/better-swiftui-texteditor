import SwiftUI

/// A showcase view that demonstrates different configurations and customizations of BetterEditor.
/// This view contains multiple examples illustrating various features of the BetterEditor component,
/// such as basic usage, character limits, custom styling, return key handling, and multiline support.
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
    
    /// Controls whether the interface is displayed in dark mode
    @State private var isDarkMode = false
    
    /// Collection of messages submitted via the return key handling example
    @State private var submittedMessages: [String] = []
    
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
                        
                        // Custom styling example - demonstrates visual customizations
                        sectionHeader("Custom Styling")
                        customStylingExample
                        
                        // Return key handling example - shows how to handle Return key presses
                        sectionHeader("Return Key Handling")
                        returnKeyHandlingExample
                        
                        // Multiline example - demonstrates a larger text area for multi-paragraph content
                        sectionHeader("Multiline Notes")
                        multilineExample
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
                showCharacterCount: true
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
                placeholder: "Type a message..."
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
    
    /// Multiline example optimized for longer text content.
    /// This example demonstrates:
    /// - Larger frame height for multiline content
    /// - Multi-paragraph placeholder text
    /// - Custom font size for better readability
    private var multilineExample: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Designed for longer text content")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // BetterEditor configured for multiline text entry
            BetterEditor(
                text: $multilineText,
                placeholder: "Write your notes here...\nSupports multiple lines\nExpands as you type"
            )
            // Set a specific text font for better readability
            .betterEditorTextFont(.body)
            // Set minimum height to accommodate multiple lines
            .frame(minHeight: 120)
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

/// SwiftUI preview for the BetterEditorExamples view
#Preview {
    BetterEditorExamples()
} 
