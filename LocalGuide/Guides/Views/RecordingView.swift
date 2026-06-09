//
//  RecordingView.swift
//  LocalGuide
//
//  Created by robin on 2026-06-09.
//

import SwiftUI

struct RecordingView: View {
    @State private var viewModel = RecordingViewModel()
    @State private var didUseRecording = false
    @Environment(\.dismiss) private var dismiss

    var onUse: ((URL) -> Void)? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Text(viewModel.formattedTime)
                    .font(.system(size: 56, weight: .light, design: .rounded).monospacedDigit())

                Text(viewModel.statusText)
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Spacer()

                controls

                Spacer()
            }
            .padding()
            .navigationTitle("Spela in ljud")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Använd") {
                        if let url = viewModel.recordingURL {
                            didUseRecording = true
                            onUse?(url)
                        }
                        dismiss()
                    }
                    .disabled(!viewModel.hasRecording)
                }
            }
            .onDisappear {
                // dismissed (incl. swipe-down) without using the take → clean up
                if !didUseRecording { viewModel.reset() }
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 48) {
            if viewModel.isRecording {
                circleButton(viewModel.isPaused ? "play.fill" : "pause.fill", tint: .gray) {
                    viewModel.togglePause()
                }
                circleButton("stop.fill", tint: .red) {
                    viewModel.stop()
                }
            } else if viewModel.hasRecording {
                circleButton("arrow.counterclockwise", tint: .gray) {
                    viewModel.reset()
                }
                circleButton(viewModel.isPlaying ? "pause.fill" : "play.fill", tint: .accentColor) {
                    viewModel.togglePlayback()
                }
            } else {
                circleButton("mic.fill", tint: .red) {
                    Task { await viewModel.start() }
                }
            }
        }
    }

    private func circleButton(
        _ icon: String,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 72, height: 72)
                .background(tint, in: Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RecordingView()
}
