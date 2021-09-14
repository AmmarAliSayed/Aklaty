//
//  User.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import Foundation

class User {
    var userId: String!
    var email: String!
    var phone : String!
    var name: String!
    var imageLinks : [String]!
   
    
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        userId = (_dictionary[K.UsersFStore.userIdField] as? String)
        email = (_dictionary[K.UsersFStore.emailField] as? String)
        phone = (_dictionary[K.UsersFStore.phoneField] as? String)
        name = (_dictionary[K.UsersFStore.userNameField] as? String)
        imageLinks = (_dictionary[K.UsersFStore.imageLinksField] as? [String])
    }
    
    }
