//
//  Basket.swift
//  iOSshopTestApp
//
//  Created by Elias on 20/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import UIKit
import SQLite

class BasketVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var db : Connection!
    public var itemList : [Element] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = DataBase.getDataConnection()
        setTitleLogo(navigationItem: navigationItem)
        //Crutch :(
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            itemList = Adapter.getOnlyFavArray(elementList: itemList, dataBase: db)
            tableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElementCell2") as! ElementCell
        cell.setElement(element: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemList[indexPath.row]
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        vc?.element = item
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    public func setTitleLogo( navigationItem : UINavigationItem ) {
        
        //Title View
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "         ", style: .plain, target: self, action: nil)
        let imageView = UIImageView(image: UIImage(named: "heart_white.png"))
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
}
