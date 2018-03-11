//
//  UserListViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/10.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class UserListViewController: UIViewController {

    static func instanciate() -> UserListViewController {
        let vc = UserListViewController(viewModel: UserListViewModel())
        return vc
    }

    private let viewModel: UserListViewModel

    private let contentView = UserListView(frame: .zero)
    private let disposeBag = DisposeBag()

    init(viewModel: UserListViewModel) {
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

        VoiProvider.rx.request(.programList(channelId: 588, limit: 20, type_id: 0))
            .mapTo(object: VoicyResponse.self)
            .subscribe(onSuccess: { (r) in
                print(r)
            }, onError: { (e) in
                print(e)
            }).disposed(by: disposeBag)
    }

    func subscribe() {
        contentView.tableView.dataSource = self
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = viewModel.users[indexPath.row].name
        return cell
    }
}

