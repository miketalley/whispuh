import AppKit
import Foundation

final class TextPaster {
    private var previousApp: NSRunningApplication?

    func captureCurrentApp() {
        previousApp = NSWorkspace.shared.frontmostApplication
        print("[Wispuh] Captured frontmost app: \(previousApp?.localizedName ?? "none")")
    }

    func paste(text: String) {
        guard !text.isEmpty else {
            print("[Wispuh] Nothing to paste — empty transcription")
            return
        }

        let pasteboard = NSPasteboard.general
        let originalContents = pasteboard.pasteboardItems?.compactMap { item -> [NSPasteboard.PasteboardType: Data]? in
            var dict = [NSPasteboard.PasteboardType: Data]()
            for type in item.types {
                if let data = item.data(forType: type) {
                    dict[type] = data
                }
            }
            return dict.isEmpty ? nil : dict
        } ?? []

        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        if let previousApp {
            previousApp.activate()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.simulateCmdV()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.restoreClipboard(originalContents, pasteboard: pasteboard)
            }
        }
    }

    private func simulateCmdV() {
        let source = CGEventSource(stateID: .hidSystemState)

        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
        keyDown?.flags = .maskCommand
        keyDown?.post(tap: .cghidEventTap)

        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        keyUp?.flags = .maskCommand
        keyUp?.post(tap: .cghidEventTap)

        print("[Wispuh] Simulated Cmd+V")
    }

    private func restoreClipboard(_ contents: [[NSPasteboard.PasteboardType: Data]], pasteboard: NSPasteboard) {
        guard !contents.isEmpty else { return }

        pasteboard.clearContents()
        for itemDict in contents {
            let item = NSPasteboardItem()
            for (type, data) in itemDict {
                item.setData(data, forType: type)
            }
            pasteboard.writeObjects([item])
        }
        print("[Wispuh] Clipboard restored")
    }
}
