//
//  Offer.swift
//  Aklaty
//
//  Created by Macbook on 20/08/2021.
//

import Foundation
class Offer {
    var id :String!
    var name :String!
    var discountRate :Int!
    var time:String!
    var imageLinks: [String]!
    var price: Double!
    init() {
        
    }
    init(_dictionary:NSDictionary) {
        id = _dictionary[K.OfferFStore.offerIdField] as? String
        name = _dictionary[K.OfferFStore.offerNameField] as? String
        imageLinks = _dictionary[K.OfferFStore.imageLinksField] as? [String]
        discountRate = _dictionary[K.OfferFStore.discountRateField] as? Int
        time = _dictionary[K.OfferFStore.timeField] as? String
        price = _dictionary[K.OfferFStore.priceField] as? Double
    }
    
}
