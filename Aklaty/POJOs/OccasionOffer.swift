//
//  OccasionOffer.swift
//  Aklaty
//
//  Created by Macbook on 12/08/2021.
//

import Foundation

class OccasionOffer {
    var id :String!
    var offerDiscription :String!
    var discountRate :Int!
    var vaildTime:String!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary:NSDictionary) {
        id = _dictionary[K.OccasionOfferFStore.occasionOfferIdField] as? String
        offerDiscription = _dictionary[K.OccasionOfferFStore.offerDiscriptionField] as? String
        imageLinks = _dictionary[K.OccasionOfferFStore.imagesLinksField] as? [String]
        discountRate = _dictionary[K.OccasionOfferFStore.discountRateField] as? Int
        vaildTime = _dictionary[K.OccasionOfferFStore.vaildTimeField] as? String
    }
    
}
