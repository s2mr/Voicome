//
//  VoicyResponse.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation

struct VoicyResponse: Codable {

    struct PlaylistDatas: Codable {

        struct PlaylistData: Codable {

            struct VoiceData: Codable {
                let articleTitle: String
                let mediaName: String
                let voiceFile: String

                private enum CodingKeys: String, CodingKey {
                    case articleTitle = "ArticleTitle"
                    case mediaName = "MediaName"
                    case voiceFile = "VoiceFile"
                }
            }

            private enum CodingKeys: String, CodingKey {
                case channelName = "ChannelName"
                case speakerName = "SpeakerName"
                case voiceData = "VoiceData"
            }

            let channelName: String
            let speakerName: String
            let voiceData: [VoiceData]
        }

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
