//
//  PlayerViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/17.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift

class PlayerViewController: UIViewController {

    static func instanciate(playerView: PlayerView) -> PlayerViewController {
        let vc = PlayerViewController(playerView: playerView)
        return vc
    }

    let headerView: PlayerHeaderView
    let contentView: PlayerView
    private let disposeBag = DisposeBag()

    init(playerView: PlayerView) {
        self.headerView = PlayerHeaderView(frame: .zero)
        self.contentView = playerView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white

        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.width.top.equalToSuperview()
            $0.height.equalTo(300)
        }

        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.width.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }

    func subscribe() {
        headerView.backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let me = self else { return }
            me.dismiss(animated: true)
        }).disposed(by: disposeBag)

        AudioPlayer.shared.playingPosition
            .map { Float($0) }
            .bind(to: headerView.playingPositionSlider.rx.value)
            .disposed(by: disposeBag)

        AudioPlayer.shared.currentTime
            .bind(to: headerView.currentTimeLabel.rx.text)
            .disposed(by: disposeBag)

        AudioPlayer.shared.totalTime
            .bind(to: headerView.totalTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
