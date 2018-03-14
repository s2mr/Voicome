//
//  VoicyResponse.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation

struct VoicyResponse: Codable {

    struct VoiceData: Codable {
        let articleTitle: String
        let mediaName: String
        let voiceFile: String
        let voiceDuration: Int
        var voiceIndex: Int?
        var speakerName: String?
        var playlistName: String?

        private enum CodingKeys: String, CodingKey {
            case articleTitle = "ArticleTitle"
            case mediaName = "MediaName"
            case voiceFile = "VoiceFile"
            case voiceDuration = "VoiceDuration"
            case voiceIndex
            case speakerName
            case playlistName
        }
    }

    struct PlaylistData: Codable {
        private enum CodingKeys: String, CodingKey {
            case channelName = "ChannelName"
            case speakerName = "SpeakerName"
            case voiceDatas = "VoiceData"
            case playlistName = "PlaylistName"
        }

        let channelName: String
        let speakerName: String
        let playlistName: String
        let voiceDatas: [VoiceData]
    }

    struct PlaylistDatas: Codable {
        private enum CodingKeys: String, CodingKey {
            case playlistData = "PlaylistData"
        }

        let playlistData: [PlaylistData]
    }

    private enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
    let value: PlaylistDatas
}

