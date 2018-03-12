//
//  NavigationController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/12.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    private let showDonloadingListButton: UIButton = {
        let v = UIButton(frame: .zero)
        v.setTitle("Downloading", for: .normal)
        v.layer.cornerRadius = 30
        v.layer.masksToBounds = true
        v.backgroundColor = .blue
        return v
    }()

    override func loadView() {
        super.loadView()

        self.view.addSubview(showDonloadingListButton)
        showDonloadingListButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-55)
            $0.size.equalTo(60)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
