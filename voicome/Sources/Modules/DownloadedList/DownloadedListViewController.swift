//
//  DownloadedListViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class DownloadedListViewController: UIViewController {

    static func instanciate() -> DownloadedListViewController {
        return DownloadedListViewController()
    }

    private let contentView: DownloaedListView = {
        let v = DownloaedListView(frame: .zero)
        return v
    }()

    override func loadView() {
        super.loadView()

        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
