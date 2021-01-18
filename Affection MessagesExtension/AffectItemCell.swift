//
//  AffectItemCell.swift
//  Affection MessagesExtension
//
//  Created by Roman Pshichenko on 1/17/21.
//

import UIKit
import Messages

class AffectItemCell: UICollectionViewCell {
    static let reuseId = "stickerCell"
    var affectItem: Affect?
    
    @IBOutlet weak var stickerView: MSStickerView!
}

class AddAffectItemCell: UICollectionViewCell {
    static let reuseId = "addAffectCell"
    
    @IBOutlet weak var imageView: UIImageView!
}
