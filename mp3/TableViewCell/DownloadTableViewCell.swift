//
//  DownloadTableViewCell.swift
//  mp3
//
//  Created by Thinh on 04/05/2023.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {

    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    @IBOutlet weak var lbSong: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
