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
            button.image = NSImage(systemSymbolName: "waveform", accessibilityDescription: "Whispah")
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Whispah", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    private func updateMenuBarIcon(isRecording: Bool) {
        let iconName = isRecording ? "waveform.circle.fill" : "waveform"
        statusItem.button?.image = NSImage(systemSymbolName: iconName, accessibilityDescription: "Whispah")
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
