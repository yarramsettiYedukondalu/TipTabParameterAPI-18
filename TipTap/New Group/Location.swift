import UIKit
import Reachability
import GoogleMaps
import CoreLocation

class Location: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var niceTomeetYouLAbel: UILabel!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocationButton.layer.cornerRadius = 7
        setUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Handle the updated location
        let currentLocation = location.coordinate
        
        print("Current Latitude: \(currentLocation.latitude), Longitude: \(currentLocation.longitude)")
        
        locationManager.stopUpdatingLocation()
        
        // Move to next view controller (tab bar controller) after getting location
       
    }
    
    func setUI(){
        niceTomeetYouLAbel.applyLabelStyle(for: .largeHeadingBlack)
        descriptionLabel.applyLabelStyle(for: .descriptionDarkGray)
        currentLocationButton.titleLabel?.applyLabelStyle(for: .buttonTitle)
    }
    
    @IBAction func CurrentLocationButtonAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManagerDidChangeAuthorization(locationManager)
            navigateToLocationController()
        } else {
            navigateToInternetViewController()
        }
    }
    
    func navigateToLocationController() {
        let controller = self.storyboard?.instantiateViewController(identifier: "TabBarController") as? TabBarController
        controller?.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true)
    }

    func navigateToInternetViewController() {
        let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as? InternetViewController
        controller?.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle denied or restricted access
            print("Location access denied or restricted.")
        case .notDetermined:
            // Handle not determined
            print("Location access not determined.")
        @unknown default:
            fatalError("Unknown case in locationManagerDidChangeAuthorization")
        }
    }
}

