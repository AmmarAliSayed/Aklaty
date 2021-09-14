//
//  WelcomeViewController.swift
//  Aklaty
//
//  Created by Macbook on 14/07/2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
    }
    

   

}
