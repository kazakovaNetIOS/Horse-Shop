//
//  ProductEditController.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 02/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ProductEditDelegate {
    func productWillSave()
}

class ProductEditController: UIViewController {

    var store: Store!
    var delegate: ProductEditDelegate!
    
    private let pickerController = UIImagePickerController()
    private var imageUrl: NSURL?
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObserver()
    }
}

//MARK: - Setup UI
extension ProductEditController {
    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pictureTapped(tapGestureRecognizer:)))
        pictureImageView.isUserInteractionEnabled = true
        pictureImageView.addGestureRecognizer(tapGestureRecognizer)
        
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        priceTextField.delegate = self
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        descriptionTextView.layer.cornerRadius = 5
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    private func addObserver() {
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

//MARK: - UITextFieldDelegate
extension ProductEditController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        return string == filtered
    }
}

//MARK: - Selector methods
extension ProductEditController {
    @objc func saveButtonTapped(_ sender: UIButton) {
        var price = 0.0
        if let inputPrice = Double(priceTextField.text!) {
            price = inputPrice
        }
        
        let newProduct = Product(title: titleTextField.text!,
                                 price: price,
                                 manufacturer: manufacturerTextField.text!,
                                 image: nil,
                                 description: descriptionTextView.text)
        
        let saveProduct = SaveProductOperation(product: newProduct, store: store, imageUrl: imageUrl, fileQueue: OperationQueue(), imageQueue: OperationQueue())
        saveProduct.completionBlock = {
            OperationQueue.main.addOperation {
                self.delegate.productWillSave()
            }            
        }
        
        OperationQueue().addOperation(saveProduct)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pictureTapped(tapGestureRecognizer: UITapGestureRecognizer) {        
        present(pickerController, animated: true, completion: nil)
    }
}


//MARK: - Keyboard methods
extension ProductEditController {
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

//MARK: - UIImagePickerControllerDelegate
extension ProductEditController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imageUrl = pickedImageURL
            pictureImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UINavigationControllerDelegate
extension ProductEditController: UINavigationControllerDelegate {
    
}
