//
//  ElementCell.swift
//  tableTest
//
//  Created by Elias on 21/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell {
    
    @IBOutlet weak var imageOfProduct: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var shortDescr: UILabel!
    @IBOutlet weak var priceWithDiscount: UILabel!
    
    public func setElement(element: Element) {
        title.text = element.title
        price.attributedText = getStrikeText(text: "$ "+String(element.price))
        
        let discP = element.price-element.price/100*element.discount
        priceWithDiscount.text = "$ "+String(format: "%.1f", ceil(discP*10)/10)
        
        imageOfProduct.image = element.image
        shortDescr.text = element.shortDescr
        
    }
    
    public func getStrikeText(text : String) -> NSMutableAttributedString{
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    public func getAndSetImage(url: String, imageView: UIImageView) -> Void {
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)
        
        if(data != nil){
            imageView.image = UIImage(data: data!)!
        }
        
    }
}
