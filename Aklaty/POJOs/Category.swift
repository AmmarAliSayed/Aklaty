//
//  Category.swift
//  Aklaty
//
//  Created by Macbook on 28/07/2021.
//

import Foundation

class Category {
    var id :String!
    var name :String!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary:NSDictionary) {
        id = _dictionary[K.CategoryFStore.categoryIdField] as? String
        name = _dictionary[K.CategoryFStore.categoryNameField] as? String
        imageLinks = _dictionary[K.CategoryFStore.imagesLinksField] as? [String]
    }
    
}

//MARK: Helper functions

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id,category.name, category.imageLinks], forKeys: [K.CategoryFStore.categoryIdField as NSCopying, K.CategoryFStore.categoryNameField as NSCopying, K.CategoryFStore.imagesLinksField as NSCopying])
}

