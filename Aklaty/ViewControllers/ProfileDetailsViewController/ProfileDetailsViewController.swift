//
//  ProfileDetailsViewController.swift
//  Aklaty
//
//  Created by Macbook on 02/09/2021.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logOutButtonOutlet: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    //MARK: - Vars
    var userDetailsViewModel : UserDetailsViewModel!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.masksToBounds = true
        //make button rounded
        logOutButtonOutlet.layer.cornerRadius = 10
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //show tab bar
        self.tabBarController?.tabBar.isHidden = false
         userDetailsViewModel = UserDetailsViewModel()
        userDetailsViewModel.bindUserDetailsViewModelToView = {
            self.updateuserDetails()
            }
        
        userDetailsViewModel.shouldReturnToWelcomeView = {
            //self.performSegue(withIdentifier: "segFromProfileToWelcome", sender: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
              //  self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    //MARK: - IBActions
        @IBAction func editButtonPressed(_ sender: Any) {
            self.performSegue(withIdentifier: "fromProfileToEditSegue", sender: nil)
        }
        
        @IBAction func logOutButtonPressed(_ sender: Any) {
            userDetailsViewModel.logOutUser()
        }

    //MARK: - helper functions
    func updateuserDetails(){
        nameLabel.text = userDetailsViewModel.userData.name
        phoneLabel.text = userDetailsViewModel.userData.phone
        emailLabel.text = userDetailsViewModel.userData.email
        
        if (userDetailsViewModel.userData.imageLinks.count) > 0 {
            downloadImagesFromFirebase(imageUrls:[(userDetailsViewModel.userData.imageLinks.first!)]) { (images) in
                DispatchQueue.main.async { [self] in
                    userImageView.image = images.first as? UIImage
                }
            }
        }
       
    }
}
