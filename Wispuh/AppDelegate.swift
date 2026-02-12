import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let appState = AppState()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()

        appState.onRecordingStateChanged = { [weak self] isRecording in
            self?.updateMenuBarIcon(isRecording: isRecording)
        }
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "waveform", accessibilityDescription: "Wispuh")
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Wispuh", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())

        let aboutItem = NSMenuItem(title: "About Wispuh", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    private func updateMenuBarIcon(isRecording: Bool) {
        let iconName = isRecording ? "waveform.circle.fill" : "waveform"
        statusItem.button?.image = NSImage(systemSymbolName: iconName, accessibilityDescription: "Wispuh")
    }

    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Wispuh"
        alert.informativeText = """
            Version 0.1.0
            Free, offline speech-to-text for macOS.

            Website: https://www.wispuh.com
            Source: https://github.com/miketalley/wispuh
            """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Visit Website")
        alert.addButton(withTitle: "View Source")

        let response = alert.runModal()
        switch response {
        case .alertSecondButtonReturn:
            NSWorkspace.shared.open(URL(string: "https://www.wispuh.com")!)
        case .alertThirdButtonReturn:
            NSWorkspace.shared.open(URL(string: "https://github.com/miketalley/wispuh")!)
        default:
            break
        }
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
