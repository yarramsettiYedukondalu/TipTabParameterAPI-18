//
//  AllReviewsVC.swift
//  TipTap
//
//  Created by Toqsoft on 16/11/23.
//

import UIKit

class AllReviewsVC: UIViewController {
    var RestaurantRating   = true
    var reviewModel = [ReviewModel]()
    var restaurantRatingsDataArray = [RestaurantRatingData]()
    var ItemRatingReviewDataArray = [ItemRatingReviewData]()
    @IBOutlet weak var allreviewsTableview: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var allreviewsHeadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        allreviewsTableview.delegate = self
        allreviewsTableview.dataSource = self
        
    }
    func setupUI(){
        allreviewsHeadingLabel.applyLabelStyle(for: .subTitleBlack)
        closeButton.titleLabel?.applyLabelStyle(for: .subTitleBlack)
    }
    
    
    @IBAction func dismissbutton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
extension AllReviewsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantRating ? restaurantRatingsDataArray.count : ItemRatingReviewDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviewCell = allreviewsTableview.dequeueReusableCell(withIdentifier: "ViewAllReviewsTVC")as! ViewAllReviewsTVC
        if RestaurantRating{
            
            if restaurantRatingsDataArray.isEmpty{
                // If waiterModel is empty, create a simple cell with a message
                return allreviewsTableview.createEmptyCell(with: "No Reviews")
            }else{
                let review = restaurantRatingsDataArray[indexPath.row]
                reviewCell.configure(with: review, currentUserId: loginUserID!)
                
            }
        }else{
            if ItemRatingReviewDataArray.isEmpty {
                return allreviewsTableview.createEmptyCell(with:  "No Reviews For Items")
            }else{
                let review = ItemRatingReviewDataArray[indexPath.row]
                reviewCell.configureWithItem(with: review, currentUserId: loginUserID!)
            }
        }
        return reviewCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}


