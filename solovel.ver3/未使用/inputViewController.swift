//
//  inputViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/06.
//

//import Foundation
import UIKit
import Firebase

enum InputViewSectionType {
    case name
    case area
    case value
    case note
    case picture
}

class inputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    

    @IBOutlet weak var registerBtn: UIButton!
    
    
    let sectionType: [InputViewSectionType] = [
        .name,
        .area,
        .value,
        .note,
        .picture
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
//        tableview.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        tableview.register(UINib(nibName: "GuesthouseInputCell", bundle: nil), forCellReuseIdentifier: "GuesthouseInputCell")
        tableview.register(UINib(nibName: "AreaInputCell", bundle: nil), forCellReuseIdentifier: "AreaInputCell")
        tableview.register(UINib(nibName: "ValueInputCell", bundle: nil), forCellReuseIdentifier: "ValueInputCell")
        tableview.register(UINib(nibName: "NoteInputCell", bundle: nil), forCellReuseIdentifier: "NoteInputCell")
        tableview.register(UINib(nibName: "PictureInputCell", bundle: nil), forCellReuseIdentifier: "PictureInputCell")
    
        
        let header = UIView(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: 50))
        let footer = UIView(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: 70))

        header.backgroundColor = .lightGray
        footer.backgroundColor = .lightGray
        
        let label = UILabel(frame: header.bounds)
        label.text = "Solo Vel -Input View-"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 28)
        header.addSubview(label)
        
        tableview.tableHeaderView = header
        tableview.tableFooterView = footer
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionType.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = sectionType[indexPath.row]
        
        switch type {
            case .name:
            return tableView.dequeueReusableCell(withIdentifier: "GuesthouseInputCell", for: indexPath) as! GuesthouseInputCell
            
        case .area:
        return tableView.dequeueReusableCell(withIdentifier: "AreaInputCell", for: indexPath) as! AreaInputCell
            
        case .value:
        return tableView.dequeueReusableCell(withIdentifier: "ValueInputCell", for: indexPath) as! ValueInputCell
            
        case .note:
        return tableView.dequeueReusableCell(withIdentifier: "NoteInputCell", for: indexPath) as! NoteInputCell
            
        case .picture:
        return tableView.dequeueReusableCell(withIdentifier: "PictureInputCell", for: indexPath) as! PictureInputCell
            
//        default: //kari
//            return tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        }
    }
}
