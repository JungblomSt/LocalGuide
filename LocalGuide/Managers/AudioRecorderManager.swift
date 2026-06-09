//
//  AudioRecorderManager.swift
//  LocalGuide
//
//  Created by robin on 2026-06-09.
//

import AVFoundation
import Observation

@Observable
final class AudioRecorderManager {
    private var recorder: AVAudioRecorder
    
    var isRecording = false
    private var timer: Timer?
    var currentlyTime: TimeInterval = 0
    
    // url to last recording
    private(set) var recordingURL: URL?
    
    init(recorder: AVAudioRecorder) {
        self.recorder = recorder
    }
    
    // function for asking permission
    private func RequestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    // function to record
    
    private func startTimer() {
        stopTimer()
    }
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
