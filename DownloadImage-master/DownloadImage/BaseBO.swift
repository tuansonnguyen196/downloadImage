//
//  BaseBO.swift
//  Examination1
//
//  Created by Nero on 10/2/20.
//  Copyright © 2020 NHK. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseBO: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {}
}

class ImageBO: BaseBO {
    var albumId = 0
    var id = 0
    var title = ""
    var url = ""
    var thumbnailUrl = ""
    
    override func mapping(map: Map) {
        albumId <- map["albumId"]
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        thumbnailUrl <- map["thumbnailUrl"]
    }
}
