//
//  DownloadingListView.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class DownloadingListView: UIView {

    private let headerView: UINavigationBar = {
        let v = UINavigationBar(frame: .zero)
        v.isTranslucent = false
        return v
    }()

    let backButton: UIButton = {
        let v = UIButton(frame: .zero)
        v.setTitle("Back", for: .normal)
        v.setTitleColor(.black, for: .normal)
        return v
    }()

    let tableView: UITableView = {
        let v = UITableView(frame: .zero)
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.backgroundColor = .white

        setupLayout()
    }

    private func setupLayout() {
        self.addSubview(self.headerView)
        self.headerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
            $0.height.equalTo(44)
        }

        self.headerView.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }

        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.width.bottom.equalToSuperview()
        }
    }

}
