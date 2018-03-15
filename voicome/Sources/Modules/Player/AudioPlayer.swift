//
//  AudioPlayer.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/14.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

class AudioPlayer: NSObject {

    enum State {
        case playing
        case stop
    }

    private var player: AVAudioPlayer?
    let state: BehaviorRelay<State>
    var playlist: [URL] {
        didSet {
            playlistNextIndex = 0
        }
    }
    var playPosition: Double? {
        guard let player = player else { return nil}
        return player.currentTime / player.duration
    }
    let  currentPlayUrl: PublishSubject<URL>
    private var playlistNextIndex = 0
    private let disposeBag = DisposeBag()

    static let shared = AudioPlayer()

    private override init() {
        self.playlist = []
        self.state = BehaviorRelay(value: .stop)
        self.currentPlayUrl = PublishSubject()
        super.init()

        subscribe()
        setup()
//        playPosition.
    }

    private func subscribe() {
        state.subscribe(onNext: { [weak self] s in
            guard let me = self else { return }
            switch s {
            case .playing:
                me.play()
            case .stop:
                me.stop()
            }
        }).disposed(by: disposeBag)
    }

    private func setup() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch let e {
            print(e)
        }
    }

    func playPrev() {
        if playlistNextIndex - 1 >= 0 {
            playlistNextIndex -= 1
        }
        play(playlist[playlistNextIndex])
    }

    func playNext() {
        if playlistNextIndex + 1 < playlist.count {
            playlistNextIndex += 1
            play()
        } else {
            stop()
        }
    }

    func playOrStop() {
        switch state.value {
        case .playing:
            state.accept(.stop)
        case .stop:
            state.accept(.playing)
        }
    }

    private func play() {
        play(playlist[playlistNextIndex])
    }

    private func stop() {
        player?.stop()
    }

    private func play(_ url: URL) {
        player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url.path), fileTypeHint: url.pathExtension)
        guard let player = player else { return }
        currentPlayUrl.onNext(url)
        player.delegate = self
        player.prepareToPlay()
        player.play()
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNext()
    }
}
