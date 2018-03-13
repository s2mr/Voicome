//
//  VoiAPI.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

let VoiProvider = MoyaProvider<VoiAPI>(plugins: [NetworkLoggerPlugin(
    verbose: true, cURL: true)])

let VoiStubProvider = MoyaProvider<VoiAPI>(endpointClosure: { (target: VoiAPI) -> Endpoint in
    let url = URL(target: target).absoluteString
    return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
})

enum VoiAPI {
    case programList(channelId: Int, limit: Int, type_id: Int)
    case articleList(channelId: Int, pId: Int)
    case voiceData(voice: VoicyResponse.VoiceData)
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
        case .voiceData(let voice):
            return "/voice/\(voice.voiceFile)"
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
        case .programList:
            let path = Bundle.main.path(forResource: "ProgramList", ofType: "json")!
            print(path)
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        default:
            return "".data(using: .utf8)!
        }
    }

    var task: Task {
        switch self {
        case .voiceData(let voice):
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let directoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
                let fileURL = directoryURL.appendingPathComponent("/Downloaded/\(voice.speakerName ?? "unknown")/\(voice.playlistName ?? "unknown")/\(voice.voiceIndex ?? 0).\(voice.articleTitle).mpeg")

                print("Downloaded", fileURL.absoluteString)

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            return Task.downloadDestination(destination)
        default:
            guard let parameters = parameters else { return .requestPlain }
            return Task.requestParameters(parameters: parameters, encoding: URLEncoding.methodDependent)
        }
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

extension Single where Element == Moya.Response {
    func mapTo<B: Codable>(object classType: B.Type) -> Single<B> {
        return self.asObservable().map { response in
            do {
                return try JSONDecoder().decode(classType, from: response.data)
            } catch (let e) {
                throw e
            }
            }.asSingle()
    }
}
