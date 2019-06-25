//
//  Elements.swift
//  tableTest
//
//  Created by Elias on 21/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import Foundation
import UIKit

public class Element {
    
    public var id: Int
    public var title : String
    public var price : Double
    public var discount : Double
    public var shortDescr : String
    public var urlOfImg : String
    public var image : UIImage = #imageLiteral(resourceName: "empty")
    public var fav : Bool = false
    
    init(id: Int,title: String, price: Double, discount: Double, shortDescr: String, urlOfImg: String) {
        self.id = id
        self.title = title
        self.price = price
        self.discount = discount
        self.shortDescr = shortDescr
        self.urlOfImg = urlOfImg
        
        let url = URL(string: urlOfImg)
        let data = try? Data(contentsOf: url!)
        
        if(data != nil){
            self.image = UIImage(data: data!)!
        }
        
    }
}

