//
//  MenuTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 15/07/2021.
//

import UIKit
protocol  MenuCellDelegate: class {
    func selectedItemIndex(itemIndex: Int)
}
class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var viewAllButtonOutlet: UIButton!
    @IBOutlet weak var MenuCollectionView: UICollectionView!{
        didSet{
            MenuCollectionView.delegate = self
            MenuCollectionView.dataSource = self
        }
    }
    //MARK: - Vars
    var itemViewModel = PopularMenuItemViewModel()
    var items :[Item] = []
    weak var delegate: MenuCellDelegate?
    //set margins of the cell
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom:20.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemViewModel.bindItemsViewModelToView = {
            self.loadItems()
        }
        //make button rounded
        viewAllButtonOutlet.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Load items from firebase
    
    private func loadItems() {
        items = itemViewModel.popularMenuItemsData
        self.MenuCollectionView.reloadData()
    }
}

extension MenuTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MenuCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuCollectionViewCell.self) , for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        //make view rounded
    //    Utilities.makeViewRounded(view: cell.menuView, cornerRadius: 10, color: #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1))
        
        cell.menuPriceLabel.text = "$ \(items[indexPath.row].price ?? 0.0)"
        cell.menuNameLabel.text = items[indexPath.row].name
            if items[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [items[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.menuImageView.image = images.first as? UIImage
                    }
                }
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        self.delegate?.selectedItemIndex(itemIndex: indexPath.row)
   }
}

extension MenuTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = contentView.frame.width - paddingSpace
        let withPerItem = (availableWidth / itemsPerRow )/1.2

        return CGSize(width: withPerItem, height: 190)
     //   return CGSize(width: 100, height: 100)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }
}
