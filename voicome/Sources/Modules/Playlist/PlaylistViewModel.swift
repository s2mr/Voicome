//
//  PlaylistViewModel.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlaylistViewModel {

    enum Action {
        case download
    }

    enum State {
        case error(error: Error)
    }

    private let voiceDatas: BehaviorRelay<[VoicyResponse.VoiceData]>
    private let action: PublishSubject<Action>
    private let state: PublishSubject<State>
    private let disposeBag = DisposeBag()

    init(program: VoicyResponse.PlaylistData) {
        self.voiceDatas = BehaviorRelay(value: program.voiceDatas)
        self.action = PublishSubject()
        self.state = PublishSubject()
        
        self.action
            .map(translate)
            .subscribe(onNext: {
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        let viewDidLoad: Driver<Void>
        let downloadButtonTapped: Driver<Void>
    }

    struct Output {
        let voiceDatas: BehaviorRelay<[VoicyResponse.VoiceData]>
        let state: PublishSubject<State>
    }

    func translate(_ input: Input) -> Output {
        input.downloadButtonTapped
            .drive(onNext: { [weak self] in
                self?.action.onNext(.download)
            }).disposed(by: disposeBag)

        return Output(voiceDatas: voiceDatas, state: state)
    }

    func translate(_ action: Action) {
        switch action {
        case .download:
            // TODO:
//            for data in voiceDatas.value {
//                data.voiceFile
//            }
            if let v = voiceDatas.value.first?.voiceFile {
                VoiProvider.rx.requestWithProgress(.voiceData(name: v), callbackQueue: nil)
                    .subscribe(onNext: { (r) in
                        print(r.progress)
                        print("\(r.completed ? "End" : "Not End")")
                    }, onError: { (e) in
                        print(e.localizedDescription)
                    }, onCompleted: {
                        print("completed")
                    }, onDisposed: {
                        print("disposed")
                    }).disposed(by: disposeBag)
            }

        }
    }
}
