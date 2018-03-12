//
//  ProgramListViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProgramListViewController: UIViewController {

    static func instantiate(user: User) -> ProgramListViewController {
        let vc = ProgramListViewController(viewModel: ProgramListViewModel(user: user))
        return vc
    }

    private let viewModel: ProgramListViewModel
    private let disposeBag = DisposeBag()

    private let contentView = ProgramListView(frame: .zero)

    init(viewModel: ProgramListViewModel) {
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

        contentView.tableView.dataSource = self
//        contentView.tableView.delegate = self

        subscribe()
    }

    func subscribe() {

        let input = ProgramListViewModel.Input(viewWillAppear: self.rx.viewWillAppear.asDriver())
        viewModel.translate(from: input)

        viewModel.response.asObservable()
            .debug()
            .do {
                self.contentView.tableView.reloadData()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ProgramListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.response.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = viewModel.response.value[indexPath.row].channelName
        return cell
    }
}
