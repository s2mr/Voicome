//
//  AudioPlayer.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/14.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import RxSwift
import RxCocoa

class AudioPlayer: NSObject {

    enum State {
        case playing
        case stop
        case resume
    }

    let state: BehaviorRelay<State>
    var playlist: [URL] {
        didSet {
            playlistNextIndex = 0
        }
    }
    let playingPosition = PublishSubject<Double>()
    let currentTime = PublishSubject<String>()
    let currentTimeInput = PublishSubject<Double>()
    let totalTime = ReplaySubject<String>.create(bufferSize: 1)
    let currentPlayUrl = PublishSubject<URL>()
    private var player: AVAudioPlayer?
    private var playlistNextIndex = 0
    private let disposeBag = DisposeBag()

    static let shared = AudioPlayer()

    private override init() {
        self.playlist = []
        self.state = BehaviorRelay(value: .stop)
        super.init()

        subscribe()
        setup()
    }

    private func subscribe() {
        state.subscribe(onNext: { [weak self] s in
            guard let me = self else { return }
            switch s {
            case .playing:
                me.play()
            case .stop:
                me.stop()
            case .resume:
                me.resume()
            }
        }).disposed(by: disposeBag)

        currentTimeInput.subscribe(onNext: { [weak self] per in
            guard let me = self, let player = me.player else { return }
            player.currentTime = player.duration * per
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

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] (e) -> MPRemoteCommandHandlerStatus in
            // eyephone center button pushed
            guard let me = self else { return .commandFailed }
            me.playOrStop()
            return .success
        }
        commandCenter.playCommand.addTarget { [weak self] (e) -> MPRemoteCommandHandlerStatus in
            guard let me = self else { return .commandFailed }
            me.state.accept(.resume)
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (e) -> MPRemoteCommandHandlerStatus in
            guard let me = self else { return .commandFailed }
            me.state.accept(.stop)
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { [weak self] (e) -> MPRemoteCommandHandlerStatus in
            guard let me = self else { return .commandFailed }
            me.playPrev()
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { [weak self] (e) -> MPRemoteCommandHandlerStatus in
            guard let me = self else { return .commandFailed }
            me.playNext()
            return .success
        }

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
            guard let me = self, let player = me.player else { return }
            let position = player.currentTime / player.duration
            let min = Int(player.currentTime/60)
            let sec = Int(player.currentTime) - (min * 60)
            me.currentTime.onNext("\(min):\(sec)")
            me.playingPosition.onNext(position)
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
            state.accept(.resume)
        case .resume:
            state.accept(.stop)
        }
    }

    private func play() {
        play(playlist[playlistNextIndex])
    }

    private func stop() {
        player?.pause()
    }

    private func resume() {
        player?.play()
    }

    private func play(_ url: URL) {
        player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url.path), fileTypeHint: url.pathExtension)
        guard let player = player else { return }
        let infoCenter = MPNowPlayingInfoCenter.default()
        infoCenter.nowPlayingInfo = [MPMediaItemPropertyTitle: url.lastPathComponent]
        let min = Int(player.duration/60)
        let sec = Int(player.duration) - (min * 60)
        totalTime.onNext("\(min):\(sec)")
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
