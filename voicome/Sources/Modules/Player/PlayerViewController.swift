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

    private let headerView: PlayerHeaderView
    private let playerView: PlayerView
    private let footerView: PlayerFooterView
    private let disposeBag = DisposeBag()

    init(playerView: PlayerView) {
        self.headerView = PlayerHeaderView(frame: .zero)
        self.playerView = playerView
        self.footerView = PlayerFooterView(frame: .zero)
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

        self.view.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.width.equalToSuperview()
        }

        self.view.addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.top.equalTo(playerView.snp.bottom)
            $0.right.left.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }

    func subscribe() {
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .down
        swipeDown.rx.event.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        self.view.addGestureRecognizer(swipeDown)

        headerView.backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let me = self else { return }
            me.dismiss(animated: true)
        }).disposed(by: disposeBag)

        headerView.clearPlaylistButton.rx.tap.subscribe(onNext: {
            AudioPlayer.shared.playlist.accept([])
        }).disposed(by: disposeBag)

        headerView.playingPositionSlider.rx.value
            .map { Double($0) }
            .bind(to: AudioPlayer.shared.currentTimeInput)
            .disposed(by: disposeBag)

        AudioPlayer.shared.playlist.bind(to: footerView.playlistTableView.rx.items) { (tableView, row, url) -> UITableViewCell in
            let cell = UITableViewCell()
            cell.textLabel?.text = url.lastPathComponent
            return cell
        }.disposed(by: disposeBag)

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
