//
//  AppRouter.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/12.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import UIKit

public protocol Router {
    associatedtype RootViewController: UIViewController
    associatedtype Location

    var rootViewController: RootViewController! { get }

    func route(to location: Location, from: UIViewController?)
}

class AppRouter: Router {

    typealias RootViewController = UINavigationController

    enum Location {
        case userList
        case programList(user: User)
        case playlist(program: VoicyResponse.PlaylistData)
    }

    static var shared = AppRouter()

    var rootViewController: RootViewController! = {
        let vc = UserListViewController.instanciate()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }()

    func route(to location: AppRouter.Location, from: UIViewController?) {
        switch location {
        case .userList:
            rootViewController.setViewControllers([UserListViewController.instanciate()], animated: false)
        case .programList(let user):
            let vc = ProgramListViewController.instantiate(user: user)
            rootViewController.pushViewController(vc, animated: true)
        case .playlist(let program):
            let vc = PlaylistViewController.instanciate(program: program)
            rootViewController.pushViewController(vc, animated: true)
        }
    }
}

