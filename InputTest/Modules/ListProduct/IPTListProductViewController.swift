//
//  IPTMainViewController.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import RxSwift
import RxRelay
import KRProgressHUD

class IPTListProductViewController: BaseViewController {
    
    @IBOutlet weak var listProductTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var colors: [IPTColorModel] = []
    var listProducts: [IPTProductModel] = []
    var listProductsDisplay: [IPTProductModel] = []
    var indexProductChanged: Set<Int> = []
    var pageIndex: Int = 0
    let numberPagination: Int = 10
    var isPaginating = true
    var isFirstTimeLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.obserserValueChanged()
        self.registerNib()
        self.initUI()
    }

    private func initData() {
        IPTColorManager.getInstance.fetchColors()
        IPTProductManager.getInstance.fetchProducts()
    }
    
    private func initUI() {
        self.title = "List Products"
        self.submitButton.roundCorners(corners: [.topRight, .topLeft, .bottomRight, .bottomLeft], amount: 8)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        self.listProductTableView.refreshControl = refreshControl
    }
    
    private func obserserValueChanged() {
        IPTProductManager.getInstance.products.asObservable().subscribe { (products) in
            self.listProducts = products.element ?? []
            if self.listProducts.count != 0 && self.isFirstTimeLoad {
                self.fetchProduct()
                self.isFirstTimeLoad = false
            }
        }.disposed(by: self.disposeBag)
        IPTProductManager.getInstance.productsDisplay.asObservable().subscribe { (displayProducts) in
            self.setEmptyView(tableView: self.listProductTableView, data: self.listProductsDisplay, text: "Data was empty")
            self.listProductTableView.reloadData()
        }.disposed(by: self.disposeBag)
    }
    
    private func fetchProduct() {
        if listProducts.count / 10 + 1 > self.pageIndex {
            self.pageIndex += 1
            self.listProductsDisplay.append(contentsOf: (self.listProducts.filter({ product in
                product.id <= self.pageIndex * self.numberPagination &&
                product.id > (self.pageIndex - 1) * self.numberPagination
            })))
            IPTProductManager.getInstance.productsDisplay.accept(self.listProductsDisplay)
        }
    }
    
    private func registerNib() {
        self.listProductTableView.register(UINib(nibName: IPTListProductTableViewCell.identifier, bundle: Bundle.main),
                                           forCellReuseIdentifier: IPTListProductTableViewCell.identifier)
    }
    
    @objc func editAction(_ sender: UIButton) {
        if #available(iOS 15.0, *) {
            IPTProductManager.getInstance.fetchProducts()
            self.navigationController?.pushViewController(viewController: IPTEditProductViewController(productModel: self.listProductsDisplay[sender.tag],
                                                                                                       originModel: IPTProductManager.getInstance.productsOrigin[sender.tag],
                                                                                                       completion: { (model, isDifferentFromOrigin) in
                if isDifferentFromOrigin {
                    self.indexProductChanged.insert(model.id)
                } else {
                    self.indexProductChanged.remove(model.id)
                }
                self.listProductsDisplay[sender.tag] = model
                self.listProductTableView.reloadData()
            }), animated: true, completion: nil)
        } else {
            
        }
    }
    
    @objc func refreshAction(refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            self.listProductTableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        let vc = IPTShowResultViewController(results: IPTProductManager.getInstance.productsDisplay.value )
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}

extension IPTListProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listProductsDisplay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IPTListProductTableViewCell.identifier, for: indexPath) as! IPTListProductTableViewCell
        cell.config(productModel: self.listProductsDisplay[indexPath.row])
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return cell
    }
}

extension IPTListProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.listProductTableView.contentSize.height - 150 - scrollView.frame.size.height < scrollView.contentOffset.y {
            if self.isPaginating {
                self.isPaginating = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.fetchProduct()
                    self.listProductTableView.reloadData()
                    self.isPaginating = true
                    return
                })
            }
        }
    }
}
