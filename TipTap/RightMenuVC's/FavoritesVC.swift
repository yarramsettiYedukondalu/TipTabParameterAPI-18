//
//  FavoritesVC.swift
//  TipTap
//
//  Created by sriram on 06/11/23.
//

import UIKit

class FavoritesVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var cellTitle  = ""
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var favoriteCV: UICollectionView!
    @IBOutlet weak var favoriteView: UIView!
    
    var RestaurantImages: [String] = ["1", "2", "delicious-indian-food-tray (1)", "pizza-pizza-filled-with-tomatoes-salami-olives","Cuisine5", "Cuisine2", "Cuisine5"]
    
    
    var SignatureDishImages: [String] = ["delicious-indian-food-tray (1)","penne-pasta-tomato-sauce-with-chicken-tomatoes-wooden-table","pizza-pizza-filled-with-tomatoes-salami-olives","top-view-delicious-noodles-concept","penne-pasta-tomato-sauce-with-chicken-tomatoes-wooden-table","pizza-pizza-filled-with-tomatoes-salami-olives","penne-pasta-tomato-sauce-with-chicken-tomatoes-wooden-table"]
    
    var CusineImages: [String] = ["Cuisine1", "Cuisine2", "Cuisine3", "Cuisine4","Cuisine5", "Cuisine2", "Cuisine5"]
    
    
    var dishName : [String] = ["• North • Hamburgers","• Indian • Pure veg","• Hamburgers • Pure veg","American • Pure veg","• North • Hamburgers","• Indian • Pure veg","• Hamburgers • Pure veg"]
    var restaruntName : [String] = ["The osahan Restaurant","Thai Famous Indian","The osahan Restaurant","Bite Me Now Sandwi","The osahan Restaurant","Thai Famous Indian","The osahan Restaurant"]
    var offerSet : [String] = ["65% OSAHAN50","65% off","65% OSAHAN50","65% off","65% OSAHAN50","65% off","65% OSAHAN50"]
    var hotelDescriptions = [
        "Picturesque beachfront resort with private cabanas and crystal-clear waters.",
        "Historic boutique hotel, rich in charm", "located in the heart of downtown.","Picturesque beachfront resort with private cabanas and crystal-clear waters.", "Picturesque beachfront resort with private cabanas and crystal-clear waters.",
        "Historic boutique hotel, rich in charm, located in the heart of downtown.","Picturesque beachfront resort with private cabanas and crystal-clear waters."]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 10
        
        titleLabel.text = cellTitle
        favoriteView.layer.cornerRadius = 5
        favoriteView.clipsToBounds = true
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func viewAllFav(_ sender: Any) {
        print("Butten Pressed--->")
    }
}
extension FavoritesVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RestaurantImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCellPop", for: indexPath) as! favCollectionViewCellpop
        
        if cellTitle == "Favorites"{
            cell.favResImage.image = UIImage(named: RestaurantImages[indexPath.row])
        }else if cellTitle == "All Cuisines"{
            cell.favResImage.image = UIImage(named: CusineImages[indexPath.row])
        }else{
            cell.favResImage.image = UIImage(named: SignatureDishImages[indexPath.row])
            
            
        }
        
       
        cell.dishNames.text = dishName[indexPath.row]
        cell.offertypeLabel.text = offerSet[indexPath.row]
        cell.descriLabels.text = hotelDescriptions[indexPath.row]
        cell.restaruntName.text = restaruntName[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if UIDevice.current.userInterfaceIdiom == .pad {
        let cellWidth = (collectionView.bounds.width - 30)
        return CGSize(width: cellWidth, height: 120)
        } else {
        let cellWidth = (collectionView.bounds.width - 10)
        return CGSize(width: cellWidth, height: 120)
        }
    }
}

