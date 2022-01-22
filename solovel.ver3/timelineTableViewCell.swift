//
//  timelineTableViewCell.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/14.
//

import Foundation
import UIKit

class timelineTableViewCell: UITableViewCell, UITextViewDelegate {
 
    @IBOutlet var GHBtn : UIButton!
    @IBOutlet var userImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
