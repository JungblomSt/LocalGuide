//
//  AudioPlayerManager.swift
//  LocalGuide
//
//  Created by robin on 2026-05-25.
//

import AVFoundation

class AudioPlayerManager: ObservableObject {
    private var player: AVAudioPlayer?

    @Published var isPlaying = false

    func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            isPlaying = true
        } catch {
            print("AudioPlayerManager: failed to play \(url): \(error)")
        }
    }

    func stop() {
        player?.stop()
        isPlaying = false
    }
}
