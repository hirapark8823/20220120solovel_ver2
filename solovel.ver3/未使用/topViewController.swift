//
//  topViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2021/12/22.
//

import UIKit

class topViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var guestHouse: [guesthouse] = []
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todoufukenBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    
//    let areaList = [
//            "北海道","青森","秋田","岩手",
//            "山形","宮城","福島","新潟",
//            "栃木","群馬","茨城","埼玉",
//            "千葉","神奈川","東京","山梨","長野","静岡","富山","石川","福井","愛知","三重","岐阜","滋賀","京都","奈良","大阪","和歌山","兵庫","岡山","広島","鳥取","島根","山口","徳島","香川","高知","愛媛","福岡","佐賀","長崎","熊本","大分","宮崎","鹿児島","沖縄"
//        ]
    
    
//    var guesthouse = ["うずまきゲストハウス", "リトルアジア", "京町ゲストハウス", "高山ユースホステル", "Golden Mile Hostel"]
    
//テーブルビューコード
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        
        loadData()
        }
    
    func loadData(){
        guestHouse.append(guesthouse(houseName:"うずまきゲストハウス", imageName:"うずまき"))
        guestHouse.append(guesthouse(houseName:"リトルアジア", imageName:"リトルアジア"))
        guestHouse.append(guesthouse(houseName:"京町ゲストハウス", imageName:"京町"))
        guestHouse.append(guesthouse(houseName:"高山ユースホステル", imageName:"高山"))
        guestHouse.append(guesthouse(houseName:"Golden Mile Hostel", imageName:"Golden"))
    }
    
    //リストの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestHouse.count
        }
    
//    table view cellの高さ設定
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 300
//        }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
//        cell.img.image = UIImage(systemName: "swift")
////            cell.label.text = "Swift"
//        return cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        //let cell = myTableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            fatalError("Dequeue failed: MainTableViewCell.")
        }
        
        cell.button.setTitle(guestHouse [indexPath.row].houseName, for: .normal)
        cell.img.image = UIImage(named: guestHouse [indexPath.row].imageName)

        return cell

    }
}

//ピッカービューコード
