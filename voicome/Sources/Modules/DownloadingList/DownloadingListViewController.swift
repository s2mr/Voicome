//
//  DownloadingListViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift

class DownloadingListViewController: UIViewController {

    static func instanciate() -> DownloadingListViewController {
        let vc = DownloadingListViewController(viewModel: DownloadingListViewModel())
        return vc
    }

    private let contentView: DownloadingListView = {
        let v = DownloadingListView(frame: .zero)
        return v
    }()

    private let disposeBag = DisposeBag()

    let viewModel: DownloadingListViewModel

    private init(viewModel: DownloadingListViewModel) {
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
        contentView.backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let me = self else { return }
            me.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)

        viewModel.voices.bind(to: contentView.tableView.rx.items)  { (tableView, row, voice) -> UITableViewCell in
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = voice.articleTitle
            return cell
        }.disposed(by: disposeBag)
    }
}
