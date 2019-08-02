//
//  ProductEditController.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 02/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProductEditController: UIViewController {

    var store: Store!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        descriptionTextView.layer.cornerRadius = 5
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped(_:)))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowOrHide),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowOrHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

//MARK: - Selector methods
extension ProductEditController {
    @objc func saveButtonTapped(_ sender: UIButton) {
        guard let price = Double(priceTextField.text!) else {
            priceTextField.layer.borderWidth = 1
            priceTextField.layer.cornerRadius = 5
            priceTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        let newProduct = Product(title: titleTextField.text!,
                                 price: price,
                                 manufacturer: manufacturerTextField.text!,
                                 image: nil,
                                 description: descriptionTextView.text)
        
        let saveProduct = SaveProductFileOperation(product: newProduct, store: store)
        saveProduct.completionBlock = {
            OperationQueue.main.addOperation {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        OperationQueue().addOperation(saveProduct)
    }
    
    @objc private func keyboardWillShowOrHide(_ notification: Notification) {
        let keyBoard = notification.userInfo
        
        if let keyboardFrame = keyBoard?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            UIView.animate(withDuration: 1.0, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            })
        }
    }
}
