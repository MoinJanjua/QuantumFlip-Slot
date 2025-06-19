//
//  ScoresTableViewCell.swift
//  Jackpot Slots
//
//  Created by Unique Consulting Firm on 10/01/2025.
//

import UIKit

class ScoresTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLb:UILabel!
    @IBOutlet weak var usernameLb:UILabel!
    @IBOutlet weak var scorelb:UILabel!
    @IBOutlet weak var profileImageView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.clipsToBounds = true
            profileImageView.layer.masksToBounds = true // Ensures clipping is applied
        }

        // Initialization code
    }

struct Score {
    let username: String
    let score: Int
}
