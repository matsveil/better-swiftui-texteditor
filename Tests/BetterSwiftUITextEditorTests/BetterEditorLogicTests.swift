import XCTest
@testable import BetterSwiftUITextEditor

// MARK: - Character Limit
//
// Tests the binding setter that enforces optional character limits.
// The boundary case (exactly at the limit) and multibyte characters
// are the only non-obvious cases here; the rest document intent.

final class CharacterLimitTests: XCTestCase {

    func testNoLimit_passesThrough() {
        XCTAssertEqual(BetterEditorLogic.applyCharacterLimit(to: "hello world", limit: nil), "hello world")
    }

    func testBelowLimit_passesThrough() {
        XCTAssertEqual(BetterEditorLogic.applyCharacterLimit(to: "hi", limit: 10), "hi")
    }

    // Exactly at the limit must NOT truncate — the condition is `count > limit`, not `>=`.
    func testAtLimit_passesThrough() {
        XCTAssertEqual(BetterEditorLogic.applyCharacterLimit(to: "hello", limit: 5), "hello")
    }

    func testOverLimit_truncates() {
        XCTAssertEqual(BetterEditorLogic.applyCharacterLimit(to: "hello world", limit: 5), "hello")
    }

    func testZeroLimit_truncatesEverything() {
        XCTAssertEqual(BetterEditorLogic.applyCharacterLimit(to: "abc", limit: 0), "")
    }

    // Swift's String.count counts Unicode scalars that form a Character, not bytes.
    // A naive byte-length implementation would fail this.
    func testMultibyteCharacters_countsByCharacter() {
        XCTAssertEqual(BetterEditorLogic.applyCharacterLimit(to: "🎉🎊🎈", limit: 2), "🎉🎊")
    }
}

// MARK: - Line Count
//
// Tests the height-division formula that estimates line count from measured view sizes.
// This is the most complex logic in the package: it subtracts platform-specific padding
// before dividing, uses rounding to handle sub-pixel layout, and floors at 1.
// The iOS padding constant (17.667pt) is load-bearing — tests here would catch a
// regression if that value or the formula changes.

final class LineCountTests: XCTestCase {

    // The vertical padding TextEditor injects on iOS (8pt top + 9.667pt bottom).
    // On macOS this is 0, which is why both platforms are tested separately.
    private let iOSPadding: CGFloat = 17.66666666666667

    func testSingleLine() {
        // totalHeight == lineHeight → one line of content
        XCTAssertEqual(
            BetterEditorLogic.calculateLineCount(totalHeight: 50, lineHeight: 50, verticalPadding: iOSPadding),
            1
        )
    }

    func testTwoLines() {
        let lh: CGFloat = 50
        let textLineHeight = lh - iOSPadding
        let totalH = textLineHeight * 2 + iOSPadding
        XCTAssertEqual(
            BetterEditorLogic.calculateLineCount(totalHeight: totalH, lineHeight: lh, verticalPadding: iOSPadding),
            2
        )
    }

    // The result must never go below 1 even if measured heights are inconsistent.
    func testMinimumIsOne_whenContentSmallerThanLineHeight() {
        XCTAssertEqual(
            BetterEditorLogic.calculateLineCount(totalHeight: 10, lineHeight: 50, verticalPadding: iOSPadding),
            1
        )
    }

    // lineHeight arrives via onAppear and starts at 0; the guard prevents a divide-by-zero.
    func testZeroLineHeight_returnsOne() {
        XCTAssertEqual(
            BetterEditorLogic.calculateLineCount(totalHeight: 200, lineHeight: 0, verticalPadding: iOSPadding),
            1
        )
    }

    // Sub-pixel layout means totalHeight is rarely an exact multiple of textLineHeight.
    // Rounding lets a line that is 60% rendered count as the next full line.
    func testRoundsUp_nearNextLine() {
        let lh: CGFloat = 50
        let totalH = (lh - iOSPadding) * 2.6 + iOSPadding
        XCTAssertEqual(
            BetterEditorLogic.calculateLineCount(totalHeight: totalH, lineHeight: lh, verticalPadding: iOSPadding),
            3
        )
    }

    func testRoundsDown_nearPreviousLine() {
        let lh: CGFloat = 50
        let totalH = (lh - iOSPadding) * 2.4 + iOSPadding
        XCTAssertEqual(
            BetterEditorLogic.calculateLineCount(totalHeight: totalH, lineHeight: lh, verticalPadding: iOSPadding),
            2
        )
    }

    // On macOS, TextEditor adds no vertical padding, so the formula simplifies to
    // totalHeight / lineHeight. A wrong platform branch would break this.
    func testMacOS_zeroPadding() {
        let lh: CGFloat = 20
        XCTAssertEqual(
            BetterEditorLogic.calculateLineCount(totalHeight: 60, lineHeight: lh, verticalPadding: 0),
            3
        )
    }
}

// MARK: - Overflow Detection
//
// Tests whether content height exceeds the optional maxHeight cap.
// Only three cases matter: no cap (common default), exactly at the cap
// (documents that the condition is strict `>`, not `>=`), and above the cap.

final class OverflowTests: XCTestCase {

    func testNoMaxHeight_neverOverflows() {
        XCTAssertFalse(BetterEditorLogic.isOverflowing(editorHeight: 99999, maxHeight: nil))
    }

    // Exactly at the cap must NOT overflow — the frame should not switch to scroll mode
    // until content actually exceeds the limit.
    func testAtMaxHeight_notOverflowing() {
        XCTAssertFalse(BetterEditorLogic.isOverflowing(editorHeight: 100, maxHeight: 100))
    }

    func testAboveMaxHeight_isOverflowing() {
        XCTAssertTrue(BetterEditorLogic.isOverflowing(editorHeight: 101, maxHeight: 100))
    }
}
