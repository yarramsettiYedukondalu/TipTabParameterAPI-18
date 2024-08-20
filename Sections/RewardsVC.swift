//
//  RewardsVC.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/23.
//

import UIKit
import SVProgressHUD

struct userRewardsData{
    var RestaurantTitle : String
    var PointsEarned : Int
    var DateEarned : String
    var RestaurantImage : String
}
class RewardsVC: UIViewController {
    @IBOutlet weak var rewardsView: UIView!
    var isCellExpanded =  [Bool](repeating: false, count: (JsonDataArrays.userRewardsDataArray.count ))
    @IBOutlet weak var rewardsTVC: UITableView!
    //  var RestaurantIDArray = [Int]()
    @IBOutlet weak var rewardsButtonAction: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if JsonDataArrays.userRewardsDataArray.isEmpty{
            isCellExpanded = [false]
        }
        rewardsView.layer.cornerRadius = 10
        rewardsView.clipsToBounds = true
        
        rewardsTVC.register(UINib(nibName: "RewardsTableViewCellTVC", bundle: nil), forCellReuseIdentifier: "cell")
        rewardsTVC.register(UINib(nibName: "EmptyRewardCell", bundle: nil), forCellReuseIdentifier: "EmptyRewardCell")
        rewardsTVC.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        // Show SVProgressHUD
        
        showHUD()
        
        // Delay execution of code to show SVProgressHUD
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            
            self?.hideHUD()
            self?.rewardsTVC.dataSource = self
            self?.rewardsTVC.delegate = self
            
            self?.rewardsTVC.reloadData() // Reload table view after dismissing SVProgressHUD
        }
    }
    @IBAction func ButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
extension RewardsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return JsonDataArrays.userRewardsDataArray.count
        return JsonDataArrays.userRewardsDataArray.isEmpty ? 1 : JsonDataArrays.userRewardsDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if JsonDataArrays.userRewardsDataArray.isEmpty{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as? EmptyRewardCell else {
                
                return UITableViewCell()
            }
            cell.messageLabel.text = "There are no rewards credited to you."
           // cell.messageLabel.applyLabelStyle(for: .subTitleLightGray)
            //cell.Uiimage.image = UIImage(named: "RewardsImage")
            // Configure the empty cell if needed
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifierConstant.rewardsCellIdentifier, for: indexPath) as? RewardsTableViewCellTVC else {
                return UITableViewCell()
            }
            
            let rewardData = JsonDataArrays.userRewardsDataArray[indexPath.row]
            // Set contentInset to add space around the table view
            //            loadImage(from: rewardData.RestaurantImage) { image in
            //                if let img = image{
            //                    DispatchQueue.main.sync {
            //
            //                        cell.rewardsImage.image = img
            //                    }
            //                }
            //            }
            let image = rewardData.RestaurantImage
            
            guard let imageUrl = URL(string: image) else {
                print("Invalid URL: \(image)")
                return UITableViewCell()
            }
            ImageLoader.shared.loadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    cell.rewardsImage.image = image
                }
            }
            
            
            cell.rewardsName.text = rewardData.RestaurantTitle
            cell.rewardsDate.text = rewardData.DateEarned
            cell.rewardsTipTab.text = "\(rewardData.PointsEarned)"
            
            cell.bgView.layer.cornerRadius = 5
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
            
            cell.describtionLabel.isHidden = true
            cell.chervonImage.image =
            UIImage(systemName: "chevron.down")
            cell.chervonImage.tintColor = .black
            if isCellExpanded[indexPath.row] {
                
                cell.chervonImage.image =
                UIImage(systemName: "chevron.up")
                cell.chervonImage.tintColor = .black
                
                //  cell.bgView.backgroundColor = UIColor(red: 187/245, green: 197/245, blue: 215/245, alpha: 1)
                
                cell.describtionLabel.text = "Congratulation you have Earned \(rewardData.PointsEarned) Points in \(rewardData.RestaurantTitle) Restaurant."
                cell.describtionLabel.isHidden = false
                cell.describtionLabel.numberOfLines = 0
                
            } else {
                cell.describtionLabel.numberOfLines = 4
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if JsonDataArrays.userRewardsDataArray.isEmpty {
            return 120
        } else {
            
            return isCellExpanded[indexPath.row] ? 200 : 40
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isCellExpanded[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
}
