//
//  PlayerView.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/13.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    var changePlayStateButton: UIButton = {
        let v = UIButton(frame: CGRect(x: 8, y: 8, width: 20, height: 20))
        v.setTitle("▶", for: .normal)
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

        self.backgroundColor = .black
    }

    private func setupLayout() {
        self.addSubview(changePlayStateButton)
        changePlayStateButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
        }
    }
}
