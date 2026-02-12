import Foundation
import SwiftWhisper

final class TranscriptionService {
    private var whisper: Whisper?

    func loadModel(from fileURL: URL) throws {
        let params = WhisperParams(strategy: .greedy)
        params.language = .english
        whisper = Whisper(fromFileURL: fileURL, withParams: params)
        print("[Whispah] Whisper model loaded")
    }

    func transcribe(audioFrames: [Float]) async throws -> String {
        guard let whisper else {
            throw TranscriptionError.modelNotLoaded
        }

        let segments = try await whisper.transcribe(audioFrames: audioFrames)
        let text = segments.map(\.text).joined().trimmingCharacters(in: .whitespacesAndNewlines)
        print("[Whispah] Transcribed: \(text)")
        return text
    }

    enum TranscriptionError: Error {
        case modelNotLoaded
    }
}
