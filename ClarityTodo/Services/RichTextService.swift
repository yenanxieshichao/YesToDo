import AppKit
import SwiftUI

/// Wraps an NSTextView for use in SwiftUI via NSViewRepresentable.
/// Provides rich text editing capabilities including bold, italic, underline,
/// strikethrough, font color, background color, bullet lists, and numbered lists.
struct RichTextEditor: NSViewRepresentable {
    @Binding var attributedString: NSAttributedString
    var isEditable: Bool = true

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = true
        scrollView.backgroundColor = .clear

        let textView = CustomTextView()
        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = true
        textView.importsGraphics = false
        textView.allowsImageEditing = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.usesAdaptiveColorMappingForDarkAppearance = true
        textView.textContainerInset = NSSize(width: 8, height: 8)
        textView.delegate = context.coordinator
        textView.textStorage?.setAttributedString(attributedString)

        // Set default font
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.textColor = .labelColor
        textView.drawsBackground = false

        // Enable undo/redo
        textView.allowsUndo = true

        // Enable bullet lists and numbered lists via NSTextList
        textView.enabledTextCheckingTypes = 0

        scrollView.documentView = textView

        // Set minimum size
        scrollView.minSize = NSSize(width: 0, height: 100)

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.attributedString() != attributedString {
            textView.textStorage?.setAttributedString(attributedString)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.attributedString = textView.attributedString()
        }
    }
}

/// Custom NSTextView with keyboard shortcut handling for rich text formatting
class CustomTextView: NSTextView {
    override func keyDown(with event: NSEvent) {
        // Let standard key bindings process first
        super.keyDown(with: event)
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == .keyDown {
            // Handle formatting shortcuts
            if event.modifierFlags.contains(.command) {
                switch event.charactersIgnoringModifiers?.lowercased() {
                case "b":
                    toggleBold()
                    return true
                case "i":
                    toggleItalic()
                    return true
                case "u":
                    toggleUnderline()
                    return true
                default:
                    break
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }

    // MARK: - Rich Text Formatting Actions

    func toggleBold() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentFont = font ?? NSFont.systemFont(ofSize: 14)
        let isBold = currentFont.fontDescriptor.symbolicTraits.contains(.bold)
        let newFont: NSFont
        if isBold {
            newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: .boldFontMask)
        } else {
            newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .boldFontMask)
        }
        textStorage.addAttribute(.font, value: newFont, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleItalic() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentFont = font ?? NSFont.systemFont(ofSize: 14)
        let isItalic = currentFont.fontDescriptor.symbolicTraits.contains(.italic)
        let newFont: NSFont
        if isItalic {
            newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: .italicFontMask)
        } else {
            newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .italicFontMask)
        }
        textStorage.addAttribute(.font, value: newFont, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleUnderline() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentUnderline = textStorage.attribute(.underlineStyle, at: selectedRange().location, effectiveRange: nil) as? Int ?? 0
        let newValue: Int = currentUnderline == 0 ? NSUnderlineStyle.single.rawValue : 0
        textStorage.addAttribute(.underlineStyle, value: newValue, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleStrikethrough() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentStrike = textStorage.attribute(.strikethroughStyle, at: selectedRange().location, effectiveRange: nil) as? Int ?? 0
        let newValue: Int = currentStrike == 0 ? NSUnderlineStyle.single.rawValue : 0
        textStorage.addAttribute(.strikethroughStyle, value: newValue, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func setFontColor(_ color: NSColor) {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        textStorage.addAttribute(.foregroundColor, value: color, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func setBackgroundColor(_ color: NSColor) {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        textStorage.addAttribute(.backgroundColor, value: color, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func insertBulletList() {
        insertText("• ", replacementRange: selectedRange())
    }

    func insertNumberedList() {
        let paragraphRange = textStorage?.mutableString.paragraphRange(for: selectedRange()) ?? selectedRange()
        let lineNumber = textStorage?.mutableString
            .substring(with: NSRange(location: 0, length: paragraphRange.location))
            .components(separatedBy: "\n").count ?? 1
        insertText("\(lineNumber). ", replacementRange: selectedRange())
    }

    /// Convert attributed text to RTF data for persistence
    func attributedStringToData() -> Data? {
        guard let textStorage = textStorage else { return nil }
        let range = NSRange(location: 0, length: textStorage.length)
        let data = textStorage.rtf(from: range)
        return data
    }

    /// Load attributed text from RTF data
    func loadFromData(_ data: Data) {
        guard let textStorage = textStorage else { return }
        do {
            let attrString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            textStorage.setAttributedString(attrString)
        } catch {
            print("Failed to load RTF data: \(error)")
        }
    }
}
