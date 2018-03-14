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

class DownloadedListViewModel {

    private let currentDirectory: URL
    private let items: BehaviorRelay<[URL]>
    private let disposeBag = DisposeBag()
    private let fileManager = FileManager.default
    private let audioDirectorySubject = ReplaySubject<Bool>.create(bufferSize: 1)

    init(url: URL) {
        self.currentDirectory = url
        self.items = BehaviorRelay(value: [])
    }

    struct Input {
        let viewWillAppear: Driver<Void>
        let urlSelected: Driver<URL>
        let playAllButtonTapped: Driver<Void>
    }

    struct Output {
        let items: BehaviorRelay<[URL]>
        let audioDirectorySubject: ReplaySubject<Bool>
    }

    func translate(_ input: Input) -> Output {
        input.viewWillAppear.drive(onNext: { [weak self] in
            guard let me = self else { return }
            var urls: [URL] = []
            do {
                urls = try me.fileManager.contentsOfDirectory(at: me.currentDirectory,
                                                           includingPropertiesForKeys: nil,
                                                           options: [.skipsHiddenFiles])
            } catch let e {
                print(e)
            }
            urls = urls.sorted { (u1, u2) -> Bool in
                return u1.lastPathComponent < u2.lastPathComponent
            }
            me.items.accept(urls)
            if let url = urls.first {
                me.audioDirectorySubject.onNext(url.pathExtension != "")
            }
        }).disposed(by: disposeBag)

        input.urlSelected.drive(onNext: {[weak self] url in
            guard let me = self else { return }
            if let _ = try? me.fileManager.contentsOfDirectory(atPath: url.path) {
                // directory
                AppRouter.shared.route(to: .downloadedList(url: url), from: nil)
            } else {
                // file
            }
        }).disposed(by: disposeBag)

        input.playAllButtonTapped
            .withLatestFrom(items.asDriver())
            .drive(onNext: { urls in
                AudioPlayer.shared.playlist = urls
                AudioPlayer.shared.play()
            }).disposed(by: disposeBag)

        return Output(items: items, audioDirectorySubject: audioDirectorySubject)
    }
}
