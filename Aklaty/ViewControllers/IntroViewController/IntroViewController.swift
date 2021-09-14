//
//  IntroViewController.swift
//  Maktabty
//
//  Created by Macbook on 05/05/2021.
//

import UIKit
import FirebaseAuth

class IntroViewController: UIViewController {
    //MARK:-> outlet
    
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
   
  //  @IBOutlet weak var pageController: UIPageControl!
   // @IBOutlet weak var nextButtonOutlet: UIButton!
    
    //MARK:-> properties
    
    var onBoardSlide:[IntroDataModel] = []
    var currentPage = 0 {
        didSet {
            pageController.currentPage = currentPage
            if currentPage == onBoardSlide.count - 1 {
               //nextButtonOutlet.setTitle("Get Started", for: .normal)
                nextButtonOutlet.setTitle("get Started", for: .normal)
            }
            else {
               // nextButtonOutlet.setTitle("Next", for: .normal)
                nextButtonOutlet.setTitle("Next", for: .normal)
            }
        }
    }
    
    
    //MARK:-> life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupCollectionView()
        assignValueToArray()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //MARK:-> class Methods
    
    func assignValueToArray() {
        onBoardSlide = [
            IntroDataModel(title: "Delicious Dishes", discreption: "Experience a variety of amazing dishes from different cultures around the world.", images: #imageLiteral(resourceName: "slide1")),
            IntroDataModel(title: "World-Class Chefs", discreption: "Our dishes are prepared by only the best.", images:#imageLiteral(resourceName: "slide2")),
            IntroDataModel(title: "Fast Delivery", discreption:  "Fast food delivery to your home, office wherever you are.", images: #imageLiteral(resourceName: "slide3"))
        ]
    }
    
    
    //MARK:-> IB Actions
    
    @IBAction func nextButtonTaped(_ sender: Any) {
        
       // UserDefaults.standard.set(true, forKey: "NewUser22")

        if currentPage == onBoardSlide.count - 1 {
           // self.performSegue(withIdentifier: "toWelcomeIdentifier", sender: nil)
            if Auth.auth().currentUser != nil {//then the user is loged in
               self.performSegue(withIdentifier: "toTabBarIdentifier", sender: nil)
               // self.performSegue(withIdentifier: "toWelcomeIdentifier", sender: nil)
            }else{
                self.performSegue(withIdentifier: "toWelcomeIdentifier", sender: nil)
            }
           
           // print("Go to Another Page 🚀")
        }
        
        else {
            currentPage += 1
            let indexpath = IndexPath(item: currentPage, section: 0)
            introCollectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        }
        
    }
    

    

}

extension IntroViewController:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func SetupCollectionView() {
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardSlide.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = introCollectionView.dequeueReusableCell(withReuseIdentifier: IntroCollectionViewCell.idintfier, for: indexPath) as! IntroCollectionViewCell
        cell.ConfigureCell(onBoardSlide[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
