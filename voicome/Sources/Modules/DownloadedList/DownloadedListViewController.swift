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
            $0.edges.equalToSuperview()
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

        output.items.asDriver().drive(contentView.tableView.rx.items)  { (tableView, row, url) -> UITableViewCell in
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

//        contentView.tableView.rx.modelSelected(URL.self)
//            .map { url -> Optional<URL> in
//                var res: URL = url
//                while let url = try? FileManager.default.contentsOfDirectory(at: res, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).first {
//                    if let url = url {
//                        res = url
//                    }
//                }
//                return res
//            }
//            .subscribe(onNext: { [unowned self] url in
//                print(url)
//                guard let url = url else { return }
//                do {
//                    self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url.path), fileTypeHint: url.pathExtension)
//                    self.player.prepareToPlay()
//                    self.player.play()
//                } catch let e {
//                    print(e)
//                }

    }
}
