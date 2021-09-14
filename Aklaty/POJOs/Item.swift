//
//  Item.swift
//  Aklaty
//
//  Created by Macbook on 04/08/2021.
//

import Foundation
class Item {
    var id: String!
    var name: String!
    var time: String!
    var description: String!
    var price: Double!
    var calories: Int!
    //var reviews: [Review]!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.ItemFStore.itemIdField] as? String
        name = _dictionary[K.ItemFStore.ItemNameField] as? String
        imageLinks = _dictionary[K.ItemFStore.imageLinksField] as? [String]
        description = _dictionary[K.ItemFStore.description] as? String
        calories = _dictionary[K.ItemFStore.caloriesField] as? Int
        price = _dictionary[K.ItemFStore.priceField] as? Double
        time = _dictionary[K.ItemFStore.timeField] as? String
    }
}
