//
//  RatingsViewControllerVC.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/23.
//

import UIKit
class RatingsViewControllerVC: UIViewController {
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingsTableviewController: UITableView!
    var isCellExpanded = [Bool](repeating: false, count: JsonDataArrays.userRatingsDataArray.count)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        ratingsTableviewController.isHidden = true
        showHUD()
        // Delay execution of code to show SVProgressHUD
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.ratingsTableviewController.isHidden = false
            self?.hideHUD()
            self?.ratingsTableviewController.dataSource = self
            self?.ratingsTableviewController.delegate = self
            
            self?.ratingsTableviewController.reloadData() // Reload table view after dismissing SVProgressHUD
        }
        ratingsTableviewController.register(UINib(nibName: "EmptyRewardCell", bundle: .main), forCellReuseIdentifier: "EmptyRewardCell")
        isCellExpanded = [Bool](repeating: false, count: JsonDataArrays.userRatingsDataArray.count)
        
    }
    
    private func configureTableView(){
        ratingsTableviewController.register(UINib(nibName: "RatingsTableViewCellTVC", bundle: nil), forCellReuseIdentifier: "cell")
        ratingsTableviewController.delegate = self
        ratingsTableviewController.dataSource = self
        ratingView.layer.cornerRadius = 10
        ratingView.clipsToBounds = true
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
extension RatingsViewControllerVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        
        let titleLabel = UILabel()
        titleLabel.applyLabelStyle(for: .headingBlack)
        titleLabel.numberOfLines = 1 // Adjust according to your layout
        
        let subtitleLabel = UILabel()
        subtitleLabel.applyLabelStyle(for: .headinglightGray)
        //  subtitleLabel.textColor = UIColor.gray
        subtitleLabel.numberOfLines = 1 // Adjust according to your layout
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        
        if section == 0 {
            titleLabel.text = "Restaurants"
            subtitleLabel.text = "  (\(JsonDataArrays.userRatingsDataArray.count))"
        }
        else if section == 1 {
            titleLabel.text = "Items"
            subtitleLabel.text = "  (\(JsonDataArrays.LoginUserItemRatingDataArray.count))"
        }
        else {
            titleLabel.text = "Waiters"
            subtitleLabel.text = "  (\(JsonDataArrays.LoginUserWaiterRatingDataArray.count))"
        }
        
        
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        let totalWidth = titleLabel.frame.size.width + subtitleLabel.frame.size.width + 5 // Adjust spacing as needed
        let availableWidth = headerView.frame.size.width
        
        if totalWidth > availableWidth {
            // Calculate new width ratio for titleLabel based on its content
            let newTitleLabelWidth = titleLabel.frame.size.width * (availableWidth / totalWidth)
            
            titleLabel.frame = CGRect(x: 15, y: 0, width: newTitleLabelWidth, height: 22)
            subtitleLabel.frame = CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.size.width + 5, y: 0, width: availableWidth - newTitleLabelWidth - 20, height: 22)
        } else {
            titleLabel.frame = CGRect(x: 15, y: 0, width: titleLabel.frame.size.width, height: 22)
            subtitleLabel.frame = CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.size.width + 5, y: 0, width: subtitleLabel.frame.size.width, height: 22)
        }
        
        return headerView
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return JsonDataArrays.userRatingsDataArray.isEmpty ? 1 : JsonDataArrays.userRatingsDataArray.count
        }
        else if section == 1{
            return JsonDataArrays.LoginUserItemRatingDataArray.isEmpty ? 1 : JsonDataArrays.LoginUserItemRatingDataArray.count
        }
        else{
            return JsonDataArrays.LoginUserWaiterRatingDataArray.isEmpty ? 1 : JsonDataArrays.LoginUserWaiterRatingDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if JsonDataArrays.userRatingsDataArray.isEmpty &&
            JsonDataArrays.LoginUserItemRatingDataArray.isEmpty &&
            JsonDataArrays.LoginUserWaiterRatingDataArray.isEmpty {
            return ratingsTableviewController.createEmptyCell(with: "All rating data is empty")
        } else {
            
            switch indexPath.section {
            case 0:
                if JsonDataArrays.userRatingsDataArray.isEmpty {
                    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as! EmptyRewardCell
                    emptyCell.messageLabel.text = "All rating data is empty"
                   // emptyCell.Uiimage.image = UIImage(named: "offlineImage")
                    
                    return emptyCell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RatingsTableViewCellTVC
                
                let ratingData = JsonDataArrays.userRatingsDataArray[indexPath.row]
                configureCell(cell, with: ratingData)
                return cell
            case 1:
                if JsonDataArrays.LoginUserItemRatingDataArray.isEmpty {
                    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as! EmptyRewardCell
                    emptyCell.messageLabel.text = "All rating data is empty"
                  //  emptyCell.Uiimage.image = UIImage(named: "noItem")
                    
                    return emptyCell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RatingsTableViewCellTVC
                
                let ratingData = JsonDataArrays.LoginUserItemRatingDataArray[indexPath.row]
                configureCell(cell, with: ratingData)
                return cell
            case 2:
                if JsonDataArrays.LoginUserWaiterRatingDataArray.isEmpty {
                    let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as! EmptyRewardCell
                    emptyCell.messageLabel.text = "All rating data is empty"
                 //   emptyCell.Uiimage.image = UIImage(named: "offlineImage")
                    
                    return emptyCell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RatingsTableViewCellTVC
                
                let ratingData = JsonDataArrays.LoginUserWaiterRatingDataArray[indexPath.row]
                configureCell(cell, with: ratingData)
                return cell
            default:
                fatalError("Invalid section")
            }
            
            
        }
    }
    
    func configureCell(_ cell: RatingsTableViewCellTVC, with ratingData: Any) {
        switch ratingData {
        case let userData as userRatingData:
            // Configure cell with user data
            if let image = userData.RestaurantImage {
                loadImage(from: image) { image in
                    if let img = image {
                        DispatchQueue.main.async {
                            cell.ratingImage.image = img
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.ratingImage.image = emptyImage
                }
            }
            if let convertedDate = convertDateFormat(dateString: userData.ratingDate ?? "") {
                cell.ratingDateLabel.text = convertedDate
            } else {
                print("Failed to convert date.")
            }
            cell.ratingNameLabel.text = "\(userData.RestaurantTitle ?? "") "
            cell.ratingView.rating = Double(userData.Rating ?? 0)
            cell.ratingView.text = "\(Double(userData.Rating ?? 0))"
            //cell.ratingDateLabel.text = userData.ratingDate ?? ""
            cell.reviewLabel.text = userData.Review ?? ""
            cell.conigureShadow()
            
            
        case let itemRatingData as ItemRatingByLoginUserData:
            // Configure cell with item rating data
            if let image = itemRatingData.itemImage {
                loadImage(from: image) { image in
                    if let img = image {
                        DispatchQueue.main.async {
                            cell.ratingImage.image = img
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.ratingImage.image = emptyImage
                }
            }
            if let convertedDate = convertDateFormat(dateString: itemRatingData.RateDate ?? "") {
                cell.ratingDateLabel.text = convertedDate
            } else {
                print("Failed to convert date.")
            }
            cell.ratingNameLabel.text = itemRatingData.itemTitle
            cell.ratingView.rating = Double(itemRatingData.rating ?? 0)
            cell.ratingView.text = "\(Double(itemRatingData.rating ?? 0))"
            
            cell.reviewLabel.text = itemRatingData.review ?? ""
            cell.conigureShadow()
            
        case let waiterRatingData as waiterRatingByLoginUserData:
            // Configure cell with waiter rating data
            if let image = waiterRatingData.waiterImage {
                loadImage(from: image) { image in
                    if let img = image {
                        DispatchQueue.main.async {
                            cell.ratingImage.image = img
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.ratingImage.image = emptyImage
                }
            }
            if let convertedDate = convertDateFormat(dateString: waiterRatingData.RateDate ?? "") {
                cell.ratingDateLabel.text = convertedDate
            } else {
                print("Failed to convert date.")
            }
            cell.ratingNameLabel.text = waiterRatingData.waiterTitle
            cell.ratingView.rating = Double(waiterRatingData.rating ?? 0)
            cell.ratingView.text = "\(Double(waiterRatingData.rating ?? 0))"
            
            cell.reviewLabel.text = waiterRatingData.review ?? ""
            cell.conigureShadow()
            
        default:
            fatalError("Invalid rating data type")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let activeCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantHomeVC", for: indexPath) as! RestaurantHomeVC
        if indexPath.section == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let activeCell = storyboard.instantiateViewController(withIdentifier: "RestaurantHomeVC") as! RestaurantHomeVC
            
            activeCell.selectedFor = "restaurant"
            activeCell.restaurantName = JsonDataArrays.userRatingsDataArray[indexPath.row].RestaurantTitle ?? ""
            activeCell.restaurantID = JsonDataArrays.userRatingsDataArray[indexPath.row].RestaurantID ?? ""
            
            let res = JsonDataArrays.restaurantCompleteDataArray.filter { $0.restaurant.RestaurantID == JsonDataArrays.userRatingsDataArray[indexPath.row].RestaurantID }
            activeCell.selectedRestaurantData = res
            print("--->\(activeCell.restaurantName)")
            activeCell.modalPresentationStyle = .fullScreen
            activeCell.modalTransitionStyle = .coverVertical
            self.present(activeCell, animated: true)
            isCellExpanded[indexPath.row].toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else  if indexPath.section == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let activeCell = storyboard.instantiateViewController(withIdentifier: "RestaurantHomeVC") as! RestaurantHomeVC
            
            activeCell.selectedFor = "dishes"
            activeCell.restaurantName = JsonDataArrays.LoginUserItemRatingDataArray[indexPath.row].itemTitle ?? ""
            //   activeCell.restaurantID = JsonDataArrays.userRatingsDataArray[indexPath.row].RestaurantID ?? ""
            
            let res = JsonDataArrays.itemCompleteDataArray.filter { $0.Item.ItemID == JsonDataArrays.LoginUserItemRatingDataArray[indexPath.row].itemID }
            activeCell.selectedSignatureItem = res
            print("--->\(activeCell.restaurantName)")
            activeCell.modalPresentationStyle = .fullScreen
            activeCell.modalTransitionStyle = .coverVertical
            self.present(activeCell, animated: true)
            // isCellExpanded[indexPath.row].toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let activeCell = storyboard.instantiateViewController(withIdentifier: "WaiterDetailsVC") as! WaiterDetailsVC
            
            // activeCell.selectedFor = "dishes"
            //   activeCell.restaurantName = JsonDataArrays.LoginUserItemRatingDataArray[indexPath.row].itemTitle ?? ""
            //   activeCell.restaurantID = JsonDataArrays.userRatingsDataArray[indexPath.row].RestaurantID ?? ""
            
            let res = JsonDataArrays.WaiterCompleteDataArray.filter { $0.waiter.waiterID == JsonDataArrays.LoginUserWaiterRatingDataArray[indexPath.row].waiterID }
            activeCell.waiterData = res
            activeCell.userDataArray = JsonDataArrays.userDataArray
            activeCell.modalPresentationStyle = .fullScreen
            activeCell.modalTransitionStyle = .coverVertical
            self.present(activeCell, animated: true)
            isCellExpanded[indexPath.row].toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}

