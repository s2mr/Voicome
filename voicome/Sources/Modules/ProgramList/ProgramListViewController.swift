//
//  ProgramListViewController.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProgramListViewController: UIViewController {

    static func instantiate(user: User) -> ProgramListViewController {
        let vc = ProgramListViewController(viewModel: ProgramListViewModel(user: user))
        return vc
    }

    private let viewModel: ProgramListViewModel
    private let disposeBag = DisposeBag()

    private let contentView = ProgramListView(frame: .zero)

    private init(viewModel: ProgramListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

    func subscribe() {
        let input = ProgramListViewModel.Input(viewWillAppear: self.rx.viewWillAppear.asDriver())
        let output = viewModel.translate(from: input)

        output.playlists.asDriver()
            .drive(contentView.tableView.rx.items) ({ (tableView, row, playlist) -> UITableViewCell in
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel!.text = playlist.playlistName
                return cell
            })
            .disposed(by: disposeBag)

        contentView.tableView.rx.modelSelected(VoicyResponse.PlaylistData.self)
            .subscribe(onNext: { model in
                AppRouter.shared.route(to: .playlist(program: model), from: self)
            }).disposed(by: disposeBag)
    }
}

