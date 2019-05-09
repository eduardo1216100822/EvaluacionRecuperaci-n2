//
//  TVCMp3List.swift
//  MyStoreMusic
//
//  Created by Jose Carlos Rodriguez on 5/1/19.
//  Copyright © 2019 Jose Carlos Rodriguez. All rights reserved.
//

import UIKit

class TVCMp3List: UITableViewCell {
    
    @IBOutlet weak var lblSong: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblRating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
