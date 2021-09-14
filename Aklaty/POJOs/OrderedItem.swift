//
//  OrderedItem.swift
//  Aklaty
//
//  Created by Macbook on 01/09/2021.
//

import Foundation
class OrderedItem {
    var id: String!
    var name: String!
    var time: String!
    var description: String!
    var price: Double!
    var calories: Int!
    var numOfOrders: Int!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.OrderedItemFStore.itemIdField] as? String
        name = _dictionary[K.OrderedItemFStore.ItemNameField] as? String
        imageLinks = _dictionary[K.OrderedItemFStore.imageLinksField] as? [String]
        description = _dictionary[K.OrderedItemFStore.description] as? String
        calories = _dictionary[K.OrderedItemFStore.caloriesField] as? Int
        price = _dictionary[K.OrderedItemFStore.priceField] as? Double
        time = _dictionary[K.OrderedItemFStore.timeField] as? String
        numOfOrders = _dictionary[K.OrderedItemFStore.ordersNumber] as? Int
    }
}
