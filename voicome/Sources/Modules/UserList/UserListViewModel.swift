//
//  UserListViewModel.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation

class UserListViewModel {

    let users: [User]

    init() {
        users = [User(name: "井上たくみ", channelId: 588),
                 User(name: "はあちゅう", channelId: 583),
                 User(name: "出社前に5分間でインプット♡", channelId: 471),
                 User(name: "ベンチャーニュースで言いたい放題", channelId: 32),
                 User(name: "#今夜もよく眠れるギークな話", channelId: 458),
                 User(name: "イケハヤ仮想通貨ラジオ", channelId: 585),
                 User(name: "勝手にENGLISH JOURNAL!", channelId: 567),
                 User(name: "Voicy公式経済総合ニュース", channelId: 95),
                 User(name: "公式ITビジネスニュース", channelId: 480),
                 User(name: "仮想通貨・ICOについて議論！", channelId: 545),

        ]
    }
    
}
