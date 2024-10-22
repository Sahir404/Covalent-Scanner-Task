//
//  ResultViewController.swift
//  covalent scanner demo
//
//  Created by MAC on 22/10/2024.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDataSource {

    var resultData: [String: String] = [:]

    @IBOutlet weak var resultTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetup()
        
    }
    func tableViewSetup() {
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        resultTableView.rowHeight = UITableView.automaticDimension
        resultTableView.estimatedRowHeight = 60 
        resultTableView.dataSource = self
        resultTableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "ResultCell")
        
        
        let keys = Array(resultData.keys)
        let key = keys[indexPath.row]
        let value = resultData[key] ?? "N/A"
//        cell.detailTextLabel?.textColor = .black

        cell.textLabel?.text = key
        if let detailLabel = cell.detailTextLabel {
            print("Detail Text Label exists")
            detailLabel.text = value
        } else {
            print("Detail Text Label is nil")
        }

        return cell
    }
}
