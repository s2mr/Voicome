//
//  DownloadedListViewModel.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DownloadingListViewModel {

    private let items: BehaviorRelay<[URL]>
    private let disposeBag = DisposeBag()
    private let fileManager = FileManager.default

    init(url: URL) {
        var urls: [URL] = []
        do {
            urls = try fileManager.contentsOfDirectory(at: url,
                                                   includingPropertiesForKeys: nil,
                                                   options: [.skipsHiddenFiles])
        } catch let e {
            print(e)
        }
        items = BehaviorRelay(value: urls)
    }

    struct Input {
        let viewWillAppear: Driver<Void>
        let urlSelected: Driver<URL>
    }

    struct Output {
        let items: BehaviorRelay<[URL]>
    }

    func translate(_ input: Input) -> Output {
        input.viewWillAppear.drive(onNext: {
        }).disposed(by: disposeBag)

        input.urlSelected.drive(onNext: { url in
            AppRouter.shared.route(to: .downloadedList(url: url), from: nil)
        }).disposed(by: disposeBag)

        return Output(items: items)
    }
}
