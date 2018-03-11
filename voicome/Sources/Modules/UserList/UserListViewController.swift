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
        return UserListViewController()
    }

    private let contentView = UserListView(frame: .zero)

    private let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()

        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        VoiProvider.rx.request(.articleList(channelId: 1, pId: 1))
            .subscribe(onSuccess: { (r) in
                print(r)
            }, onError: { (e) in
                print(e)
            }).disposed(by: disposeBag)
    }
}

