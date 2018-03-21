//
//  DownloadedListViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation

class DownloadedListViewController: UIViewController {

    static func instanciate(url: URL) -> DownloadedListViewController {
        return DownloadedListViewController(viewModel: DownloadedListViewModel(url: url))
    }

    private let contentView: DownloadedListView = {
        let v = DownloadedListView(frame: .zero)
        return v
    }()

    private let viewModel: DownloadedListViewModel
    private let disposeBag = DisposeBag()
    private var player: AVAudioPlayer!

    private init(viewModel: DownloadedListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.bottom.equalToSuperview()
                .offset(-(AppRouter.shared.rootViewController.playerView.frame.height+self.tabBarController!.tabBar.frame.height))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }

    func subscribe() {
        let urlSelected = contentView.tableView.rx.modelSelected(URL.self)
        let input = DownloadedListViewModel.Input(viewWillAppear: self.rx.viewWillAppear.asDriver(),
                                                   urlSelected: urlSelected.asDriver(),
                                                   playAllButtonTapped: contentView.playAllButton.rx.tap.asDriver())
        let output = viewModel.translate(input)

        output.items.asDriver().drive(contentView.tableView.rx.items) { (tableView, row, url) -> UITableViewCell in
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let fileName = url.lastPathComponent
            if let range = fileName.range(of: ".\(url.pathExtension)") {
                cell.textLabel?.text = String(fileName[fileName.startIndex..<range.lowerBound])
            } else {
                cell.textLabel?.text = fileName
            }
            cell.textLabel!.numberOfLines = -1
            return cell
        }.disposed(by: disposeBag)

        output.audioDirectorySubject.subscribe(onNext: { [weak self] isAudioDirectory in
            guard let me = self else { return }
            me.navigationItem.setRightBarButton(isAudioDirectory ? me.contentView.playAllButton : nil, animated: true)
        }).disposed(by: disposeBag)
    }
}
