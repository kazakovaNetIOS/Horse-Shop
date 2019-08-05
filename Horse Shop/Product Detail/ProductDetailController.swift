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
    @IBOutlet weak var descriptionWrapperView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        pictureImageView.layer.cornerRadius = 5
        
        descriptionWrapperView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionWrapperView.layer.borderWidth = 1
        descriptionWrapperView.layer.cornerRadius = 5
        
        titleLabel.text = displayProduct.title
        manufacturerLabel.text = displayProduct.manufacturer
        priceLabel.text = "₽\(displayProduct.price)"
        descriptionTextView.text = displayProduct.description
        if let image = displayProduct.image {
            pictureImageView.image = UIImage(named: image)
        } else {
            pictureImageView.image = UIImage(named: "noimage")
        }
    }
}
