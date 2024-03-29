//
//  ViewController.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ProductListController: UIViewController {

    @IBOutlet weak var productListTableView: UITableView!
    
    private let store = Store()
    private var selectedProduct: Product?
    private let reuseIdentifier = "product cell"
    
    private var products: [Product] = [] {
        didSet {
            guard products.count > 0 else { return }
            
            products.sort(by: { $0.title < $1.title })
        }
    }
}

//MARK: - UITableViewDataSource
extension ProductListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.row]
        
        cell.titleLabel?.text = product.title
        cell.manufacturerLabel?.text = product.manufacturer
        cell.priceLabel?.text = "₽\(product.price)"
        
        if let image = product.image {
            cell.pictureImageView.image = UIImage(named: image)
        } else {
            cell.pictureImageView.image = UIImage(named: "noimage")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedProductId = products[indexPath.row].uid
            
            let removeProduct = RemoveProductFileOperation(productId: deletedProductId, store: store)
            removeProduct.completionBlock = {
                OperationQueue.main.addOperation {
                    self.products.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            
            OperationQueue().addOperation(removeProduct)
        }
    }
}

//MARK: - UITableViewDelegate
extension ProductListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        
        performSegue(withIdentifier: "goToProduct", sender: self)
    }
}

//MARK: - Override methods
extension ProductListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        
        productListTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProducts {
            super.viewWillAppear(animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProduct",
            let productDetail = segue.destination as? ProductDetailController {
            productDetail.displayProduct = selectedProduct
        }
        
        if segue.identifier == "goToEditProduct",
            let productEdit = segue.destination as? ProductEditController {
            productEdit.store = store
            productEdit.delegate = self
        }
    }
}

//MARK: - Selector methods
extension ProductListController {
    @objc func addButtonTapped(_ sender: UIButton) {
        print("Switch to product editing")
        
        self.performSegue(withIdentifier: "goToEditProduct", sender: self)
    }
}

//MARK: - Data load
extension ProductListController {
    fileprivate func loadProducts(completion: @escaping ()->Void) {
        let loadProducts = LoadProductsFileOperation(store: store)
        loadProducts.completionBlock = {
            print("Downloading products completed. Uploaded \(loadProducts.result?.count ?? 0) products")
            
            if let loadedProducts = loadProducts.result {
                self.products = loadedProducts
            }
            
            OperationQueue.main.addOperation {
                print("Updating the table after loading data")
                
                self.productListTableView.reloadData()
                
                completion()
            }
        }
        
        OperationQueue().addOperation(loadProducts)
    }
}

//MARK: - ProductEditDelegate
extension ProductListController: ProductEditDelegate {
    func productWillSave() {
        loadProducts {
            print("Product added to list")
        }
    }
}
