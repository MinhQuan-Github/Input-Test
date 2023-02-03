//
//  IPTMainViewController.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import KRProgressHUD

class IPTListProductViewController: BaseViewController {
    
    @IBOutlet weak var listProductTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    private func initUI() {
        
    }
    
    private func registerNib() {
        listProductTableView.register(UINib(nibName: IPTListProductTableViewCell.identifier, bundle: Bundle.main),
                                      forCellReuseIdentifier: "IPTListProductTableViewCell")
    }
}

extension IPTListProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
