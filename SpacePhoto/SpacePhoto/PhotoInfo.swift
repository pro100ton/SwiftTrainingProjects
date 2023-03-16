//
//  PhotoInfo.swift
//  SpacePhoto
//
//  Created by Антон Шалимов on 15.03.2023.
//

import Foundation

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}
