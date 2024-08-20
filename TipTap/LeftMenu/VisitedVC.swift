//
//  VisitedVC.swift
//  TipTap
//
//  Created by sriram on 06/11/23.
//

import UIKit
struct userVisitedRestaurantData{
    var visitedDate : String
    var review : String
    var rating : Int
    var restaurant : RestaurantCompleteData
}
class VisitedVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var getImageArray = [String]()
    var restaurantImages = [RestaurantImage]()
    
    var cellTitle  = ""
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var favoriteCV: UICollectionView!
    @IBOutlet weak var favoriteView: UIView!
    
    var RestaurantImages: [String] = ["1", "2", "3", "1","2", "3", "1"]
    // var RestaurantIDArray = [Int]()
    
    
    
    
    var CusineImages: [String] = ["Cuisine1", "Cuisine2", "Cuisine3", "Cuisine4","Cuisine5", "Cuisine2", "Cuisine5"]
    
    
    var dishName : [String] = ["• North • Hamburgers","• Indian • Pure veg","• Hamburgers • Pure veg","American • Pure veg","• North • Hamburgers","• Indian • Pure veg","• Hamburgers • Pure veg"]
    var restaruntName : [String] = ["The osahan Restaurant","Thai Famous Indian","The osahan Restaurant","Bite Me Now Sandwi","The osahan Restaurant","Thai Famous Indian","The osahan Restaurant"]
    var offerSet : [String] = ["65% OSAHAN50","65% off","65% OSAHAN50","65% off","65% OSAHAN50","65% off","65% OSAHAN50"]
    var hotelDescriptions = [
        "Picturesque beachfront resort with private cabanas and crystal-clear waters.",
        "Historic boutique hotel, rich in charm", "located in the heart of downtown.","Picturesque beachfront resort with private cabanas and crystal-clear waters.", "Picturesque beachfront resort with private cabanas and crystal-clear waters.",
        "Historic boutique hotel, rich in charm, located in the heart of downtown.","Picturesque beachfront resort with private cabanas and crystal-clear waters."]
    var internetCheckTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        showHUD()
        favoriteCV.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.favoriteCV.isHidden = false
            self?.hideHUD()
            self?.favoriteCV.dataSource = self
            self?.favoriteCV.delegate = self
            
            self?.favoriteCV.reloadData() // Reload table view after dismissing SVProgressHUD
        }
        
        
        
        
        
        favoriteCV.register(EmptyCell.self, forCellWithReuseIdentifier: "emptyCell")
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
        backView.layer.cornerRadius = 10
        
        titleLabel.text = cellTitle
        favoriteView.layer.cornerRadius = 5
        favoriteView.clipsToBounds = true
        favoriteCV.register(UINib(nibName: "EmptyCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EmptyCollectionViewCell")
    }
    @objc func checkInternet() {
        if !Reachability.isConnectedToNetwork() {
            internetCheckTimer?.invalidate()
            redirectToResponsePage()
        }
    }
    func redirectToResponsePage() {
        // Implement the logic to navigate to the response page
        let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as! InternetViewController
        controller.message = "No Internet Connection"
        self.present(controller, animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func viewAllFav(_ sender: Any) {
        print("Butten Pressed--->")
    }
}
extension VisitedVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if JsonDataArrays.userVisitedRestaurantwithReview.isEmpty{
            return 1
        }else{
            return JsonDataArrays.userVisitedRestaurantwithReview.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if JsonDataArrays.userVisitedRestaurantwithReview.isEmpty{
            
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as? EmptyCollectionViewCell ?? EmptyCollectionViewCell()
            emptyCell.messageLabel.text = "You haven't been to the restaurant."
           // emptyCell.messageLabel.applyLabelStyle(for: .subTitleLightGray)
          //  emptyCell.Uiimage.image = UIImage(named: "noItem")
            return emptyCell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitedCellPop", for: indexPath) as! VisitedCVC
            
            
            let datas = JsonDataArrays.userVisitedRestaurantwithReview[indexPath.row]
            
            if let image = datas.restaurant.restaurant.RestaurantImage{
                loadImage(from: image) { image in
                    if let img = image{
                        DispatchQueue.main.async {
                            cell.image.image = img
                        }
                        
                    }
                }
            }else{
                DispatchQueue.main.async {
                    cell.image.image = emptyImage
                }
            }
            
            cell.subNameLabel.text = datas.review
            cell.ratingLabel.text = "\(datas.restaurant.restaurantAverageRating ?? 0.0)(\(datas.restaurant.restaurantRatings.count))"
            cell.discriptionLabel.text = datas.visitedDate
            cell.nameLabel.text = datas.restaurant.restaurant.RestaurantTitle
            cell.offerLabel.text = datas.restaurant.rstaurantOffers?.offerTitle
            cell.offerDisLabel.text = "\(datas.restaurant.rstaurantOffers?.discount ?? 0)"
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let cellWidth = (collectionView.bounds.width - 30)
            return CGSize(width: cellWidth, height: 140)
        } else {
            let cellWidth = (collectionView.bounds.width - 10)
            return CGSize(width: cellWidth, height: 120)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !JsonDataArrays.userVisitedRestaurantwithReview.isEmpty else {
            return
        }
        let controller = storyboard?.instantiateViewController(withIdentifier: "RestaurantHomeVC") as! RestaurantHomeVC
        
        let data = JsonDataArrays.userVisitedRestaurantwithReview[indexPath.row]
        
        controller.selectedFor = "restaurant"
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        //restarantHomeVC.restaurantName = selectedFoodName
        let selectedRestaurant = JsonDataArrays.restaurantCompleteDataArray[indexPath.row]
        let selectedId = selectedRestaurant.restaurant.RestaurantID
        if   let userID = loginUserID {
            
            getRestarantImage.removeAll()
            
            let commentedUser = selectedRestaurant.restaurantRatings.filter { $0.RestaurantId == selectedId && $0.UserId == userID }
            
            print("CommentedID--->", commentedUser)
            if !commentedUser.isEmpty {
               // commandForChecking = true
            }
        }else{
          // commandForChecking = false
        }
         let getRestarantImages = self.restaurantImages.filter({ $0.RestaurantID == selectedId })
        
        getRestarantImage.append(contentsOf: getRestarantImages)
        if getRestarantImage.isEmpty {
            getImageArray = [selectedRestaurant.restaurant.RestaurantImage ?? ""]
           
        }else {
           
            if let firstRestaurantImage = getRestarantImage.first {
                let image1 = firstRestaurantImage.ImageOne
                let image2 = firstRestaurantImage.ImageTwo
                let image3 = firstRestaurantImage.ImageThree
                getImageArray.removeAll()
                getImageArray.append(image1)
                getImageArray.append(image2)
                getImageArray.append(image3)
            }

            // Accessing getImageArray
            for imageUrl in getImageArray {
                print("Image URL: \(imageUrl)")
            }
            
        }
 //   print("Images---->",getRestarantImage)
        controller.getImageArray = self.getImageArray
        controller.selectedFor = "restaurant"
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        //restarantHomeVC.restaurantName = selectedFoodName
        
        controller.selectedRestaurantData = [selectedRestaurant]
        controller.selectedRestaurantData = [data.restaurant]
        
        self.present(controller, animated: true, completion: nil)
        
        
    }
}

