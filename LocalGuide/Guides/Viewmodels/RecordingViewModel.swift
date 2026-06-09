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

    init(recorder: AudioRecorderManager = AudioRecorderManager()) {
        self.recorder = recorder
    }
}
