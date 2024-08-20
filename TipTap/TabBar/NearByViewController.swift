//
//  NearByViewController.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//

import UIKit
import GoogleMaps
import CoreLocation

struct RestaurantDataInMap{
    
    var restaurant : RestaurantCompleteData
    var marker: GMSMarker?  // Add a marker property to store the corresponding marker
    
}

class NearByViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, CustomPopupDelegate {
    var internetCheckTimer : Timer?
    
    var selectedMarker: GMSMarker?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLAbel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    //var currentLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 12.9475029, longitude: 77.596685)
    var Restaurant_Data: [RestaurantCompleteData] = []
    var RestaurantDataWithMarker : [RestaurantDataInMap] = []
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.register(EmptyCell.self, forCellWithReuseIdentifier: "emptyCell")
        titleLAbel.applyLabelStyle(for: .headingBlack)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = false
        backView.layer.cornerRadius = 10
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        
        // Request location permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        fetchNearByRestaurant()
        // Start updating location
        locationManager.startUpdatingLocation()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
        
        
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
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Handle the updated location
        //    let currentLocations = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
        //   longitude: location.coordinate.longitude)
        
        currentLocation = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation!.latitude, longitude: currentLocation!.longitude, zoom: 13.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        fetchNearByRestaurant()
        print("Current Latitude: \(currentLocation?.latitude ?? 0.0), Longitude: \(currentLocation!.longitude)")
        // Update the map view to the current location
        // mapView.animate(toLocation: currentLocation)
        // Optionally, you can stop updating location if you only need it once
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchNearByRestaurant() {
        // Filter restaurants within 1 kilometer from the current location
        if let currentLocation = currentLocation {
            Restaurant_Data.removeAll()
            RestaurantDataWithMarker.removeAll()
            for restaurant in JsonDataArrays.restaurantCompleteDataArray {
                if let latitude = restaurant.restaurant.Latitude, let longitude = restaurant.restaurant.Longitude {
                    let restaurantLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    print(latitude, longitude)
                    let distance = currentLocation.distance(to: restaurantLocation)
                    let distanceInKilometers = distance / 1000.0 // Convert to kilometers
                    
                    print("Distance : \(distanceInKilometers) km")
                    if distanceInKilometers <= 1.0 {
                        Restaurant_Data.append(restaurant)
                        RestaurantDataWithMarker.append(RestaurantDataInMap(restaurant: restaurant))
                    }
                }
            }
            
            if !RestaurantDataWithMarker.isEmpty {
                collectionview.reloadData()
            }
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "TabBarController") as! TabBarController
        controller.modalPresentationStyle = .fullScreen
        //controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: false, completion: nil)
    }
    
    
    func addMarker(title: String, snippet: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, index:Int) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
        marker.userData = ["index" : index]
        
        RestaurantDataWithMarker[index].marker = marker
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let customPopup = CustomPopupView.loadFromNib() as? CustomPopupView else {
            return nil
        }
        customPopup.delegate = self
        
        // Customize the content of the popup view based on the marker
        if let userData = marker.userData as? [String: Any], let index = userData["index"] as? Int {
            // Handle the marker tap using the index
            print("Marker tapped with index: \(index)")
            let restaurant =  RestaurantDataWithMarker[index].restaurant.restaurant
            customPopup.titleLabel.text = restaurant.RestaurantTitle
            customPopup.descriptionLabel.text = restaurant.Description
            //            customPopup.ratingsView.rating = Double(restaurant.RestaurantRating)
            //            customPopup.ratingsView.text = "\(Double(restaurant.RestaurantRating))"
            
            if let image = restaurant.RestaurantImage {
                loadImage(from: image ) { image in
                    if let img = image{
                        DispatchQueue.main.sync {
                            customPopup.imageView.image = img
                        }
                    }
                }
            }else{
                DispatchQueue.main.sync {
                    customPopup.imageView.image = emptyImage
                }
            }
            
            
            
            
            
        }
        
        return customPopup
    }
    
    func didTapDirectionButton(index: Int) {
        let selectedRestaurant = RestaurantDataWithMarker[index]
        
        // Check if Google Maps is installed on the device
        if let url = URL(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(url) {
                // Open Google Maps with navigation
                let googleMapsURL = "comgooglemaps://?saddr=&daddr=\(selectedRestaurant.restaurant.restaurant.Latitude),\(selectedRestaurant.restaurant.restaurant.Longitude)&directionsmode=driving"
                if let url = URL(string: googleMapsURL) {
                    UIApplication.shared.open(url)
                }
            } else {
                // If Google Maps is not installed, open the browser with Google Maps website
                let googleMapsURL = "https://www.google.com/maps/dir/?api=1&destination=\(selectedRestaurant.restaurant.restaurant.Latitude),\(selectedRestaurant.restaurant.restaurant.Longitude)&travelmode=driving"
                if let url = URL(string: googleMapsURL) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    
    func didTapDismissButton() {
        // Dismiss the presenting view controller (assuming the custom popup is presented modally)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //navigate to details page
        
        let restarantHomeVC = storyboard?.instantiateViewController(identifier: "RestaurantHomeVC") as! RestaurantHomeVC
        
        var row  = 0
        
        
        if let userData = marker.userData as? [String: Any], let index = userData["index"] as? Int {
            // Handle the marker tap using the index
            row = index
            print("Marker tapped with index: \(index)")
        }
        
        restarantHomeVC.modalPresentationStyle = .fullScreen
        restarantHomeVC.modalTransitionStyle = .coverVertical
        restarantHomeVC.restaurantName = marker.title!
        restarantHomeVC.selectedFor = "restaurant"
        
        restarantHomeVC.selectedRestaurantData = [RestaurantDataWithMarker[row].restaurant]
        self.present(restarantHomeVC, animated: true, completion: nil)
    }
    
    func animateSelectedMarker() {
        guard let marker = selectedMarker else {
            return
        }
        
        let originalPosition = marker.position
        
        // Adjust the marker position to create a bounce effect
        let bouncePosition = CLLocationCoordinate2D(latitude: originalPosition.latitude + 0.002, longitude: originalPosition.longitude )
        
        // Animate the marker to the bounce position
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        marker.position = bouncePosition
        CATransaction.commit()
        
        // After a short delay, return the marker to its original position
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            marker.position = originalPosition
            CATransaction.commit()
        }
    }
    
    
    
    
}
extension NearByViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if RestaurantDataWithMarker.isEmpty{
            return 1
        }else{
            return RestaurantDataWithMarker.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if RestaurantDataWithMarker.isEmpty{
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? EmptyCell ?? EmptyCell()
            emptyCell.textLabel.text = "No nearby restaurants found."
            return emptyCell
        } else{
            let activeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyListViewCVC", for: indexPath) as! NearbyListViewCVC
            let data = RestaurantDataWithMarker[indexPath.row].restaurant
            
            if let image = data.restaurant.RestaurantImage {
                loadImage(from: image) { image in
                    if let img = image {
                        DispatchQueue.main.async {
                            activeCell.listViewImage.image = img
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    activeCell.listViewImage.image = emptyImage
                }
            }
            
            if let restaurantAddress = data.restaurant.RestaurantAddress {
                activeCell.offerTypeLabel.text = restaurantAddress
            }
            if let restaurantCategory = data.restaurant.RestaurantCategory {
                activeCell.veraityLabel.text = restaurantCategory
            }
            if let restaurantTitle = data.restaurant.RestaurantTitle {
                activeCell.hotelNameLabel.text = restaurantTitle
            }
            if let description = data.restaurant.Description {
                activeCell.descrictionLabel.text = description
            }
            
            if let latitude = data.restaurant.Latitude, let longitude = data.restaurant.Longitude {
                addMarker(title: data.restaurant.RestaurantTitle ?? "", snippet: data.restaurant.Description ?? "", latitude: latitude, longitude: longitude, index: indexPath.row)
            }
            
            return activeCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRestaurant = RestaurantDataWithMarker[indexPath.row]
        if let selectMarker = selectedRestaurant.marker {
            self.selectedMarker = selectMarker
            
            // Animate the selected marker
            animateSelectedMarker()
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let cellWidth = (collectionView.bounds.width - 10)
        //        let cellHeight = (collectionView.bounds.height / 2.5)
        return CGSize(width: cellWidth, height: 150)
        
    }
    
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location1.distance(from: location2)
    }
}
