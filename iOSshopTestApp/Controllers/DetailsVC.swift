//
//  DetailsVC.swift
//  iOSshopTestApp
//
//  Created by Elias on 23/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SQLite

class DetailsVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var priceWithDisc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var favButton: UIButton!
    
    var element : Element?
    var resurs : JSON?
    var db : Connection!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = DataBase.getDataConnection()
        
        setTitleLogo(navigationItem: navigationItem)
        getJson(id: element!.id)
        
        if(DataBase.checkIfFav(dataBase: db, id: element!.id)) {
            favButton.setImage(UIImage(named: "fav.png"), for: .normal)
        }
        
    
    }
    
    @IBAction func onFavButtonClickDo(_ sender: Any) {
        
        if(element?.fav == false) {
            element?.fav = true
            favButton.setImage(UIImage(named: "fav.png"), for: .normal)
            DataBase.addRow(dataBase: db, id: element!.id)
        } else {
            element?.fav = false
            favButton.setImage(UIImage(named: "empty_fav.png"), for: .normal)
            DataBase.deleteRow(dataBase: db, id: element!.id)
        }
    }
    
    func getJson(id: Int) {
        
        let parameters = "?id=\(id)"
        let urlStr = "http://185.181.231.32:5000/product"+parameters
        
        func getStrikeText(text : String) -> NSMutableAttributedString{
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            
            return attributeString
        }
        
        Alamofire.request(urlStr).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                self.resurs = swiftyJsonVar
                
                let url = URL(string: swiftyJsonVar["image"].string!)
                let data = try? Data(contentsOf: url!)
                
                if(data != nil){
                    self.imageView.image = UIImage(data: data!)!
                    self.titleLabel.text = swiftyJsonVar["title"].string!
                    self.shortDescription.text = swiftyJsonVar["short_description"].string!
                    
                    let price = swiftyJsonVar["price"].double!
                    let disc = swiftyJsonVar["sale_precent"].double!
                    let discP = price-price/100*disc
                    
                    self.price.attributedText = getStrikeText(text: "$ "+String(price))
                    self.priceWithDisc.text = "$ "+String(format: "%.1f", ceil(discP*10)/10)
                    
                    self.details.text = swiftyJsonVar["details"].string!
                    
                }
                
                
            }
        }
    }
    
    
    public func setTitleLogo( navigationItem : UINavigationItem ) {
        
        //Title View
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "         ", style: .plain, target: self, action: nil)
        let imageView = UIImageView(image: UIImage(named: "logo_transp.png"))
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
}
