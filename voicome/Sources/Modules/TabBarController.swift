//
//  NavigationController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/12.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    private let showDonloadingListButton: UIButton = {
        let v = UIButton(frame: .zero)
        v.setTitle("Downloading", for: .normal)
        v.layer.cornerRadius = 30
        v.layer.masksToBounds = true
        v.backgroundColor = .blue
        return v
    }()

    private let playerView: PlayerView = {
        let v = PlayerView(frame: .zero)
        return v
    }()

    override func loadView() {
        super.loadView()

        self.view.addSubview(showDonloadingListButton)
        showDonloadingListButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-100)
            $0.size.equalTo(60)
        }

        self.view.addSubview(playerView)
        playerView.snp.makeConstraints { [weak self] in
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
