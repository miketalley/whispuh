import AppKit
import Foundation
import Observation

@Observable
final class AppState {
    var isRecording = false
    var isTranscribing = false
    var statusMessage = "Ready"

    let modelManager = ModelManager()
    private let hotkeyManager = HotkeyManager()
    private let audioRecorder = AudioRecorder()
    private let transcriptionService = TranscriptionService()
    private let textPaster = TextPaster()
    private let overlayController = OverlayPanelController()

    var onRecordingStateChanged: ((Bool) -> Void)?

    init() {
        hotkeyManager.onToggle = { [weak self] in
            self?.toggleRecording()
        }

        Task {
            let permissions = await PermissionChecker.checkAllPermissions()
            if !permissions.mic {
                await MainActor.run { self.statusMessage = "Microphone access required" }
            }
            if !permissions.accessibility {
                await MainActor.run { self.statusMessage = "Accessibility access required" }
            }

            await modelManager.ensureModelAvailable()
            if modelManager.isReady {
                try? transcriptionService.loadModel(from: modelManager.modelFileURL)
            }
        }
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        guard modelManager.isReady else {
            statusMessage = "Model not ready"
            print("[Whispah] Cannot record — model not ready")
            return
        }

        textPaster.captureCurrentApp()

        do {
            try audioRecorder.startRecording()
            isRecording = true
            statusMessage = "Recording..."
            overlayController.show(appState: self)
            onRecordingStateChanged?(true)
            print("[Whispah] Recording started")
        } catch {
            print("[Whispah] Failed to start recording: \(error)")
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }

    private func stopRecording() {
        let samples = audioRecorder.stopRecording()
        isRecording = false
        isTranscribing = true
        statusMessage = "Transcribing..."
        onRecordingStateChanged?(false)
        print("[Whispah] Recording stopped. Captured \(samples.count) samples (\(String(format: "%.1f", Double(samples.count) / 16000.0))s)")

        Task {
            do {
                let text = try await transcriptionService.transcribe(audioFrames: samples)
                await MainActor.run {
                    isTranscribing = false
                    statusMessage = "Ready"
                    overlayController.hide()
                    textPaster.paste(text: text)
                }
            } catch {
                await MainActor.run {
                    isTranscribing = false
                    statusMessage = "Error: \(error.localizedDescription)"
                    overlayController.hide()
                    print("[Whispah] Transcription failed: \(error)")
                }
            }
        }
    }
}
