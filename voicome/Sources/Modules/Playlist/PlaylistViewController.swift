//
//  PlaylistViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift

class PlaylistViewController: UIViewController {

    static func instanciate(program: VoicyResponse.PlaylistData) -> PlaylistViewController {
        let vc = PlaylistViewController(viewModel: PlaylistViewModel(program: program))
        return vc
    }

    private let contentView: PlaylistView = {
        let v = PlaylistView(frame: .zero)
        return v
    }()

    private let viewModel: PlaylistViewModel
    private let disposeBag: DisposeBag = DisposeBag()

    init(viewModel: PlaylistViewModel) {
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

        self.navigationItem.rightBarButtonItem = contentView.downloadButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }

    func subscribe() {
        let input = PlaylistViewModel.Input(viewDidLoad: self.rx.viewDidLoad.asDriver())
        let output = viewModel.translate(input)

        output.voiceDatas.asDriver()
            .drive(self.contentView.tableView.rx.items)  { (tableView, row, voiceData) -> UITableViewCell in
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel!.text = voiceData.articleTitle
                return cell
        }.disposed(by: disposeBag)
    }
}
