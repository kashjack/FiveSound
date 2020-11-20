//
//  JKHomePageModel.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKBannerModel: JKHandyJSON {
    var imageUrl: String = ""
}


class JKArticleModel: JKHandyJSON {
    var objectId: String = ""
    var articleName: String = ""
    var readNum: Int = 0
    var imageUrl: String = ""
    var articleType: String = ""
    var url: String = ""
}
