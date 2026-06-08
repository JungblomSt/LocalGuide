//
//  AudioPlayerManager.swift
//  LocalGuide
//
//  Created by robin on 2026-05-25.
//

import AVFoundation
import Observation

@Observable
class AudioPlayerManager {
    private var player: AVAudioPlayer?
    private var timer: Timer?

    var isPlaying = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0

    var isLoaded: Bool { player != nil }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }

    func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            startPlayback()
        } catch {
            print("AudioPlayerManager: failed to play \(url): \(error)")
        }
    }

    /// Spelar upp ljud direkt från data,  nedladdat från Firebase Storage
    func play(data: Data) {
        do {
            player = try AVAudioPlayer(data: data)
            startPlayback()
        } catch {
            print("AudioPlayerManager: failed to play audio data: \(error)")
        }
    }

    /// Hämtar ljuddata från Firebase Storage via StorageService (med disk-cache)
    func play(storagePath path: String) async {
        do {
            let data = try await StorageService.shared.cachedAudioData(path: path)
            await MainActor.run { play(data: data) }
        } catch {
            print("AudioPlayerManager: failed to load audio at \(path): \(error)")
        }
    }

    private func startPlayback() {
        player?.play()
        duration = player?.duration ?? 0
        currentTime = 0
        isPlaying = true
        startTimer()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        stopTimer()
    }

    func resume() {
        player?.play()
        isPlaying = true
        startTimer()
    }

    func stop() {
        player?.stop()
        isPlaying = false
        currentTime = 0
        stopTimer()
    }

    func seek(to time: TimeInterval) {
        guard let player else { return }
        let clamped = max(0, min(time, player.duration))
        player.currentTime = clamped
        currentTime = clamped
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let player = self.player else { return }
            self.currentTime = player.currentTime
            if !player.isPlaying && self.isPlaying {
                self.isPlaying = false
                self.stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
