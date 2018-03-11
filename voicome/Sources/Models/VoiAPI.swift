//
//  VoiAPI.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import Moya

let VoiProvider = MoyaProvider<VoiAPI>()

enum VoiAPI {
    case programList(channelId: Int, limit: Int, type_id: Int)
    case articleList(channelId: Int, pId: Int)
    case voiceData(name: String)
}

extension VoiAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .voiceData:
            return URL(string: "https://files.voicy.jp")!
        default :
            return URL(string: "https://vmw.api.voicy.jp")!
        }
    }

    var path: String {
        switch self {
        case .programList:
            return "/program_list"
        case .articleList:
            return "/articles_list"
        case .voiceData(let name):
            return "/voice/\(name)"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        default:
            return "".data(using: .utf8)!
        }
    }

    var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        return Task.requestParameters(parameters: parameters, encoding: URLEncoding.methodDependent)
    }

    private var parameters: [String: Any]? {
        switch self {
        case .programList(let channelId, let limit, let typeId):
            return ["channel_id": channelId, "limit": limit, "type_id": typeId]
        case .articleList(let channelId, let pid):
            return ["channel_id": channelId, "pid": pid]
        case .voiceData:
            return nil
        }
    }

    var headers: [String : String]? {
        return nil
    }

}
