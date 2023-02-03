//
//  IPTShowResultViewController.swift
//  InputTest
//
//  Created by Minh Quan on 07/01/2023.
//

import UIKit

class IPTShowResultViewController: BaseViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var results: [IPTProductModel]!
    
    convenience init(results: [IPTProductModel]) {
        self.init()
        self.results = results
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.initUI()
    }
    
    func registerNib() {
        self.resultTableView.register(UINib(nibName: IPTListProductTableViewCell.identifier, bundle: Bundle.main),
                                      forCellReuseIdentifier: IPTListProductTableViewCell.identifier)
    }
    
    func initUI() {
        self.okButton.roundCorners(corners: [.topRight, .topLeft, .bottomRight, .bottomLeft], amount: 8)
        self.emptyLabel.isHidden = false
        if self.results.isEmpty {
            self.resultTableView.isHidden = true
        }
    }
    
    @IBAction func OKTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension IPTShowResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IPTListProductTableViewCell.identifier, for: indexPath) as! IPTListProductTableViewCell
        cell.config(productModel: self.results[indexPath.row], showEdit: false)
        return cell
    }
}
