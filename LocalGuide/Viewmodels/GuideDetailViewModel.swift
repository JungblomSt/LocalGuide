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
            audioPlayer.stop()
        } else if let name = guide.audioURL,
                  let url = Bundle.main.url(forResource: name, withExtension: nil) {
            audioPlayer.play(url: url)
        }
    }
}
