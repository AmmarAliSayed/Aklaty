//
//  PasswordVisibility.swift
//  Aklaty
//
//  Created by Macbook on 06/09/2021.
//

import Foundation
import UIKit


struct PasswordVisibility {
    
    
    static func insertEyeIcon(textfield: UITextField, systemImage: String) -> (button: UIButton, image: String){ //() { //
        
        
        let button = UIButton(type: .custom)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: systemImage), for: .normal)
        } else {
            print("systemName: is only available in iOS 13.0 or newer")
        }
        
        if systemImage == "eye.slash"{
            textfield.isSecureTextEntry = true
        }else{
            textfield.isSecureTextEntry = false
        }
        
        
        button.tintColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        textfield.rightView = button
        textfield.rightViewMode = .always
        
        return (button, systemImage)
    }
    
}
