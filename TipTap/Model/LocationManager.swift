//
//  LocationManager.swift
//  TipTap
//
//  Created by Toqsoft on 12/02/24.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    var restaurants: [Restaurant] = [] // Assuming you have an array of Restaurant objects
    let distanceThreshold: CLLocationDistance = 1
    let restaurant1 = Restaurant(RestaurantID: "1", RestaurantTitle: "Restaurant 1", RestaurantAddress: "Address 1", RestaurantCity: "City 1", RestaurantState: "State 1", ZipCode: 12345, RestaurantPhone: 1234567890, RestaurantCategory: "Category 1", OpeningHours: "9:00 AM - 10:00 PM", IsPromoted: true, Longitude: 77.59665331846394, Latitude: 12.947046506828527, LandMark: "Landmark 1", RestaurantImage: "image1.jpg", Disable: false, Description: "Description 1")
    
    let restaurant2 = Restaurant(RestaurantID: "2", RestaurantTitle: "Restaurant 2", RestaurantAddress: "Address 2", RestaurantCity: "City 2", RestaurantState: "State 2", ZipCode: 54321, RestaurantPhone: 9876543210, RestaurantCategory: "Category 2", OpeningHours: "10:00 AM - 11:00 PM", IsPromoted: false, Longitude: 77.59665331846393, Latitude: 12.947046506828525, LandMark: "Landmark 2", RestaurantImage: "image2.jpg", Disable: true, Description: "Description 2")
    
    let restaurant3 = Restaurant(RestaurantID: "3", RestaurantTitle: "Restaurant 3", RestaurantAddress: "Address 3", RestaurantCity: "City 3", RestaurantState: "State 3", ZipCode: 67890, RestaurantPhone: 1357924680, RestaurantCategory: "Category 3", OpeningHours: "11:00 AM - 12:00 PM", IsPromoted: true, Longitude: 77.59665331846392, Latitude: 12.947046506828524, LandMark: "Landmark 3", RestaurantImage: "image3.jpg", Disable: false, Description: "Description 3")
    
    let restaurant4 = Restaurant(RestaurantID: "4", RestaurantTitle: "Restaurant 4", RestaurantAddress: "Address 4", RestaurantCity: "City 4", RestaurantState: "State 4", ZipCode: 24680, RestaurantPhone: 2468013579, RestaurantCategory: "Category 4", OpeningHours: "12:00 PM - 1:00 PM", IsPromoted: false, Longitude: 77.59665331846391, Latitude: 12.947046506828523, LandMark: "Landmark 4", RestaurantImage: "image4.jpg", Disable: true, Description: "Description 4")
    
    let restaurant5 = Restaurant(RestaurantID: "5", RestaurantTitle: "Restaurant 5", RestaurantAddress: "Address 5", RestaurantCity: "City 5", RestaurantState: "State 5", ZipCode: 13579, RestaurantPhone: 9876543210, RestaurantCategory: "Category 5", OpeningHours: "1:00 PM - 2:00 PM", IsPromoted: true, Longitude: 77.59665331846390, Latitude: 12.947046506828522, LandMark: "Landmark 5", RestaurantImage: "image5.jpg", Disable: false, Description: "Description 5")
    
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startMonitoringSignificantLocationChanges()
        // Replace JsonDataArrays.restaurantModel with the array of restaurants you've created
        self.restaurants = [
            restaurant1,
            restaurant2,
            restaurant3,
            restaurant4,
            restaurant5
        ]
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // This method will be called when a significant location change is detected
        
        guard let currentLocation = locations.last else { return }
        
        for restaurant in restaurants {
            guard let latitude = restaurant.Latitude, let longitude = restaurant.Longitude else { continue }
            let restaurantLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            let distance = currentLocation.distance(from: restaurantLocation)
            // Assuming distanceThreshold is defined as in the previous example
            if distance <= distanceThreshold {
                // Restaurant location is within the threshold
                sendLocalNotification(for: restaurant)
                break // Exit loop after sending the first notification
            }
        }
    }
    
    func sendLocalNotification(for restaurant: Restaurant) {
        let content = UNMutableNotificationContent()
        content.title = "You are near \(restaurant.RestaurantTitle ?? "a restaurant")"
        content.body = "Would you like to check it out?"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "restaurantNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location Authorization:",status)
        switch status {
        case .authorizedAlways:
            // Location services authorized, continue
            locationManager.startUpdatingLocation() // Start receiving location updates
        case .denied, .restricted:
            print("Location services denied or restricted")
            // Handle denied/restricted case
        case .notDetermined:
            // Location services not yet determined, request authorization
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unknown case for CLLocationManager authorization status")
        }
    }
}
