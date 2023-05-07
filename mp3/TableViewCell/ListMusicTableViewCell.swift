//
//  ListMusicTableViewCell.swift
//  mp3
//
//  Created by Thinh on 30/03/2023.
//

import UIKit

class ListMusicTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var buttonPostBy: UIButton!
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var labelNameSinger: UILabel!
    @IBOutlet weak var labelNameMusic: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
