//
//  PlayerView.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/13.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    let changePlayStateButton: UIButton = {
        let v = UIButton(frame: .zero)
        v.setTitle("▶", for: .normal)
        return v
    }()

    let playingTitleLabel: UILabel = {
        let v = UILabel(frame: .zero)
        v.textColor = .white
        v.numberOfLines = 0
        v.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        return v
    }()

    let playPrevButton: UIButton = {
        let v = UIButton(frame: .zero)
        v.setTitle("<", for: .normal)
        return v
    }()

    let playNextButton: UIButton = {
        let v = UIButton(frame: .zero)
        v.setTitle(">", for: .normal)
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
            $0.width.equalTo(20)
        }

        self.addSubview(playNextButton)
        playNextButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(10)
        }

        self.addSubview(playPrevButton)
        playPrevButton.snp.makeConstraints {
            $0.right.equalTo(playNextButton.snp.left).offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(10)
        }
        playPrevButton.sizeToFit()

        self.addSubview(playingTitleLabel)
        playingTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(changePlayStateButton.snp.right).offset(8)
            $0.right.equalTo(playPrevButton.snp.left).offset(-8)
        }
    }
}
