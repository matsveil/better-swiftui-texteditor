# BetterSwiftUITextEditor

A SwiftUI package that enhances the native `TextEditor` with additional functionality, providing a more flexible and user-friendly text editing experience in your SwiftUI applications.

## Why BetterSwiftUITextEditor?

SwiftUI's built-in `TextEditor` lacks many features developers commonly need. This package addresses those limitations by offering:

- 📝 **Placeholder Support** - Display placeholder text when the editor is empty
- 🔢 **Character Limit & Count** - Limit text length and display remaining characters
- 📏 **Dynamic Height** - Automatically adjusts height based on content
- 📐 **Height Constraints** - Set maximum height with automatic scrolling when content exceeds limit
- 📊 **Line Count Tracking** - Monitor and respond to changes in the number of lines
- ⌨️ **Return Key Handling** - Different actions for Return vs. Shift+Return
- 🎨 **Comprehensive Styling** - Font, padding, colors, and comprehensive UI customization
- 🖥️ **Platform Compatibility** - Works seamlessly on macOS and iOS with platform-specific optimizations

## Installation

### Swift Package Manager

Add BetterSwiftUITextEditor to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/matsveil/better-swiftui-texteditor.git", from: "1.0.5")
]
```

Or add it directly through Xcode:
1. Go to File > Add Packages...
2. Enter the repository URL: `https://github.com/matsveil/better-swiftui-texteditor.git`
3. Follow the prompts to complete installation

## Basic Usage

```swift
import SwiftUI
import BetterSwiftUITextEditor

struct ContentView: View {
    @State private var text = ""
    @State private var numberOfLines = 0
    
    var body: some View {
        BetterEditor(
            text: $text,
            placeholder: "Type something...",
            numberOfLines: $numberOfLines
        )
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
```

## Advanced Examples

### Character Limit with Count Display

```swift
BetterEditor(
    text: $tweetText,
    placeholder: "What's happening?",
    characterLimit: 280,
    showCharacterCount: true
)
.betterEditorCharacterCountLimitExceededColor(.red)
```

### Height Constraints

```swift
BetterEditor(
    text: $longText,
    placeholder: "Type a long message...",
    maxHeight: 120
)
```

### Line Count Tracking

```swift
@State private var numberOfLines = 0

BetterEditor(
    text: $messageText,
    placeholder: "Type a message...",
    numberOfLines: $numberOfLines,
    maxHeight: 100
)
```

### Custom Styling

```swift
BetterEditor(
    text: $customText,
    placeholder: "Express yourself...",
    showCharacterCount: true
)
.font(.custom("Helvetica", size: 16))
.foregroundStyle(Color.indigo)
.betterEditorPlaceholderColor(Color.indigo.opacity(0.5))
.betterEditorCharacterCountColor(Color.indigo.opacity(0.7))
.betterEditorCharacterCountFont(.system(.caption, design: .monospaced))
```

### Return Key Handling for Message Submission

```swift
BetterEditor(
    text: $messageText,
    placeholder: "Type a message..."
)
.betterEditorOnSubmit {
    sendMessage(messageText)
    messageText = ""
}
```

### Multiline Notes Editor

```swift
BetterEditor(
    text: $notesText,
    placeholder: "Write your notes here...\nSupports multiple lines",
    maxHeight: 200
)
.betterEditorTextFont(.body)
```

### Chat Interface with Height Limit

```swift
BetterEditor(
    text: $chatText,
    placeholder: "Type a message...",
    maxHeight: 60
)
.betterEditorOnSubmit {
    sendMessage(chatText)
    chatText = ""
}
```

## Available Modifiers

| Modifier | Description |
|----------|-------------|
| `.betterEditorPlaceholderColor(_:)` | Sets the color for placeholder text |
| `.betterEditorCharacterCountColor(_:)` | Sets the color for the character count display |
| `.betterEditorCharacterCountLimitExceededColor(_:)` | Sets the color for character count when limit exceeded |
| `.betterEditorCharacterCountFont(_:)` | Sets the font for the character count display |
| `.betterEditorTextFont(_:)` | Sets the font specifically for the editor text |
| `.betterEditorOnSubmit(_:)` | Sets a callback to handle return key press |

## Platform-specific Features

- **macOS**: Press Return to submit (triggers onSubmit callback), Shift+Return to insert a newline
- **iOS**: Standard keyboard behavior with automatic height adjustment

## Customization Summary

The `BetterEditor` supports these initialization parameters:

```swift
BetterEditor(
    text: $text,                    // Required: Binding to the text content
    placeholder: "Hint text",       // Optional: Text shown when empty
    characterLimit: 140,            // Optional: Maximum character count
    showCharacterCount: true,       // Optional: Whether to display character count
    numberOfLines: $numberOfLines,  // Optional: Binding to track number of lines
    maxHeight: 120                  // Optional: Maximum height in points
)
```

Additional styling is applied through modifiers as shown in the examples above.

## Requirements

- iOS 16.0+
- macOS 13.0+
- Swift 5.3+
- Xcode 14.0+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available under the MIT License. See the LICENSE file for details.
