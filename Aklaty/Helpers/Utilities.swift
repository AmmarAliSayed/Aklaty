//
//  Utilities.swift
//  Aklaty
//
//  Created by Macbook on 21/07/2021.
//

import Foundation
import UIKit
class Utilities {
    
    static func makeViewRounded (view : UIView,cornerRadius :CGFloat,color : CGColor) {
        //make view rounded
        view.layer.cornerRadius = view.frame.size.width/cornerRadius
        view.layer.borderWidth = 2.0
        view.layer.borderColor = color
//        view.layer.cornerRadius = view.frame.size.width/10
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    static func makeViewRounded2 (_ view : UIView) {
        //make view rounded
        view.layer.cornerRadius = view.frame.size.width/20
        view.layer.borderWidth = 2.0
        view.layer.borderColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
      
    }
}
