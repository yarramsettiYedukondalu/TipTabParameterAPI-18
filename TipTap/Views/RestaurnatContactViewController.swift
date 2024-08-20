//
//  RestaurnatContactViewController.swift
//  TipTap
//
//  Created by yarramsetti yedukondalu on 10/07/24.
//
import UIKit

class RestaurnatContactViewController: UIViewController {
    var selectedFor: String = ""
    @IBOutlet weak var dialButton: UIButton!
    var selected: [Restaurant] = [] // Assuming Restaurant is your data model type
    var selectedRestaurantData = [RestaurantCompleteData]()
    // Connect your outlets as needed
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantPhoneNumberLabel: UILabel!
    //@IBOutlet weak var restaurantLandMarkLabel: UILabel!
    @IBOutlet weak var restaurantZipLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    
    @IBOutlet weak var superDesignView: UIView!
    @IBOutlet weak var designView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // superDesignView.layer.borderWidth = 1
       superDesignView.layer.borderColor = UIColor.black.cgColor
        designView.layer.cornerRadius = 5
        superDesignView.layer.cornerRadius = 5
        // Update UI with selected restaurant data if available
        if let selectedRestaurant = selectedRestaurantData.first {
            restaurantTitleLabel.text = selectedRestaurant.restaurant.RestaurantTitle
            restaurantAddressLabel.text = selectedRestaurant.restaurant.RestaurantAddress
           // restaurantPhoneNumberLabel.text = "\(selectedRestaurant.restaurant.RestaurantPhone)"
            
         //   restaurantLandMarkLabel.text = selectedRestaurant.restaurant.LandMark
            superDesignView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            superDesignView.layer.shadowOpacity = 1
            superDesignView.layer.shadowColor = UIColor.black.cgColor
            superDesignView.layer.shadowRadius = 4
            restaurantZipLabel.text = selectedRestaurant.restaurant.ZipCode.map { String($0) } ?? ""
            
            restaurantPhoneNumberLabel.text = selectedRestaurant.restaurant.RestaurantPhone.map { String($0) } ?? ""
 restaurantCityLabel.text = selectedRestaurant.restaurant.RestaurantCity
            dialButton.layer.borderWidth = 0.5
            dialButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBAction func dialPad(_ sender: Any) {
        guard let phoneNumber = restaurantPhoneNumberLabel.text else { return }
               if let url = URL(string: "tel://\(phoneNumber)") {
                   if UIApplication.shared.canOpenURL(url) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   } else {
                       // Handle the case where the device cannot make calls
                       let alert = UIAlertController(title: "Oops!", message: "Your device cannot make phone calls.", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self.present(alert, animated: true, completion: nil)
                   }
               }
           }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
