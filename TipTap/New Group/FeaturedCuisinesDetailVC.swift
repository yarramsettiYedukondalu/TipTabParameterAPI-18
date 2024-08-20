////
////  FeaturedCuisinesDetailVC.swift
////  TipTap
////
////  Created by sriram on 27/11/23.
////
//
//import UIKit
//
//class FeaturedCuisinesDetailVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{
//   
//    
//    var cuisineModel : [[ItemCompleteData]] = [[]]
//    var filteredItems : [[ItemCompleteData]] = [[]]
////    var cuisineModel = [CuisineModel]()
////    var filteredItems :[CuisineModel] = []
//    var listView = false
//    var placeholderIndex = 0
//    var placeholders = ["Search here Featured Restaurents", "Search here Your Favorite Dishes", "Search here For Signature Dishes"] // Add your desired placeholders here
//    var timer: Timer?
//    
//    @IBOutlet weak var menuButton: UIButton!
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var cuisineCollectionView: UICollectionView!
//    @IBOutlet weak var filterBtn: UIButton!
//    @IBOutlet weak var gridViewOutLet: UIButton!
//    @IBOutlet weak var listViewOutlet: UIButton!
//      @IBOutlet weak var headingLabel: UILabel!
//    @IBOutlet weak var searchTF: UITextField! {
//        didSet{
//            searchTF.tintColor = .lightGray
//            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
//        }
//    }
//    var internetCheckTimer : Timer?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        showHUD()
//        cuisineCollectionView.isHidden = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            self?.cuisineCollectionView.isHidden = false
//            self?.hideHUD()
//            self?.cuisineCollectionView.dataSource = self
//            self?.cuisineCollectionView.delegate = self
//            
//            self?.cuisineCollectionView.reloadData() // Reload table view after dismissing SVProgressHUD
//        }
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
//               internetCheckTimer?.tolerance = 2.0
//        gridViewOutLet.layer.borderWidth = 2
//        gridViewOutLet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
//        
//        headingLabel.text = "Cuisines"
//
//        setUI()
//        for cuisine in cuisineModel{
//            filteredItems.append(cuisine)
//        }
//        let customFlowLayout = TwoByTwoFlowLayout()
//        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 10)
//        cuisineCollectionView.collectionViewLayout = customFlowLayout
//    }
//    @objc func checkInternet() {
//           if !Reachability.isConnectedToNetwork() {
//               internetCheckTimer?.invalidate()
//               redirectToResponsePage()
//           }
//       }
//       func redirectToResponsePage() {
//           // Implement the logic to navigate to the response page
//           let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as! InternetViewController
//           controller.message = "No Internet Connection"
//           self.present(controller, animated: true)
//       }
//    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
//        
//        //menuButton.setImage(UIImage(systemName: "xmark"), for: .normal)
//        
//        if (sender.tag == 10)
//        {
//            // To Hide Menu If it already there
//            sender.tag = 0;
//            let viewMenuBack : UIView = view.subviews.last!
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                var frameMenu : CGRect = viewMenuBack.frame
//                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
//                viewMenuBack.frame = frameMenu
//                viewMenuBack.layoutIfNeeded()
//                viewMenuBack.backgroundColor = UIColor.clear
//            }, completion: { (finished) -> Void in
//                viewMenuBack.removeFromSuperview()
//            })
//            return
//        }
//        
//        sender.isEnabled = false
//        sender.tag = 10
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let menuVC : LeftMenuViewController = storyBoard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
//        menuVC.btnMenu = sender
//        // menuVC.delegate = self as? SlideMenuDelegate
//        self.view.addSubview(menuVC.view)
//        self.addChild(menuVC)
//        self.navigationController?.isNavigationBarHidden = true
//        //  self.present(menuVC, animated: true)
//        
//        menuVC.view.layoutIfNeeded()
//        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//        
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//            sender.isEnabled = true
//        }, completion:nil)
//    }
//    func setUI(){
//        //backButton.backButtonStyle()
//        searchTF.applyCustomPlaceholderStyle(size: "large")
//        headingLabel.applyLabelStyle(for: .titleBlack)
//    }
//    @IBAction func filterBtnAct(_ sender: Any) {
//        let controller = storyboard?.instantiateViewController(identifier: "FilterVC") as! FilterVC
//        controller.modalTransitionStyle = .coverVertical
//        self.present(controller, animated: true)
//    }
//    
//    @IBAction func listView(_ sender: Any) {
//        listView = true
//        gridViewButtonLayout()
//        animateViewModeChange()
//        
//        
//    }
//    @IBAction func gridView(_ sender: Any) {
//       
//        listView = false
//        
//        gridViewButtonLayout()
//        animateViewModeChange()
//    }
//    func gridViewButtonLayout(){
//        if listView{
//            listViewOutlet.layer.borderWidth = 2
//            gridViewOutLet.layer.borderWidth = 0
//            listViewOutlet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
//            
//        }else {
//            listViewOutlet.layer.borderWidth = 0
//            gridViewOutLet.layer.borderWidth = 2
//            gridViewOutLet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
//        }
//    }
//    func animateViewModeChange() {
//        UIView.transition(with: cuisineCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.cuisineCollectionView.reloadData()
//        }, completion: nil)
//    }
//
//    func getItemOffer(item: Item) -> ItemOffer {
//        guard let itemOffer =  JsonDataArrays.itemOffersArray.first(where: { $0.itemID == item.ItemID && $0.restaurantID == item.RestaurantID }) else {
//            // Return a default value or handle the absence of ItemOffer
//            return ItemOffer(itemOfferID: "", restaurantID: "", itemID: "", offerTitle: "", description: "", discount: 0.0, startDate: "", endDate: "", isOffer: false, disable: false)
//        }
//        return itemOffer
//    }
//    @IBAction func backButtonAction(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        cuisineCollectionView.reloadData()
//    
//        updatePlaceholder()
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//            // Your code related to text field editing, if needed
//        }
//     
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            guard let currentText = textField.text else {
//                return true
//            }
//     
//            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//            updateFilteredData(searchText: newText)
//     
//            return true
//        }
//     
//        func updateFilteredData(searchText: String) {
//            
//            
//            if searchText.isEmpty {
//                    filteredItems = cuisineModel
//            } else {
//                filteredItems = cuisineModel.map { outerArray in
//                    outerArray.filter { item in
//                        if let cusineTitle = item.Item.CusineTitle {
//                            return cusineTitle.lowercased().contains(searchText.lowercased())
//                        } else {
//                            // Handle the case where cusineTitle is nil, if needed
//                            return false
//                        }
//                    }
//                }
//            }
//          
//            DispatchQueue.main.async {
//                self.cuisineCollectionView.reloadData()
//            }
//        }
//    func updatePlaceholder() {
//        searchTF.placeholder = placeholders[placeholderIndex]
//          }
//          func startTimer() {
//              timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updatePlaceholderWithTimer), userInfo: nil, repeats: true)
//          }
//          @objc func updatePlaceholderWithTimer() {
//              placeholderIndex = (placeholderIndex + 1) % placeholders.count
//              updatePlaceholder()
//          }
//          override func viewWillDisappear(_ animated: Bool) {
//              super.viewWillDisappear(animated)
//              timer?.invalidate()
//          }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return filteredItems.flatMap { $0 }.count
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if listView {
//          
//              
//            let listCell = cuisineCollectionView.dequeueReusableCell(withReuseIdentifier: "SignatureDishesListViewCVC", for: indexPath)as! SignatureDishesListViewCVC
//            
//           
//            let cuisines = filteredItems.flatMap { $0 }[indexPath.row]
//            listCell.configure(cuisines: cuisines)
//
//            if !JsonDataArrays.FavouriteItemsIDArray.isEmpty {
//                // Assuming cuisines.Item.ItemID is a String
//                if JsonDataArrays.FavouriteItemsIDArray.contains(where: { $0.itemID == cuisines.Item.ItemID }) {
//                    listCell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                    listCell.favoriteButton.tintColor = .systemRed
//                } else {
//                    listCell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//                }
//            }
//
//            listCell.itemSubdescription.isHidden = true
//            return listCell
//        }
//        else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCollectionViewCell
//            let cuisines = filteredItems.flatMap { $0 }[indexPath.row]
//            // let itemOffer = getItemOffer(item: cuisines)
//            cell.configure2(with: cuisines)
//
//            if !JsonDataArrays.FavouriteItemsIDArray.isEmpty {
//                // Assuming cuisines.Item.ItemID is a String
//                if JsonDataArrays.FavouriteItemsIDArray.contains(where: { $0.itemID == cuisines.Item.ItemID }) {
//                    cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                    cell.heartBtn.tintColor = .systemRed
//                } else {
//                    cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//                }
//            }
//
//            
//            return cell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
//        restarantHomeVC.selectedFor = "cuisines"
//        let cuisines = filteredItems.flatMap { $0 }[indexPath.row]
//        restarantHomeVC.selectedCuisine = [cuisines]
//        
//        
//        
//        let selectedCuisine = cuisinesArrayfromItems[indexPath.row]
//        restarantHomeVC.restaurantName = selectedCuisine.first?.Item.CusineTitle ?? ""
//        if let firstItem = selectedCuisine.first {
//            // Find restaurant IDs matching the selected cuisine
//         //   let matchingRestaurantIDs = JsonDataArrays.itemModel.filter { $0.CusineTitle == firstItem.Item.CusineTitle }.map { $0.RestaurantID }
//            let matchingRestaurantIDs = JsonDataArrays.itemModel.filter { $0.CusineTitle == firstItem.Item.CusineTitle }.compactMap { $0.RestaurantID }
//            restarantHomeVC.matchingRestaurant_ID = matchingRestaurantIDs
//            restarantHomeVC.selectedCuisine = selectedCuisine
//            restarantHomeVC.modalPresentationStyle = .fullScreen
//            self.present(restarantHomeVC, animated: true, completion: nil)
//
//        }
//    }
//    
//    //MARK: cell for Height
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        if listView {
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                let cellWidth = (collectionView.bounds.width - 30)
//                return CGSize(width: cellWidth, height: 170)
//            } else {
//                let cellWidth = (collectionView.bounds.width - 30)
//                return CGSize(width: cellWidth, height: 160)
//            }
//        }else{
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                let cellWidth = (collectionView.bounds.width - 30) / 2
//                return CGSize(width: cellWidth, height: 290)
//            } else {
//                let cellWidth = (collectionView.bounds.width - 30) / 2
//                return CGSize(width: cellWidth, height: 285)
//            }
//        }
//    }
//}
//
//
//
//  FeaturedCuisinesDetailVC.swift
//  TipTap
//
//  Created by sriram on 27/11/23.
//

import UIKit
import SVProgressHUD

class FeaturedCuisinesDetailVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{
   
    
    var cuisineModel : [[ItemCompleteData]] = [[]]
    var filteredItems : [[ItemCompleteData]] = [[]]
    var loginuserFavouriteItemArray = [ItemCompleteData]()
//    var cuisineModel = [CuisineModel]()
//    var filteredItems :[CuisineModel] = []
    var listView = false
    var placeholderIndex = 0
    var placeholders = ["Search here Featured Restaurents", "Search here Your Favorite Dishes", "Search here For Signature Dishes"] // Add your desired placeholders here
    var timer: Timer?
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var gridViewOutLet: UIButton!
    @IBOutlet weak var listViewOutlet: UIButton!
      @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField! {
        didSet{
            searchTF.tintColor = .lightGray
            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
        }
    }
    var internetCheckTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        showHUD()
        cuisineCollectionView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.cuisineCollectionView.isHidden = false
            self?.hideHUD()
            self?.cuisineCollectionView.dataSource = self
            self?.cuisineCollectionView.delegate = self
            
            self?.cuisineCollectionView.reloadData() // Reload table view after dismissing SVProgressHUD
        }
        
        
        
        
        
        
        
        
        
        
        
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
               internetCheckTimer?.tolerance = 2.0
        gridViewOutLet.layer.borderWidth = 2
        gridViewOutLet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
        
        headingLabel.text = "Cuisines"

        setUI()
        for cuisine in cuisineModel{
            filteredItems.append(cuisine)
        }
        let customFlowLayout = TwoByTwoFlowLayout()
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 10)
        cuisineCollectionView.collectionViewLayout = customFlowLayout
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
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
        
        //menuButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            sender.tag = 0;
            let viewMenuBack : UIView = view.subviews.last!
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC : LeftMenuViewController = storyBoard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        menuVC.btnMenu = sender
        // menuVC.delegate = self as? SlideMenuDelegate
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        self.navigationController?.isNavigationBarHidden = true
        //  self.present(menuVC, animated: true)
        
        menuVC.view.layoutIfNeeded()
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    func setUI(){
        //backButton.backButtonStyle()
        searchTF.applyCustomPlaceholderStyle(size: "large")
        headingLabel.applyLabelStyle(for: .titleBlack)
    }
    @IBAction func filterBtnAct(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "FilterVC") as! FilterVC
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
    }
    
    @IBAction func listView(_ sender: Any) {
        listView = true
        gridViewButtonLayout()
        animateViewModeChange()
        
        
    }
    @IBAction func gridView(_ sender: Any) {
       
        listView = false
        
        gridViewButtonLayout()
        animateViewModeChange()
    }
    func gridViewButtonLayout(){
        if listView{
            listViewOutlet.layer.borderWidth = 2
            gridViewOutLet.layer.borderWidth = 0
            listViewOutlet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
            
        }else {
            listViewOutlet.layer.borderWidth = 0
            gridViewOutLet.layer.borderWidth = 2
            gridViewOutLet.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
        }
    }
    func animateViewModeChange() {
        UIView.transition(with: cuisineCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.cuisineCollectionView.reloadData()
        }, completion: nil)
    }

    func getItemOffer(item: Item) -> ItemOffer {
        guard let itemOffer =  JsonDataArrays.itemOffersArray.first(where: { $0.itemID == item.ItemID && $0.restaurantID == item.RestaurantID }) else {
            // Return a default value or handle the absence of ItemOffer
            return ItemOffer(itemOfferID: "", restaurantID: "", itemID: "", offerTitle: "", description: "", discount: 0.0, startDate: "", endDate: "", isOffer: false, disable: false)
        }
        return itemOffer
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cuisineCollectionView.reloadData()
    
        updatePlaceholder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            // Your code related to text field editing, if needed
        }
     
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentText = textField.text else {
                return true
            }
     
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            updateFilteredData(searchText: newText)
     
            return true
        }
     
        func updateFilteredData(searchText: String) {
            
            
            if searchText.isEmpty {
                    filteredItems = cuisineModel
            } else {
                filteredItems = cuisineModel.map { outerArray in
                    outerArray.filter { item in
                        if let cusineTitle = item.Item.CusineTitle {
                            return cusineTitle.lowercased().contains(searchText.lowercased())
                        } else {
                            // Handle the case where cusineTitle is nil, if needed
                            return false
                        }
                    }
                }
            }
          
            DispatchQueue.main.async {
                self.cuisineCollectionView.reloadData()
            }
        }
    func updatePlaceholder() {
        searchTF.placeholder = placeholders[placeholderIndex]
          }
          func startTimer() {
              timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updatePlaceholderWithTimer), userInfo: nil, repeats: true)
          }
          @objc func updatePlaceholderWithTimer() {
              placeholderIndex = (placeholderIndex + 1) % placeholders.count
              updatePlaceholder()
          }
          override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)
              timer?.invalidate()
          }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredItems.flatMap { $0 }.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if listView {
          
              
            let listCell = cuisineCollectionView.dequeueReusableCell(withReuseIdentifier: "SignatureDishesListViewCVC", for: indexPath)as! SignatureDishesListViewCVC
            
           
            let cuisines = filteredItems.flatMap { $0 }[indexPath.row]
            listCell.configure(cuisines: cuisines)

            
            listCell.reloadDishesCVAfterFavActionClosure = { [weak self] in
                fetchFavouriteItems{
                    SVProgressHUD.show()
                    self?.FilteruserFavItems{
                        DispatchQueue.main.async {
                            self?.cuisineCollectionView.reloadItems(at:  [indexPath])
                            
//                            self?.BadgeCorner(myLabel: self!.notibadgeLabel)
//                            self?.BadgeCorner(myLabel:  self!.favbadgeLabel)
                            let indexPath = IndexPath(item: 3, section: 0)
//                            self?.FoodGroupCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            }
            if !JsonDataArrays.FavouriteItemsIDArray.isEmpty {
                // Assuming cuisines.Item.ItemID is a String
                if JsonDataArrays.FavouriteItemsIDArray.contains(where: { $0.itemID == cuisines.Item.ItemID }) {
                    listCell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    listCell.isFavorite = true
                    listCell.favoriteButton.tintColor = .systemRed
                } else {
                    listCell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    listCell.isFavorite = false
                }
                
            }

            listCell.itemSubdescription.isHidden = true
            return listCell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCollectionViewCell
            let cuisines = filteredItems.flatMap { $0 }[indexPath.row]
            // let itemOffer = getItemOffer(item: cuisines)
            cell.configure2(with: cuisines)

            
            if !JsonDataArrays.FavouriteItemsIDArray.isEmpty {
                // Assuming cuisines.Item.ItemID is a String
                if JsonDataArrays.FavouriteItemsIDArray.contains(where: { $0.itemID == cuisines.Item.ItemID }) {
                    cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    cell.isFavorite = true
                    cell.heartBtn.tintColor = .systemRed
                } else {
                    cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.isFavorite = false
                }
            }else{
                cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.isFavorite = false
            }
            
            cell.reloadCuisineCollectionViewAfterFavActionClosure = { [weak self] in
                fetchFavouriteItems{
                    SVProgressHUD.show()
                    self?.FilteruserFavItems{
                        DispatchQueue.main.async {
                            self?.cuisineCollectionView.reloadItems(at:  [indexPath])
                            
//                            self?.BadgeCorner(myLabel: self!.notibadgeLabel)
//                            self?.BadgeCorner(myLabel:  self!.favbadgeLabel)
//                            let indexPath = IndexPath(item: 3, section: 0)
//                            self?.FoodGroupCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            }
            

            
            return cell
        }
    }
    
    func FilteruserFavItems(completion: @escaping () -> Void) {
        loginuserFavouriteItemArray.removeAll()
        
        for item in JsonDataArrays.FavouriteItemsIDArray {
            let matchingItems =  JsonDataArrays.itemCompleteDataArray.filter { $0.Item.ItemID == item.itemID }
            
            for matchingItem in matchingItems {
                // Check if the item is not already in the array before appending
                if !loginuserFavouriteItemArray.contains(where: { $0.Item.ItemID == matchingItem.Item.ItemID }) {
                    loginuserFavouriteItemArray.append(matchingItem)
                }
            }
            
        }
        completion()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
        restarantHomeVC.selectedFor = "cuisines"
        let cuisines = filteredItems.flatMap { $0 }[indexPath.row]
        restarantHomeVC.selectedCuisine = [cuisines]
        
        
        
        let selectedCuisine = cuisinesArrayfromItems[indexPath.row]
        restarantHomeVC.restaurantName = selectedCuisine.first?.Item.CusineTitle ?? ""
        if let firstItem = selectedCuisine.first {
            // Find restaurant IDs matching the selected cuisine
         //   let matchingRestaurantIDs = JsonDataArrays.itemModel.filter { $0.CusineTitle == firstItem.Item.CusineTitle }.map { $0.RestaurantID }
            let matchingRestaurantIDs = JsonDataArrays.itemModel.filter { $0.CusineTitle == firstItem.Item.CusineTitle }.compactMap { $0.RestaurantID }
            restarantHomeVC.matchingRestaurant_ID = matchingRestaurantIDs
            restarantHomeVC.selectedCuisine = selectedCuisine
            restarantHomeVC.modalPresentationStyle = .fullScreen
            self.present(restarantHomeVC, animated: true, completion: nil)

        }
    }
    
    //MARK: cell for Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if listView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let cellWidth = (collectionView.bounds.width - 30)
                return CGSize(width: cellWidth, height: 170)
            } else {
                let cellWidth = (collectionView.bounds.width - 30)
                return CGSize(width: cellWidth, height: 160)
            }
        }else{
            if UIDevice.current.userInterfaceIdiom == .pad {
                let cellWidth = (collectionView.bounds.width - 30) / 2
                return CGSize(width: cellWidth, height: 290)
            } else {
                let cellWidth = (collectionView.bounds.width - 30) / 2
                return CGSize(width: cellWidth, height: 285)
            }
        }
    }
}


