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
        v.setTitle("N/A", for: .normal)
        v.layer.cornerRadius = 30
        v.layer.masksToBounds = true
        v.backgroundColor = .black
        v.setTitleColor(.white, for: .normal)
        return v
    }()

    let playerView: PlayerView = {
        let v = PlayerView(frame: .zero)
        return v
    }()

    let downloadingListViewController: DownloadingListViewController = {
        let vc = DownloadingListViewController.instanciate()
        return vc
    }()

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

    private func subscribe() {
        showDonloadingListButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let me = self else { return }
            me.present(me.downloadingListViewController, animated: true)
        }).disposed(by: disposeBag)

        downloadingListViewController.viewModel.voices
            .map { [weak self] voices -> String in
                guard let me = self else { return "" }
                me.showDonloadingListButton.isHidden = !(voices.count>0)
                return "\(voices.count)"
            }
            .bind(to: showDonloadingListButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        let tap = UITapGestureRecognizer(target: nil, action: nil)
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let me = self else { return }
            AppRouter.shared.route(to: .player, from: me)
        }).disposed(by: disposeBag)
        playerView.addGestureRecognizer(tap)

        

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
