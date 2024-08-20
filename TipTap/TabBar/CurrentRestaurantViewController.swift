//
//  CurrentRestaurantViewController.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//
//
//
//  CurrentRestaurantViewController.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//
//


import UIKit

class CurrentRestaurantViewController: UIViewController {
    var internetCheckTimer : Timer?
    
    
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var CRTableView: UITableView!
    @IBOutlet weak var currentTextView: UITextView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var currentRestaurantName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var restaurantRatingsDataArray = [RestaurantRatingData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
        
        
        setUI()
        CRTableView.delegate = self
        CRTableView.dataSource = self
        
        backView.layer.cornerRadius = 10
        
        if let cr = currentRestauran{
            setData(res: cr.restaurant)
        }else{
            moreButton.isHidden = true
        }
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
    func setData(res:Restaurant){
        titleLabel.text = res.RestaurantTitle
        
        if let image = res.RestaurantImage{
            loadImage(from: image ) { [self] image in
                DispatchQueue.main.sync {
                    if let img = image{
                        restaurantImage.image = img
                    }
                }
                
            }
        }else{
            DispatchQueue.main.sync {
                
                restaurantImage.image = emptyImage
                
            }
        }
        
        
        //        RatingsView.rating = Double(res.RestaurantRating)
        //        RatingsView.text = "\(Double(res.RestaurantRating))"
        restaurantCategoryLabel.text = res.RestaurantCategory
        
        filterRestaurantRatingReview()
        
    }
    func setUI(){
        ratingView.settings.fillMode = .precise
        titleLabel.applyLabelStyle(for: .headingBlack)
        currentRestaurantName.applyLabelStyle(for: .smallheadingBlack)
        //  currentTextView.applyMediumTextViewStyle()
    }
    @IBAction func moreButtonAct(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
        controller.restarentTitle = titleLabel.text ?? ""
        controller.selectedRestaurantData = [currentRestauran!]
        //        controller.selectedSignatureItem = [currentRestauran!]
        controller.selectedFor = "restaurant"
        controller.modalPresentationStyle = .fullScreen
        
        self.present(controller, animated: false, completion: nil)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        // self.dismiss(animated: true)
        let controller = storyboard?.instantiateViewController(identifier: "TabBarController") as! TabBarController
        controller.modalPresentationStyle = .fullScreen
        //controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: false, completion: nil)
    }
    
    
    func filterRestaurantRatingReview(){
        self.restaurantRatingsDataArray.removeAll()
        var  SingaleRestaurantRatingArray : [userRatings] = []
        if let res = currentRestauran{
            SingaleRestaurantRatingArray = res.restaurantRatings
            
        }
        
        print(SingaleRestaurantRatingArray)
        for i in SingaleRestaurantRatingArray {
            // Check if the userVisitedResstaurantArray contains a restaurant with the given RestaurantID
            if let matchingUser = JsonDataArrays.userDataArray.first(where: { $0.UserID == i.UserId
            }) {
                // If found, create a new userVisitedRestaurantData instance with the restaurant
                let userRatingData = RestaurantRatingData(RestaurantratingID: i.RestaurantRateId ?? "", RestaurantID: i.RestaurantId, UserID: matchingUser.UserID, UserTitle: (matchingUser.FirstName ?? "") + " " + (matchingUser.LastName ?? ""), UserImage: matchingUser.Userimage, Rating: i.Rating, Review: i.Review, RatingDate: "")
                // Append the new instance to the array
                self.restaurantRatingsDataArray.append(userRatingData)
            }
            // Handle the case where the restaurant is not found if needed
            else {
                // Handle the case where the restaurant is not found
                // You might want to log an error or handle it in some way
            }
        }
        
        if !SingaleRestaurantRatingArray.isEmpty{
            CRTableView.reloadData()
        }
        
        
    }
    
}
extension CurrentRestaurantViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantRatingsDataArray.isEmpty ? 1 : self.restaurantRatingsDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviewCell = tableView.dequeueReusableCell(withIdentifier: "ViewAllReviewsTVC")as! ViewAllReviewsTVC
        
        if self.restaurantRatingsDataArray.isEmpty {
            // If waiterModel is empty, create a simple cell with a message
            return CRTableView.createEmptyCell(with: "No Reviews")
        }else{
            let review = self.restaurantRatingsDataArray[indexPath.row]
            reviewCell.configure(with: review, currentUserId: loginUserID!)
            return reviewCell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

