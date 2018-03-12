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

    private let voiceDatas: Driver<[VoicyResponse.VoiceData]>

    init(program: VoicyResponse.PlaylistData) {
        self.voiceDatas = Driver.of(program.voiceDatas)
    }

    struct Input {
        let viewDidLoad: Driver<Void>
    }

    struct Output {
        let voiceDatas: Driver<[VoicyResponse.VoiceData]>
    }

    func translate(_ input: Input) -> Output {
        return Output(voiceDatas: voiceDatas)
    }
}
