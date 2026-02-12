import AVFoundation
import AppKit

enum PermissionChecker {
    static func checkMicrophoneAccess() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .audio)
        case .denied, .restricted:
            print("[Wispuh] Microphone access denied")
            return false
        @unknown default:
            return false
        }
    }

    static func checkAccessibilityAccess() -> Bool {
        let trusted = AXIsProcessTrusted()
        if !trusted {
            print("[Wispuh] Accessibility access not granted — prompting user")
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
            AXIsProcessTrustedWithOptions(options)
        }
        return trusted
    }

    static func checkAllPermissions() async -> (mic: Bool, accessibility: Bool) {
        let mic = await checkMicrophoneAccess()
        let accessibility = checkAccessibilityAccess()
        return (mic, accessibility)
    }
}
