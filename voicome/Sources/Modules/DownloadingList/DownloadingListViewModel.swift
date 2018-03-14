//
//  DownloadingListViewModel.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift

class DownloadingListViewModel {

    private let disposeBag = DisposeBag()
    let voices: PublishSubject<[VoicyResponse.VoiceData]>

    init() {
        voices = PublishSubject()

        voices.subscribe(onNext: { [weak self] (voices) in
            guard let me = self else { return }
            voices.forEach {
                me.download(voice: $0)
            }
        }).disposed(by: disposeBag)
    }

    private func download(voice: VoicyResponse.VoiceData) {
        VoiProvider.rx.requestWithProgress(.voiceData(voice: voice), callbackQueue: nil)
            .subscribe(onNext: { (r) in
                print(r.progress)
            }, onError: { (e) in
                print(e.localizedDescription)
            }, onCompleted: {
                print("download completed")
            }, onDisposed: {
            }).disposed(by: disposeBag)
    }
}
