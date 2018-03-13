//
//  DownloadedListViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift

class DownloadedListViewController: UIViewController {

    static func instanciate() -> DownloadedListViewController {
        return DownloadedListViewController(viewModel: DownloadingListViewModel())
    }

    private let contentView: DownloaedListView = {
        let v = DownloaedListView(frame: .zero)
        return v
    }()

    private let viewModel: DownloadingListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: DownloadingListViewModel) {
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
        let input = DownloadingListViewModel.Input(viewWillAppear: self.rx.viewWillAppear.asDriver())
        let output = viewModel.translate(input)

        output.items.asDriver().drive(contentView.tableView.rx.items)  { (tableView, row, url) -> UITableViewCell in
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel!.text = url.lastPathComponent
            cell.textLabel!.numberOfLines = -1
            return cell
        }.disposed(by: disposeBag)

        contentView.tableView.rx.modelSelected(URL.self)
            .subscribe(onNext: { url in
                
            })
    }
}
