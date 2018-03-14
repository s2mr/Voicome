//
//  AudioPlayer.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/14.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject {

    private var player: AVAudioPlayer?
    var playlist: [URL] {
        didSet {
            playlistNextIndex = 0
        }
    }
    private var playlistNextIndex = 0

    static let shared = AudioPlayer()

    private override init() {
        self.playlist = []
        super.init()
    }

    func play() {
        play(playlist[playlistNextIndex])
    }

    private func play(_ url: URL) {
        player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url.path), fileTypeHint: url.pathExtension)
        guard let player = player else { return }
        player.delegate = self
        player.prepareToPlay()
        player.play()
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playlistNextIndex += 1
        if playlistNextIndex >= playlist.count+1 { return }
        play(playlist[playlistNextIndex])
    }
}
