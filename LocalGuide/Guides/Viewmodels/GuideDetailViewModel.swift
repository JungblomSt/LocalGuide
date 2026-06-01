import Foundation

@Observable
class GuideDetailViewModel {
    private let audioPlayer = AudioPlayerManager()
    let guide: Guide

    var isPlaying: Bool { audioPlayer.isPlaying }
    var isAudioLoaded: Bool { audioPlayer.isLoaded }
    var currentTime: TimeInterval { audioPlayer.currentTime }
    var duration: TimeInterval { audioPlayer.duration }
    var progress: Double { audioPlayer.progress }

    init(guide: Guide) {
        self.guide = guide
    }

    func toggleAudio() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else if audioPlayer.isLoaded {
            audioPlayer.resume()
        } else if let name = guide.audioURL,
                  let url = Bundle.main.url(forResource: name, withExtension: nil) {
            audioPlayer.play(url: url)
        }
    }

    func seek(to time: TimeInterval) {
        audioPlayer.seek(to: time)
    }
}
