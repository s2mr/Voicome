//
//  PlayerFooterView.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/21.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class PlayerFooterView: UIView {

    let playlistTableView: UITableView = {
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
        setupLayout()
    }

    private func setupLayout() {
        self.addSubview(playlistTableView)
        playlistTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

