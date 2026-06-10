//
//  RecordingViewModel.swift
//  LocalGuide
//
//  Created by robin on 2026-06-09.
//

import Foundation
import Observation

@Observable
final class RecordingViewModel {

    private let recorder: AudioRecorderManager
    private let player = AudioPlayerManager()
    private var loadedURL: URL?

    init(recorder: AudioRecorderManager = AudioRecorderManager()) {
        self.recorder = recorder
    }

    // MARK: State

    var isRecording: Bool { recorder.isRecording }
    var isPaused: Bool { recorder.isPaused }
    var isPlaying: Bool { player.isPlaying }
    var elapsedTime: TimeInterval { recorder.currentlyTime }
    var recordingURL: URL? { recorder.recordingURL }
    var hasRecording: Bool { recorder.recordingURL != nil }

    var statusText: String {
        if isPlaying { return "Spelar upp…" }
        if isRecording && isPaused { return "Pausad" }
        if isRecording { return "Spelar in…" }
        if hasRecording { return "Inspelning klar" }
        return "Tryck för att spela in"
    }

    var formattedTime: String {
        let total = max(Int(elapsedTime), 0)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }

    // MARK: Recording

    func start() async {
        player.stop()
        await recorder.start()
    }

    func stop() { recorder.stop() }

    func reset() {
        player.stop()
        loadedURL = nil
        recorder.reset()
    }

    func togglePause() {
        if isPaused { recorder.resume() } else { recorder.pause() }
    }

    // MARK: Playback

    func togglePlayback() {
        guard let url = recordingURL else { return }
        if player.isPlaying {
            player.pause()
        } else if player.isLoaded, loadedURL == url {
            player.resume()
        } else {
            player.play(url: url)
            loadedURL = url
        }
    }
}
