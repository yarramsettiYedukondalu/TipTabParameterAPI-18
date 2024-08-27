
import UIKit
protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}
struct CellLoad {
    var opened = Bool()
    var title = String()
    var cellTitle = [String]()
    var subimages = [UIImage]()
}
 
struct SideMenuModel {
    var icon: UIImage
    var title: String
}
class LeftMenuViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var internetCheckTimer : Timer?
    @IBOutlet weak var userprofileImage: UIImageView!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIImageView!
    @IBOutlet weak var leftMenuViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var buttonDismiss: UIButton!
    @IBOutlet var tableViewLeftMenu: UITableView!
    @IBOutlet var buttonImageSlct: UIButton!
    
    @IBAction func goBackAct(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
        controller.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
        controller.loginuserFavouriteItemArray = self.loginuserFavouriteItemArray
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    var btnMenu : UIBarButtonItem!
    var RestaurantIDArray = [String]() //for store user's Favourite restaurant id's
    var userFavouriteItemIDArray = [UserFavItemIDs]()
    
    var loginuserFavouriteRestaurantArray = [RestaurantCompleteData]() // For store Fav Restaurant
    var loginuserFavouriteItemArray = [ItemCompleteData]()
    
    var delegate : SlideMenuDelegate?
    // let leftMenu = ["Dashboard","Task","Fines","Leaves","Overtime"]
    
    //    var imgArray = [#imageLiteral(resourceName: "approve-leave"),#imageLiteral(resourceName: "todays-task"),#imageLiteral(resourceName: "approve-tasks"),#imageLiteral(resourceName: "overtime"),#imageLiteral(resourceName: "todays-task")]
    
    let tag = 0
    var imgs : UIImage!
    
    
    var menu: [SideMenuModel] = [
        
        SideMenuModel(icon: UIImage(systemName: "heart")!, title: "Favourite"),
        SideMenuModel(icon: UIImage(systemName: "flag")!, title: "Visited"),
        SideMenuModel(icon: UIImage(systemName: "rosette")!, title: "Rewards"),
        // SideMenuModel(icon: UIImage(named: "advice-3")!, title: "Tips"),
        SideMenuModel(icon: UIImage(systemName: "bubble.left")!, title: "Feedback"),
        SideMenuModel(icon: UIImage(systemName: "star")!, title: "Ratings"),
        SideMenuModel(icon: UIImage(systemName: "building.2")!, title: "All Restaurants"),
        SideMenuModel(icon: UIImage(systemName: "cup.and.saucer")!, title: "All Cuisines"),
        SideMenuModel(icon: UIImage(systemName: "checkmark.rectangle")!, title: "Signature Dishes")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
        
        // versionLabel.text = "Version " + JsonDataArrays.applicationInformationArray[0].applicationVersion
        setUI()
        // setuserNameFromUserDefaults()
        setUserNameFromUserDefaults()
        profileButton.layer.cornerRadius = profileButton.frame.size.height / 2
        profileButton.clipsToBounds = true
        //profileButton.layer.cornerRadius =
        self.tableViewLeftMenu.reloadData()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            leftMenuViewTrailingConstraint.constant = 520
        }else{
            leftMenuViewTrailingConstraint.constant = 180
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        //        self.tableViewLeftMenu.reloadData()
        tableViewLeftMenu.tableFooterView = UIView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
    
    func setUI(){
        UserNameLabel.applyLabelStyle(for: .headingSmall)
        userPhoneNumberLabel.applyLabelStyle(for: .descriptionSmall)
        userEmailLabel.applyLabelStyle(for: .descriptionSmall)
        versionLabel.applyLabelStyle(for: .headingSmall)
        
        
    }
   
    func setUserNameFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        let userEmail = userDefaults.string(forKey: "userEmail")
        let userFullName = userDefaults.string(forKey: "userFullName")
        let userFamilyName = userDefaults.string(forKey: "userFamilyName")
        let userProfilePicUrlString = userDefaults.string(forKey: "userProfilePicUrl")
        let userFName = userDefaults.string(forKey: "FirstName") ?? ""
        let userLName = userDefaults.string(forKey: "LastName") ?? ""
        
        UserNameLabel.text = userFName /*+ " " + userLNam*/
        userEmailLabel.text = userEmail
        userPhoneNumberLabel.text = userEmail
        
        if let userProfilePicUrlString = userProfilePicUrlString,
           let imageUrl = URL(string: userProfilePicUrlString) {
            // Fetch the image data from the URL
            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    print("Error fetching image: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data fetched from URL")
                    return
                }
                
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.userprofileImage.image = UIImage(data: data)
                }
            }
            task.resume()
        } else {
            print("Invalid image URL")
        }
        
        print("User Email: \(userEmail ?? "")")
        print("User Full Name: \(userFullName ?? "")")
        print("User Family Name: \(userFamilyName ?? "")")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTableViewCell")!
        cell.textLabel?.text = menu[indexPath.row].title
        cell.imageView?.image = menu[indexPath.row].icon
        cell.imageView?.tintColor = .black
        cell.textLabel?.applyLabelStyle(for: .subTitleBlack)
        return cell
        //        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView == tableViewLeftMenu {
            
            switch indexPath.row{
            case 0:
                //Faviourite
                let controller = storyboard?.instantiateViewController(identifier: ReuseIdentifierConstant.favoritesVCIdentifier) as! FavoritesVC
                controller.modalPresentationStyle = .overFullScreen
                controller.cellTitle = menu[indexPath.row].title
                controller.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
                controller.loginuserFavouriteItemArray = self.loginuserFavouriteItemArray
                self.present(controller, animated: true)
            case 1:
                //Visited
                let controller = storyboard?.instantiateViewController(identifier: "VisitedVC") as! VisitedVC
                controller.modalPresentationStyle = .overFullScreen
                controller.cellTitle = menu[indexPath.row].title
                self.present(controller, animated: true)
                break
            case 2:
                //Rewards
                let controller = storyboard?.instantiateViewController(identifier: "RewardsVC") as! RewardsVC
                controller.modalPresentationStyle = .overFullScreen
                self.present(controller, animated: true)
                break
                //            case 3:
                //                //Tips
                //                let controller = storyboard?.instantiateViewController(identifier: "SectionViewController") as! SectionViewController
                //
                //                self.present(controller, animated: true)
                //                break
            case 3:
                //Feedback
                let controller = storyboard?.instantiateViewController(identifier: "FeedBackViewControllerVC") as! FeedBackViewControllerVC
                controller.modalPresentationStyle = .overFullScreen
                self.present(controller, animated: true)
                break
            case 4:
                //Ratings
                let controller = storyboard?.instantiateViewController(identifier: "RatingsViewControllerVC") as! RatingsViewControllerVC
                controller.modalPresentationStyle = .overFullScreen
                self.present(controller, animated: true)
                break
            case 5:
                //All Restaurants
                let controller = storyboard?.instantiateViewController(identifier: ReuseIdentifierConstant.trendingThisWeekVCIdentifier) as! TrendingThisWeekVC
                //  controller.restaurantModel = restaurantModel
                controller.RestaurantIDArray = self.RestaurantIDArray
                controller.modalPresentationStyle = .overFullScreen
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .coverVertical
                self.present(controller, animated: true)
            case 6:
                //All Cusines
                
                let controller = storyboard?.instantiateViewController(identifier: "FeaturedCuisinesDetailVC") as! FeaturedCuisinesDetailVC
                controller.modalPresentationStyle = .overFullScreen
                controller.modalTransitionStyle = .coverVertical
                controller.cuisineModel = cuisinesArrayfromItems
                self.present(controller, animated: true)
            case 7:
                //SignatureDish
                let controller = storyboard?.instantiateViewController(identifier: "SignatureDishesDetailVC") as! SignatureDishesDetailVC
                controller.modalPresentationStyle = .overFullScreen
                controller.modalTransitionStyle = .coverVertical
                controller.signatureDishModel = JsonDataArrays.itemCompleteDataArray.filterSignatureItems()
                self.present(controller, animated: true)
            default :
                break
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
        
    }
    
    @IBAction func buttonDismiss(_ sender: UIButton) {
        
        btnMenu?.tag = 0
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.buttonDismiss){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}
