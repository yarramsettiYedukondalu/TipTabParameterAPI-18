//
//  FeedBackViewControllerVC.swift
//  TipTap
//
//  Created by ToqSoft on 14/11/23.
//

import UIKit
import SVProgressHUD
class FeedBackViewControllerVC: UIViewController {
    //FeedBackTableViewCellTVC
    var feedBackNames = ["InsightSync","ResponsePulse"]
    var Date  = ["14-11-2023","20-11-2023"]
    @IBOutlet weak var feedBackTVC: UITableView!
    // var isCellExpanded = [Bool](repeating: false, count: ( JsonDataArrays.feedbackArray.count ))
    var userProfilePicUrlString: String?
    @IBOutlet weak var feedBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        fetchFeedbackJsonData()
        feedBackTVC.isHidden = true
        feedBackView.layer.cornerRadius = 10
        feedBackView.clipsToBounds = true
        feedBackTVC.register(UINib(nibName: "FeedBackTableViewCellTVC", bundle: nil), forCellReuseIdentifier: "cell")
        feedBackTVC.register(UINib(nibName: "EmptyRewardCell", bundle: nil), forCellReuseIdentifier: "EmptyRewardCell")
        feedBackTVC.delegate = self
        feedBackTVC.dataSource = self
        
        showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.hideHUD()
            self?.feedBackTVC.isHidden = false
            self?.feedBackTVC.reloadData() // Reload table view after dismissing SVProgressHUD
        }
        userProfilePicUrlString = UserDefaults.standard.string(forKey: "userProfilePicUrl") ?? ""
        
    }
    
    
    
    @IBAction func feedBackButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension FeedBackViewControllerVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if JsonDataArrays.feedbackArray.isEmpty{
            return 1
        }else{
            return JsonDataArrays.feedbackArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if JsonDataArrays.feedbackArray.isEmpty{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as? EmptyRewardCell else {
                
                return UITableViewCell()
            }
            cell.messageLabel.text = "No data is currently available"
            //cell.Uiimage.image = UIImage(named: "offlineImage")
            // Configure the empty cell if needed
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!FeedBackTableViewCellTVC
            cell.HeadingLabel.text = "   \(indexPath.row + 1).   \(JsonDataArrays.feedbackArray[indexPath.row].toimprove ?? "")"
            
            //     cell.setUserImage(urlString:userProfilePicUrlString ?? "")
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.borderWidth = 1.5
            cell.backView.layer.borderColor = UIColor.lightGray.cgColor
            cell.howoftenUseLabel.text = JsonDataArrays.feedbackArray[indexPath.row].oftenuseapp
            cell.mostUsedFeatureLabel.text = JsonDataArrays.feedbackArray[indexPath.row].mostusedfeature
            cell.MotivationLabel.text = JsonDataArrays.feedbackArray[indexPath.row].motivationtouse
            cell.featureNeedToImprove.text = JsonDataArrays.feedbackArray[indexPath.row].toimprove
            cell.howoftenUseLabel.isHidden = false
            cell.howoftenUseLabel.numberOfLines = 0
            
            cell.mostUsedFeatureLabel.isHidden = false
            cell.mostUsedFeatureLabel.numberOfLines = 0
            
            cell.MotivationLabel.isHidden = false
            cell.MotivationLabel.numberOfLines = 0
            
            cell.featureNeedToImprove.isHidden = false
            cell.featureNeedToImprove.numberOfLines = 0
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if JsonDataArrays.feedbackArray.isEmpty{
            return 100
        }
        return 370
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
}
