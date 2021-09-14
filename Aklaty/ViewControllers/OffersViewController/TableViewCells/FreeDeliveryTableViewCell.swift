//
//  FreeDeliveryTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import UIKit
protocol  FreeDeliveryOffersCellDelegate: class {
    func selectedFreeDeliveryOfferIndex(itemIndex: Int)
}
class FreeDeliveryTableViewCell: UITableViewCell {
   
    @IBOutlet weak var addButtonOutlet: UIButton!
    //MARK: - Vars
    var OfferViewModel = FreeDeliveryOfferViewModel()
    weak var delegate: FreeDeliveryOffersCellDelegate?
    var offers :[Offer] = []
    @IBOutlet weak var freeDeliveryTableView: UITableView!{
        didSet{
            freeDeliveryTableView.delegate = self
            freeDeliveryTableView.dataSource = self
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addButtonOutlet.layer.cornerRadius = 10
        
        OfferViewModel.bindOfferViewModelToView = {
            self.loadOffers()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Load categories from firebase
    
    private func loadOffers() {
        offers = OfferViewModel.offersData
        self.freeDeliveryTableView.reloadData()
    }
}
extension FreeDeliveryTableViewCell : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FreeDelivery2TableViewCell.self)) as? FreeDelivery2TableViewCell else {
            return UITableViewCell()
        }
        
        cell.offerNameLabel.text = offers[indexPath.row].name
        cell.offerTimeLabel.text = "\(offers[indexPath.row].time ?? "") mins"
        cell.offerPriceLabel.text = "$ \(offers[indexPath.row].price ?? 0.0)"
       
            if offers[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [offers[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.offerImageView.image = images.first as? UIImage
                    }
                }
            }
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
       return 100
     }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.selectedFreeDeliveryOfferIndex(itemIndex: indexPath.row)
     }
   
}
