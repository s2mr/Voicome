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
    let response: BehaviorRelay<[VoicyResponse.PlaylistDatas.PlaylistData]> = BehaviorRelay(value: [])
    private let disposebag = DisposeBag()

    init(user: User) {
        self.user = user
    }

    struct Input {
        let viewWillAppear: Driver<Void>
    }

    struct Output {

    }
 
    func translate(from input: Input) {
        input.viewWillAppear
//            .debug()
            .flatMap { [weak self] () -> Driver<VoicyResponse> in
                guard let me = self else { return Driver.never() }
                return VoiProvider.rx.request(.programList(channelId: me.user.channelId, limit: 20, type_id: 0))
//                    .debug()
                    .mapTo(object: VoicyResponse.self)
                    .asDriver(onErrorRecover: { (e) -> SharedSequence<DriverSharingStrategy, VoicyResponse> in
                        return Driver.never()
                    })
//                    .asObservable()
//                    .map { $0.value.playlistData }
//                    .bind(to: me.response)
//                me.disposebag.insert(dis)
            }.drive(onNext: { [weak self] r in
                self?.response.accept(r.value.playlistData)
            }).disposed(by: disposebag)

    }
}


/*


 VoiProvider.rx.request(.programList(channelId: 588, limit: 20, type_id: 0))
 .mapTo(object: VoicyResponse.self)
 .subscribe(onSuccess: { (r) in
 print(r)
 }, onError: { (e) in
 print(e)
 }).disposed(by: disposeBag)


 */
