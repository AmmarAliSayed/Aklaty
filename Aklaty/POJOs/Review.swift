//
//  Review.swift
//  Aklaty
//
//  Created by Macbook on 03/08/2021.
//

import Foundation
class Review {
    var id :String!
    var itemId :String!
    var body :String!
    var userImageLinks: [String]!
    init() {
        
    }
    init(_dictionary:NSDictionary) {
        id = _dictionary[K.ReviewFStore.reviewId] as? String
        itemId = _dictionary[K.ReviewFStore.itemIDField] as? String
        body = _dictionary[K.ReviewFStore.bodyField] as? String
        userImageLinks = _dictionary[K.ReviewFStore.reviewImagesLinksField] as? [String]
        
    }
    
}
