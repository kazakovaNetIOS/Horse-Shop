//
//  ProductDetailController.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProductDetailController: UIViewController {

    var displayProduct: Product!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = displayProduct.title
        manufacturerLabel.text = displayProduct.title
        priceLabel.text = "₽\(displayProduct.price)"
    }
}
