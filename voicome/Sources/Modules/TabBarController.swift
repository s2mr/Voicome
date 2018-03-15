//
//  NavigationController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/12.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift

class TabBarController: UITabBarController {

    private let disposeBag = DisposeBag()

    private let showDonloadingListButton: UIButton = {
        let v = UIButton(frame: .zero)
        v.setTitle("Downloading", for: .normal)
        v.layer.cornerRadius = 30
        v.layer.masksToBounds = true
        v.backgroundColor = .blue
        return v
    }()

    private let playerView: PlayerView = {
        let v = PlayerView(frame: .zero)
        return v
    }()

    let downloadingListViewController: DownloadingListViewController = {
        let vc = DownloadingListViewController.instanciate()
        return vc
    }()

    override func loadView() {
        super.loadView()

        self.view.addSubview(playerView)
        playerView.snp.makeConstraints { [weak self] in
            guard let me = self else { return }
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalTo(me.tabBar.snp.top)
        }

        self.view.addSubview(showDonloadingListButton)
        showDonloadingListButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.playerView.snp.top).offset(-8)
            $0.size.equalTo(60)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }

    private func subscribe() {
        showDonloadingListButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let me = self else { return }
            me.present(me.downloadingListViewController, animated: true)
        }).disposed(by: disposeBag)

        playerView.changePlayStateButton.rx.tap.subscribe(onNext: {
            AudioPlayer.shared.playOrStop()
        }).disposed(by: disposeBag)

        playerView.playPrevButton.rx.tap.subscribe(onNext: {
            AudioPlayer.shared.playPrev()
        }).disposed(by: disposeBag)

        playerView.playNextButton.rx.tap.subscribe(onNext: {
            AudioPlayer.shared.playNext()
        }).disposed(by: disposeBag)

//        AudioPlayer.shared.state

        AudioPlayer.shared.currentPlayUrl
            .map { $0.lastPathComponent }
            .bind(to: playerView.playingTitleLabel.rx.text)
            .disposed(by: disposeBag)

        AudioPlayer.shared.state
            .map { s in
                switch s {
                case .playing:
                    return "||"
                case .stop:
                    return "▶"
                case .resume:
                    return "||"
                }
            }
            .bind(to: playerView.changePlayStateButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

    }
}
