//
//  JKArticleTableViewCell.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/28.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var labForName: UILabel!
    @IBOutlet weak var imgVForIcon: UIImageView!
    @IBOutlet weak var labForReadNum: UILabel!
    @IBOutlet weak var imgVForType: UIImageView!

    var model: JKArticleModel? {
        didSet {
            guard let model = self.model else { return }
            self.labForName.text = model.articleName
            self.labForReadNum.text = "\(model.readNum)"
            self.imgVForIcon.kfCache(model.imageUrl, placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
