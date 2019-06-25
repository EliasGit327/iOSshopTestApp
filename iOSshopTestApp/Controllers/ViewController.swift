//
//  ViewController.swift
//  iOSshopTestApp
//
//  Created by Elias on 19/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SQLite

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var db : Connection!
    var arrRes = JSON()
    var itemList: [Element] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = DataBase.getDataConnection()
        if(!DataBase.checkIfTablesExist(dataBase: db)) {
            DataBase.createFavTable(dataBase: db)
        }

        DataBase.printAllFav(dataBase: db)
        
        setTitleLogo(navigationItem: navigationItem)
        setupNavBar(navigationItem: navigationItem)
        
        getList(offset: 0, limit: 25)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//            tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElementCell") as! ElementCell
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
    
    @objc func userTapped(sender: UIButton) {
        //print("user")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserVC") as? UserVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func basketTapped(sender: UIButton) {
        //print("basket")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasketVC") as? BasketVC
        
        vc?.itemList = Adapter.getOnlyFavArray(elementList: itemList, dataBase: db)
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    public func setTitleLogo( navigationItem : UINavigationItem ) {
        
        //Title View
        let imageView = UIImageView(image: UIImage(named: "logo_transp.png"))
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    public func setupNavBar( navigationItem : UINavigationItem ) {
        
        //Custom Back Image
        //        let yourBackImage = UIImage(named: "back2_transp")
        //        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        //Left Button
        var button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "user_transp.png"), for: UIControl.State.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 34, height: 34)
        button.addTarget(self, action: #selector(ViewController.userTapped(sender:)), for: .touchUpInside)
        var barButton = UIBarButtonItem.init(customView: button)
        
        navigationItem.leftBarButtonItem = barButton
        
        //Right Button
        button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "heart_white.png"), for: UIControl.State.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 34, height: 34)
        button.addTarget(self, action: #selector(ViewController.basketTapped(sender:)), for: .touchUpInside)
        barButton = UIBarButtonItem.init(customView: button)
        
        navigationItem.rightBarButtonItem = barButton
    }
    
    
    //_______________________________________________________________________________
    func getList(offset: Int, limit: Int) {
        
        let parameters = "?offset=\(offset)&limit=\(limit)"
        let urlStr = "http://185.181.231.32:5000/products"+parameters
        
        //        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
        //
        //            print(response.value ?? "None")
        //        }
        
        Alamofire.request(urlStr).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                self.arrRes = swiftyJsonVar
                
                self.itemList = Adapter.getElementsList(json: swiftyJsonVar)
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    
}
