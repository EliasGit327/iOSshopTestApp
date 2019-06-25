//
//  Adaptor.swift
//  iOSshopTestApp
//
//  Created by Elias on 23/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import Foundation
import SwiftyJSON
import SQLite

public class Adapter {

    public static func getElementsList(json: JSON ) -> [Element] {

        var elementArray : [Element] = []

        var i = 0
        
        while(i<json.count) {
            let id: Int = json[i]["id"].int!
            let title: String = json[i]["title"].string!
            let price: Double = json[i]["price"].double!
            let discount: Double = json[i]["sale_precent"].double!
            let shortDescr: String = json[i]["short_description"].string!
            let urlOfImg: String = json[i]["image"].string!

            let element = Element(id: id, title: title, price: price, discount: discount, shortDescr: shortDescr, urlOfImg: urlOfImg)
            
            elementArray.append(element)
            i+=1
        }
        
        
        return elementArray
    }
    
    public static func getOnlyFavArray( elementList : [Element], dataBase: Connection ) -> [Element] {
        
        var elementFavList : [Element] = []
        
        var i = 0
        
        while(i<elementList.count) {
         
            if(DataBase.checkIfFav( dataBase: dataBase, id: elementList[i].id ) ) {
                
                elementFavList.append(elementList[i])
            }
            
            i+=1
        }
        
        
        return elementFavList
    }
}
