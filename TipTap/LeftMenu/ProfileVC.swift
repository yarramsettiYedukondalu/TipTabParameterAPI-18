
import UIKit
 
class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var internetCheckTimer : Timer?
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var tableViewBackView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var profileBackView: UIView!
    
    @IBOutlet weak var userProfileImage: UIImageView!
//var titleData = ["Address", "Password", "Refer Friends"]
    var titleData = ["Address"]
    var subTitledata = ["Add or remove a delivery address"]
//    var subTitledata = ["Add or remove a delivery address", "Change Password", "Get SAR 10.00 FREE"]
    
    //var titleArray = ["Favourite", "Visited", "Payments", "UserLog","UserEnquiry", "UserReport"]
    var titleArray = ["Favourite", "Visited", "Payments"]
    //var imagsArray = ["suit.heart", "mappin.and.ellipse","dollarsign.circle.fill", "list.clipboard","person.crop.circle.badge.questionmark","person.text.rectangle"]
    var imagsArray = ["suit.heart", "mappin.and.ellipse","dollarsign.circle.fill"]
    
    //    var RestaurantIDArray = [String]()
    //    var userFavouriteItemIDArray = [UserFavItemIDs]()
    
    var loginuserFavouriteRestaurantArray = [RestaurantCompleteData]() // For store Fav Restaurant
    var loginuserFavouriteItemArray = [ItemCompleteData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
        
        setUI()
        setuserNameFromUserDefaults()
        tableView.delegate = self
        tableView.dataSource = self
        tableViewBackView.layer.cornerRadius = 5
        tableView.layer.cornerRadius = 5
        profileBackView.layer.cornerRadius = 5
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
        titleLabel.applyLabelStyle(for: .buttonTitle)
        userNameLabel.applyLabelStyle(for: .smallheadingBlack)
        userEmailLabel.applyLabelStyle(for: .descriptionDarkGray)
    }
 
    
    func setuserNameFromUserDefaults(){
        let userDefaults = UserDefaults.standard
        let userEmail = userDefaults.string(forKey: "userEmail")
        let userFullName = userDefaults.string(forKey: "userFullName")
        let userFamilyName = userDefaults.string(forKey: "userFamilyName")
        // let userProfilePicUrlString = userDefaults.string(forKey: "userProfilePicUrl")
        let userFName = userDefaults.string(forKey: "FirstName") ?? ""
        let userLName = userDefaults.string(forKey: "LastName") ?? ""
        userNameLabel.text = userFName/* + " " + userLName*/
        userEmailLabel.text = userEmail
        
        if let imageUrlString = UserDefaults.standard.string(forKey: "userProfilePicUrl"),
           let imageUrl = URL(string: imageUrlString) {
            loadImages(from: imageUrl) { [weak self] data in
                guard let imageData = data else {
                    print("Failed to fetch image data.")
                    return
                }
                DispatchQueue.main.async {
                    self?.userProfileImage.image = UIImage(data: imageData)
                }
            }
        } else {
            print("Invalid image URL.")
        }
        func loadImages(from url: URL, completion: @escaping (Data?) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching image: \(error)")
                    completion(nil)
                    return
                }
                completion(data)
            }
            task.resume()
        }
    }
    @IBAction func goBackButtonAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func menuButtonAct(_ sender: UIBarButtonItem) {
        
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
        menuVC.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
        menuVC.loginuserFavouriteItemArray = self.loginuserFavouriteItemArray
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titleData.count
        } else if section == 1 {
            return titleArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            cell.titleLabel.text = titleData[indexPath.row]
            cell.subLabel.text = subTitledata[indexPath.row]
            
            if indexPath.row == 2 {
                cell.subLabel.textColor = UIColor(red: 224/245, green: 50/245, blue: 73/245, alpha: 1)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell2", for: indexPath) as! ProfileTableViewCell2
            
            cell.titleLabel.text = titleArray[indexPath.row]
            
            //            if indexPath.row == 2{
            //                cell.favImage.image = UIImage(named: imagsArray[indexPath.row])
            //            }else{
            cell.favImage.image = UIImage(systemName: imagsArray[indexPath.row])
            //            }
            cell.favImage.tintColor = UIColor.white
            
            if indexPath.row == 0 {
                cell.favImage.backgroundColor = UIColor(red: 224/245, green: 50/245, blue: 73/245, alpha: 1)
                cell.imageBackView.backgroundColor = UIColor(red: 224/245, green: 50/245, blue: 73/245, alpha: 1)
            } else if indexPath.row == 1 {
                cell.favImage.backgroundColor = UIColor(red: 52/245, green: 78/245, blue: 65/245, alpha: 1)
                cell.imageBackView.backgroundColor = UIColor(red: 52/245, green: 78/245, blue: 65/245, alpha: 1)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0{
                //Faviourite
                let controller = storyboard?.instantiateViewController(identifier: "FavoritesVC") as! FavoritesVC
                controller.cellTitle = titleArray[indexPath.row]
                controller.loginuserFavouriteRestaurantArray = self.loginuserFavouriteRestaurantArray
                controller.loginuserFavouriteItemArray = self.loginuserFavouriteItemArray
                self.present(controller, animated: true)
                
                // presentViewController(withIdentifier: ReuseIdentifierConstant.favoritesVCIdentifier)
                
                presentViewController(withIdentifier: ReuseIdentifierConstant.favoritesVCIdentifier)
                
            }else if indexPath.row == 1{
                //Visited
                let controller = storyboard?.instantiateViewController(identifier: "VisitedVC") as! VisitedVC
                controller.cellTitle = titleArray[indexPath.row]
                self.present(controller, animated: true)
            }else if indexPath.row == 2{
                //Payment
                let controller = storyboard?.instantiateViewController(identifier: "UserPaymentViewController") as! UserPaymentViewController
                controller.cellTitle = titleArray[indexPath.row]
                self.present(controller, animated: true)
            }else if indexPath.row == 3{
                //UserLog
                print("userLogs")
                let controller = storyboard?.instantiateViewController(identifier: "UserLogsViewController") as! UserLogsViewController
                controller.cellTitle = titleArray[indexPath.row]
                self.present(controller, animated: true)
            }else if indexPath.row == 4{
                //UserEnquiry
                let controller = storyboard?.instantiateViewController(identifier: "UserEnquiryViewController") as! UserEnquiryViewController
                controller.cellTitle = titleArray[indexPath.row]
                self.present(controller, animated: true)
            }else{
                //UserReport
                let controller = storyboard?.instantiateViewController(identifier: "UserReportViewController") as! UserReportViewController
                controller.cellTitle = titleArray[indexPath.row]
                self.present(controller, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
