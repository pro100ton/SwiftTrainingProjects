//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Антон Шалимов on 05.02.2023.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Cell outlets
    @IBOutlet var descriptionOutlet: UILabel!
    @IBOutlet var nameOutlet: UILabel!
    @IBOutlet var symbolOutlet: UILabel!
    
    func update(with emoji: Emoji){
        symbolOutlet.text = emoji.symbol
        nameOutlet.text = emoji.name
        descriptionOutlet.text = emoji.description
    }
}
