//
//  PictureInputCell.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/10.
//

import Foundation
import UIKit

class PictureInputCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
