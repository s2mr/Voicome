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

    init() {
        items = BehaviorRelay(value: [])
    }

    struct Input {
        let viewWillAppear: Driver<Void>
    }

    struct Output {
        let items: BehaviorRelay<[URL]>
    }

    func translate(_ input: Input) -> Output {
        input.viewWillAppear.drive(onNext: {
            let manager = FileManager.default
            let directory = manager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            print(directory.absoluteString)

            var urls: [URL] = []
            do {
                urls = try manager.contentsOfDirectory(at: directory.appendingPathComponent("/Downloaded"),
                                                       includingPropertiesForKeys: nil,
                                                       options: [.skipsHiddenFiles])
            } catch let e {
                print(e)
            }

            self.items.accept(urls)
        }).disposed(by: disposeBag)

        return Output(items: items)
    }
}
