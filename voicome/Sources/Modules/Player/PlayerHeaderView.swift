//
//  PlayerHeaderView.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/17.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class PlayerHeaderView: UIView {

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

    let currentTimeLabel: UILabel = {
        let v = UILabel(frame: .zero)
        v.text = "aaa"
        return v
    }()

    let totalTimeLabel: UILabel = {
        let v = UILabel(frame: .zero)
        v.text = "bbb"
        return v
    }()

    let playingPositionSlider: UISlider = {
        let v = UISlider(frame: .zero)
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
        self.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
            $0.height.equalTo(44)
        }

        headerView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }

        self.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(8)
        }

        self.addSubview(totalTimeLabel)
        totalTimeLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-8)
        }

        self.addSubview(playingPositionSlider)
        playingPositionSlider.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(currentTimeLabel.snp.bottom).offset(10)
        }
    }
}
