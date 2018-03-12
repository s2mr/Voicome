//
//  ProgramListViewModel.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProgramListViewModel {

    private let user: User
    private let playlists: BehaviorRelay<[VoicyResponse.PlaylistData]> = BehaviorRelay(value: [])
    private let disposebag = DisposeBag()

    init(user: User) {
        self.user = user
    }

    struct Input {
        let viewWillAppear: Driver<Void>
    }

    struct Output {
        let playlists: BehaviorRelay<[VoicyResponse.PlaylistData]>
    }
 
    func translate(from input: Input) -> Output {
        input.viewWillAppear
            .flatMap { [weak self] () -> Driver<VoicyResponse> in
                guard let me = self else { return Driver.never() }
                return VoiProvider.rx.request(.programList(channelId: me.user.channelId, limit: 20, type_id: 0))
                    .map { print($0.request?.debugDescription ?? ""); return $0 }
                    .mapTo(object: VoicyResponse.self)
                    .asDriver(onErrorRecover: { (e) -> SharedSequence<DriverSharingStrategy, VoicyResponse> in
                        print(e)
                        return Driver.never()
                    })
            }.drive(onNext: { [weak self] r in
                guard let me = self else { return }
                me.playlists.accept(r.value.playlistData)
            }).disposed(by: disposebag)

        return Output(playlists: playlists)
    }
}
