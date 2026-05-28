import Foundation

@Observable
class GuideDetailViewModel {
    private let audioPlayer = AudioPlayerManager()
    let guide: Guide

    var isPlaying: Bool { audioPlayer.isPlaying }

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
}
