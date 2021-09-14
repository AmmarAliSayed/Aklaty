//
//  OrderedOffer.swift
//  Aklaty
//
//  Created by Macbook on 13/09/2021.
//

import Foundation
class OrderedOffer {
    var id: String!
    var name: String!
    var time: String!
    var price: Double!
    var numOfOrders: Int!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.OrderedOfferFStore.itemIdField] as? String
        name = _dictionary[K.OrderedOfferFStore.ItemNameField] as? String
        imageLinks = _dictionary[K.OrderedOfferFStore.imageLinksField] as? [String]
        price = _dictionary[K.OrderedOfferFStore.priceField] as? Double
        time = _dictionary[K.OrderedOfferFStore.timeField] as? String
        numOfOrders = _dictionary[K.OrderedOfferFStore.ordersNumber] as? Int
    }
}
