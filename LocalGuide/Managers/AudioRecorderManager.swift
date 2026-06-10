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
    private var recorder: AVAudioRecorder?
    
    var isRecording = false
    var isPaused = false
    private var timer: Timer?
    var currentlyTime: TimeInterval = 0
    
    // url to last recording
    private(set) var recordingURL: URL?
    private(set) var fileURL: URL?
    
    // function for asking permission
    private func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    // function to record
    func start() async {
        guard await requestPermission() else { return }
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            
            let dir = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("Recordings", isDirectory: true)
                
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            
            let stamp = ISO8601DateFormatter().string(from: .now).replacingOccurrences(of: ":", with: "-")
            let url = dir.appendingPathComponent("\(stamp).m4a")
            fileURL = url
            
            // AAC in an .m4a container
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.record()
            
            isRecording = true
            currentlyTime = 0
            startTimer()
            
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    func stop(){
        guard isRecording else { return }
        stopTimer()
        recorder?.stop()
        recordingURL = fileURL
        isRecording = false
        isPaused = false
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    func pause(){
        guard isRecording, !isPaused else { return }
        recorder?.pause()
        isPaused = true
        stopTimer()
    }
    
    func resume(){
        guard isRecording, isPaused else { return }
        recorder?.record()
        isPaused = false
        startTimer()
    }
    
    func reset(){
        stopTimer()
        recorder?.stop()
        if let fileURL {
            try? FileManager.default.removeItem(at: fileURL)
        }
        recorder = nil
        fileURL = nil
        recordingURL = nil
        isRecording = false
        isPaused = false
        currentlyTime = 0
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    /// Deletes a recording this manager created. URLs outside our Recordings
    /// folder (e.g. files picked from the Files app) are ignored.
    static func deleteRecording(at url: URL) {
        guard url.deletingLastPathComponent().lastPathComponent == "Recordings" else { return }
        try? FileManager.default.removeItem(at: url)
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let recorder = self.recorder else { return }
            self.currentlyTime = recorder.currentTime
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
