
import UIKit
import SVProgressHUD
class FavoritesVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   var noFavoritesLabel: UILabel!
   var cellTitle  = ""
   var loginuserFavouriteRestaurantArray = [RestaurantCompleteData]() // For store Fav Restaurant
   var loginuserFavouriteItemArray = [ItemCompleteData]()
   var getImageArray = [String]()
   var restaurantImages = [RestaurantImage]()
   @IBOutlet weak var backView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var favoriteCV: UICollectionView!
   @IBOutlet weak var favoriteView: UIView!
   var internetCheckTimer : Timer?
   override func viewDidLoad() {
       super.viewDidLoad()
       SVProgressHUD.show()
       favoriteCV.isHidden = true
       internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
       internetCheckTimer?.tolerance = 2.0
       noFavoritesLabel = UILabel()
       noFavoritesLabel.textAlignment = .center
       noFavoritesLabel.textColor = .gray
       noFavoritesLabel.font = UIFont.systemFont(ofSize: 16)
       noFavoritesLabel.numberOfLines = 0
       // noFavoritesLabel.text = "You don't have any favourite restaurant and item"
       noFavoritesLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(noFavoritesLabel)
       
       NSLayoutConstraint.activate([
           noFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           noFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           noFavoritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           noFavoritesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
       ])
       
       favoriteCV.register(EmptyCell.self, forCellWithReuseIdentifier: "emptyCell")
       favoriteCV.register(UINib(nibName: "EmptyCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EmptyCollectionViewCell")
       
       
       backView.layer.cornerRadius = 10
       
       titleLabel.text = cellTitle
       favoriteView.layer.cornerRadius = 5
       favoriteView.clipsToBounds = true
       //  FilteruserFavResturant()
       
       
       favoriteCV.register(FavouriteSectionHeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FavouriteSectionHeaderViewController")
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           SVProgressHUD.dismiss()
           self.favoriteCV.isHidden = false
           self.favoriteCV.reloadData()
       }
       fetchRestaurantImages()
   }
   func fetchRestaurantImages() {
            
           guard let url = URL(string: restaurantImagesURL) else {
               print("Invalid URL")
               return
           }
           
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   print("Error fetching data: \(error)")
                   return
               }
               
               guard let data = data else {
                   print("No data received")
                   return
               }
               
               do {
                   let decoder = JSONDecoder()
                   self.restaurantImages = try decoder.decode([RestaurantImage].self, from: data)
                  
                  
               } catch {
                   print("Error decoding data: \(error)")
               }
           }
           
           task.resume()
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
extension FavoritesVC {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 2
   }
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       if kind == UICollectionView.elementKindSectionHeader {
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FavouriteSectionHeaderViewController", for: indexPath) as! FavouriteSectionHeaderViewController
           noFavoritesLabel.isHidden = true
           if indexPath.section == 0{
               headerView.titleLabel.text = "Restaurant"
           }else{
               headerView.titleLabel.text = "Items"
           }
           return headerView
           //   }
       }
       
       // You can also handle section footers in a similar way if needed
       
       return UICollectionReusableView()
   }
   
   // If you want to specify the size of the header, implement this method
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       return CGSize(width: collectionView.frame.width, height: 50) // Adjust the height as needed
   }
   
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if loginuserFavouriteItemArray.isEmpty && loginuserFavouriteRestaurantArray.isEmpty {
           
           return 1 // Return 1 to display the empty state cell
       } else {
           
           if section == 0 {
               return loginuserFavouriteRestaurantArray.count > 0 ? loginuserFavouriteRestaurantArray.count : 1
           } else {
               return loginuserFavouriteItemArray.count > 0 ? loginuserFavouriteItemArray.count : 1
           }
       }
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if loginuserFavouriteItemArray.isEmpty && loginuserFavouriteRestaurantArray.isEmpty {
           let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
           emptyCell.messageLabel.text = "You don't have any favorites"
           //emptyCell.Uiimage.image = UIImage(named: "noItem")
           return emptyCell
       } else {
           if indexPath.section == 0 {
               if loginuserFavouriteRestaurantArray.isEmpty {
                   let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
                   emptyCell.messageLabel.text = "No favourite restaurants"
                  // emptyCell.Uiimage.image = UIImage(named: "restaurantoffline")
                   return emptyCell
               } else {
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCellPop", for: indexPath) as! favCollectionViewCellpop
                   let favoriteRestaurant = loginuserFavouriteRestaurantArray[indexPath.row]
                   cell.favoriteRestaurant = favoriteRestaurant
                   
                   if let image = favoriteRestaurant.restaurant.RestaurantImage {
                       loadImage(from: image) { image in
                           if let img = image {
                               DispatchQueue.main.sync {
                                   cell.favResImage.image = img
                               }
                           }
                       }
                   } else {
                       DispatchQueue.main.sync {
                           cell.favResImage.image = emptyImage
                       }
                   }

                   cell.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                   cell.isFavourite = true
                   
                   cell.dishNames.text = favoriteRestaurant.restaurant.RestaurantCategory ?? "Unknown Category"
                   cell.offertypeLabel.text = "\(favoriteRestaurant.rstaurantOffers?.discount ?? 0)"
                   cell.offerLabel.text = favoriteRestaurant.rstaurantOffers?.offerTitle ?? "No Offer"
                   cell.descriLabels.text = favoriteRestaurant.restaurant.Description ?? "No Description"
                   cell.restaruntName.text = favoriteRestaurant.restaurant.RestaurantTitle ?? "Unknown Restaurant"
                   cell.ratingLabel.text = "\(favoriteRestaurant.restaurantAverageRating ?? 0) (\(favoriteRestaurant.restaurantRatings.count))"
                   
                   cell.reloadAfterFavActionClosure = { [weak self] in
                       DispatchQueue.main.async {
                           self?.loginuserFavouriteRestaurantArray.removeAll { $0.restaurant.RestaurantID == favoriteRestaurant.restaurant.RestaurantID }
                           self?.favoriteCV.reloadData()
                           NotificationCenter.default.post(name: Notification.Name("DeleteFavouriteActionNotification"), object: nil)
                       }
                   }
                   return cell
               }
           } else {
               if loginuserFavouriteItemArray.isEmpty {
                   let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
                   emptyCell.messageLabel.text = "You don't have any favorite Item"
                 //  emptyCell.Uiimage.image = UIImage(named: "noItem")
                   return emptyCell
               } else {
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCellPop", for: indexPath) as! favCollectionViewCellpop
                   let favoriteItem = loginuserFavouriteItemArray[indexPath.row]
                   cell.favoriteItem = favoriteItem

                   if let image = favoriteItem.Item.itemImage {
                       loadImage(from: image) { image in
                           if let img = image {
                               DispatchQueue.main.sync {
                                   cell.favResImage.image = img
                               }
                           }
                       }
                   } else {
                       DispatchQueue.main.sync {
                           cell.favResImage.image = emptyImage
                       }
                   }

                   cell.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                   cell.isFavourite = true
                   cell.dishNames.text = favoriteItem.Item.CusineTitle ?? ""
                   cell.descriLabels.text = favoriteItem.Item.Description ?? ""
                   cell.restaruntName.text = favoriteItem.Item.ItemTitle ?? ""
                   cell.ratingLabel.text = "\(favoriteItem.itemAverageRating ?? 0.0)(\(favoriteItem.ItemRatings.count))"
                   
                   if let offerTitle = favoriteItem.ItemOffer?.offerTitle, !offerTitle.isEmpty {
                       cell.offerLabel.text = offerTitle
                       cell.offerLabel.isHidden = false
                       cell.offertypeLabel.text = "\(favoriteItem.ItemOffer?.discount ?? 0)"
                       cell.offertypeLabel.isHidden = false
                   } else {
                       cell.offerLabel.isHidden = true
                       cell.offertypeLabel.isHidden = true
                   }

                   cell.reloadAfterFavActionClosure = { [weak self] in
                       DispatchQueue.main.async {
                           self?.loginuserFavouriteItemArray.removeAll { $0.Item.ItemID == favoriteItem.Item.ItemID }
                           self?.favoriteCV.reloadData()
                           NotificationCenter.default.post(name: Notification.Name("DeleteFavouriteActionNotification"), object: nil)
                       }
                   }
                   return cell
               }
           }
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
       
       
       if indexPath.section == 0{
           guard !loginuserFavouriteRestaurantArray.isEmpty else{
               return
           }
           let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
           let selectedRestaurant = loginuserFavouriteRestaurantArray[indexPath.row]
           restarantHomeVC.selectedFor = "restaurant"
           restarantHomeVC.modalPresentationStyle = .fullScreen
           restarantHomeVC.modalTransitionStyle = .coverVertical
           //restarantHomeVC.restaurantName = selectedFoodName
          
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
           restarantHomeVC.getImageArray = self.getImageArray
           restarantHomeVC.selectedFor = "restaurant"
           restarantHomeVC.modalPresentationStyle = .fullScreen
           restarantHomeVC.modalTransitionStyle = .coverVertical
           //restarantHomeVC.restaurantName = selectedFoodName
           
      
           restarantHomeVC.selectedRestaurantData = [selectedRestaurant]
           self.present(restarantHomeVC, animated: true, completion: nil)
           
       }else{
           guard !loginuserFavouriteItemArray.isEmpty else{
               return
           }
           let controller = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
           let itemData = loginuserFavouriteItemArray[indexPath.row]
           let selectedFoodName = itemData.Item.ItemTitle
           controller.selectedFor = "dishes"
           controller.ItemID = itemData.Item.ItemID
           controller.selectedSignatureItem = [itemData]
           controller.modalPresentationStyle = .fullScreen
           controller.modalTransitionStyle = .coverVertical
           controller.restaurantName = selectedFoodName ?? ""
           
           controller.modalPresentationStyle = .fullScreen
           self.present(controller, animated: true, completion: nil)
           
       }
       
   }
}
