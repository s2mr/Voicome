//
//  DownloadingListViewModel.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DownloadingListViewModel {

    private let disposeBag = DisposeBag()
    let voices: BehaviorRelay<[VoicyResponse.VoiceData]>

    init() {
        voices = BehaviorRelay(value: [])

        voices.subscribe(onNext: { [weak self] (voices) in
            guard let me = self else { return }
            voices.forEach {
                me.download(voice: $0)
            }
        }).disposed(by: disposeBag)
    }

    func appendVoices(_ voices: [VoicyResponse.VoiceData]) {
        let new = self.voices.value + voices
        self.voices.accept(new)
    }

    private func download(voice: VoicyResponse.VoiceData) {
        VoiProvider.rx.requestWithProgress(.voiceData(voice: voice), callbackQueue: nil)
            .map { ($0, voice) }
            .subscribe(onNext: { [weak self] (r, v) in
                guard let me = self else { return }
                if r.completed {
                    // ダウンロードが完了したら待ち行列から削除する
                    var voices = me.voices.value
                    let i = me.voices.value.index(where: { (v2) -> Bool in
                        return v2.voiceFile == v.voiceFile
                    })
                    if let i = i {
                        voices.remove(at: i)
                        me.voices.accept(voices)
                    }
                }
                print(r.progress)
            }, onError: { (e) in
                print(e.localizedDescription)
            }, onCompleted: {
                print("download completed")
            }, onDisposed: {
            }).disposed(by: disposeBag)
    }
}
