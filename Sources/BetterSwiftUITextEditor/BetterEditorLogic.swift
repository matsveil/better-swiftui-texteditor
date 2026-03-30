// BetterEditorLogic.swift
//
// Internal pure functions extracted from BetterEditor.
// Keeping them free of SwiftUI/AppKit dependencies makes them fast to unit test.

import CoreGraphics

enum BetterEditorLogic {

    /// Applies an optional character limit to a string.
    /// Returns the original string unchanged, or truncated to `limit` characters if exceeded.
    static func applyCharacterLimit(to text: String, limit: Int?) -> String {
        guard let limit, text.count > limit else { return text }
        return String(text.prefix(limit))
    }

    /// Calculates the number of visible text lines from measured heights.
    ///
    /// Both `totalHeight` and `lineHeight` include the platform-specific vertical padding
    /// that `TextEditor` injects around its content. `verticalPadding` is subtracted before
    /// the division so the result reflects actual line count, not padded pixel rows.
    ///
    /// Returns at least 1 and handles degenerate inputs (zero heights) safely.
    static func calculateLineCount(
        totalHeight: CGFloat,
        lineHeight: CGFloat,
        verticalPadding: CGFloat
    ) -> Int {
        guard lineHeight > 0 else { return 1 }
        let textLineHeight = lineHeight - verticalPadding
        guard textLineHeight > 0 else { return 1 }
        let contentHeight = max(0, totalHeight - verticalPadding)
        return max(1, Int(round(contentHeight / textLineHeight)))
    }

    /// The effective editor height: whichever is larger, the content or a single line.
    static func editorHeight(totalHeight: CGFloat, lineHeight: CGFloat) -> CGFloat {
        max(totalHeight, lineHeight)
    }

    /// Whether the content height exceeds the caller-supplied cap.
    /// Returns `false` when no cap is set (nil).
    static func isOverflowing(editorHeight: CGFloat, maxHeight: CGFloat?) -> Bool {
        guard let maxHeight else { return false }
        return editorHeight > maxHeight
    }
}
