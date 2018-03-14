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

    typealias RootViewController = TabBarController

    enum Location {
        case userList
        case programList(user: User)
        case playlist(program: VoicyResponse.PlaylistData)
        case downloadedList(url: URL)
    }

    static var shared = AppRouter()

    private static var exploreTab: UINavigationController = {
        let vc = UserListViewController.instanciate()
        vc.title = "Explore"
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }()

    private static var downloadedListTab: UINavigationController = {
        let vc = DownloadedListViewController.instanciate(url: FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent("/Downloaded"))
        vc.title = "Downloaded"
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }()

    var rootViewController: RootViewController! = {
        let tc = TabBarController()
        tc.addChildViewController(exploreTab)
        tc.addChildViewController(downloadedListTab)

        return tc
    }()

    func route(to location: AppRouter.Location, from: UIViewController?) {
        switch location {
        case .userList:
            rootViewController.setViewControllers([UserListViewController.instanciate()], animated: false)
        case .programList(let user):
            let vc = ProgramListViewController.instantiate(user: user)
            AppRouter.exploreTab.pushViewController(vc, animated: true)
        case .playlist(let program):
            let vc = PlaylistViewController.instanciate(program: program)
            AppRouter.exploreTab.pushViewController(vc, animated: true)
        case .downloadedList(let url):
            let vc = DownloadedListViewController.instanciate(url: url)
            AppRouter.downloadedListTab.pushViewController(vc, animated: true)
        }
    }
}

