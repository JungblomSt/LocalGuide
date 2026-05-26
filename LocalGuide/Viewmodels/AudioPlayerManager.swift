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

    var isPlaying = false

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
