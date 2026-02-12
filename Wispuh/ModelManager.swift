import Foundation
import Observation

@Observable
final class ModelManager {
    var downloadProgress: Double = 0
    var isDownloading = false
    var isReady = false
    var errorMessage: String?

    private static let modelFileName = "ggml-base.bin"
    private static let modelURL = URL(string: "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin?download=true")!

    var modelFileURL: URL {
        Self.appSupportDirectory.appendingPathComponent(Self.modelFileName)
    }

    private static var appSupportDirectory: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Wispuh")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    func ensureModelAvailable() async {
        if FileManager.default.fileExists(atPath: modelFileURL.path) {
            isReady = true
            print("[Wispuh] Model already downloaded at \(modelFileURL.path)")
            return
        }

        await downloadModel()
    }

    private func downloadModel() async {
        isDownloading = true
        downloadProgress = 0
        errorMessage = nil
        print("[Wispuh] Downloading whisper model...")

        do {
            let (asyncBytes, response) = try await URLSession.shared.bytes(from: Self.modelURL)
            let expectedLength = response.expectedContentLength
            var data = Data()
            if expectedLength > 0 {
                data.reserveCapacity(Int(expectedLength))
            }

            for try await byte in asyncBytes {
                data.append(byte)
                if expectedLength > 0 {
                    let newProgress = Double(data.count) / Double(expectedLength)
                    if newProgress - downloadProgress >= 0.01 {
                        downloadProgress = newProgress
                    }
                }
            }

            try data.write(to: modelFileURL)
            downloadProgress = 1.0
            isDownloading = false
            isReady = true
            print("[Wispuh] Model downloaded successfully (\(data.count / 1_048_576) MB)")
        } catch {
            isDownloading = false
            errorMessage = error.localizedDescription
            print("[Wispuh] Model download failed: \(error)")
        }
    }
}
