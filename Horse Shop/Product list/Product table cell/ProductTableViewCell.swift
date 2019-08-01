//
//  ProductTableViewCell.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var cellWrapperView: UIView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellWrapperView.layer.cornerRadius = 5
//        pictureImageView.contentMode = .scaleAspectFit
    }
}
