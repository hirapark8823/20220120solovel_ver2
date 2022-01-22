//
//  houseViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/06.
//

import UIKit

class houseViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!
    
    let data = [
        ["ゲストハウス名"],
        ["写真"],
        ["金額", "日本語対応", "投稿者"],
        ["情報交換ノート"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        let header = UIView(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: 50))
        let footer = UIView(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: 50))

        header.backgroundColor = .gray
        footer.backgroundColor = .gray
        
        let label = UILabel(frame: header.bounds)
        label.text = "Solo Vel -Guest House View-"
        label.textAlignment = .center
        label.textColor = .black
        header.addSubview(label)
        
        tableview.tableHeaderView = header
        tableview.tableFooterView = footer        
    }
}


extension houseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension houseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
//        cell.backgroundColor = .green
        return cell
    }
}

