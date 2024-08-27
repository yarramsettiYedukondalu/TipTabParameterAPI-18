


import UIKit
import AVKit
import GoogleSignIn
import Network
class GoogleSignInVC: UIViewController {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var monitor: NWPathMonitor?
    var loginUserData: UserData?
    @IBOutlet weak var googleSignInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUpVideo()
        // Check internet connectivity
        monitor = NWPathMonitor()
        monitor?.start(queue: DispatchQueue.global(qos: .background))
        monitor?.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                // Internet connection is available
            } else {
                // No internet connection
                DispatchQueue.main.async {
                    // self?.showNoInternetAlert()
                    let controller = self?.storyboard?.instantiateViewController(identifier: "InternetViewController") as? InternetViewController
                    controller?.modalTransitionStyle = .coverVertical
                    controller?.modalPresentationStyle = .fullScreen
                    self?.present(controller!, animated: true)
                }
            }
        }
    }
    deinit {
        monitor?.cancel()
    }
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func setUI() {
        googleSignInButton.setImage(UIImage(named: "google")?.withRenderingMode(.alwaysOriginal), for: .normal)
        googleSignInButton.setTitle(" Sign In with Google ", for: .normal)
        googleSignInButton.titleLabel?.applyLabelStyle(for: .buttonTitle)
        googleSignInButton.layer.borderWidth = 2.0
        googleSignInButton.layer.borderColor = UIColor.white.cgColor
        googleSignInButton.layer.cornerRadius = 5
    }
    func setUpVideo() {
        let videoURL = Bundle.main.url(forResource: "WhatsApp Video 2023-10-27 at 15.25.23", withExtension: "mp4")!
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = view.bounds
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        player?.play()
    }
    @IBAction func googleSignInButtonDidTap(_ sender: UIButton) {
        guard isInternetAvailable() else {
            // Show no internet alert
            // showNoInternetAlert()
            let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as? InternetViewController
            controller?.modalTransitionStyle = .coverVertical
            controller?.modalPresentationStyle = .fullScreen
            self.present(controller!, animated: true)
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard error == nil, let user = signInResult?.user else {
                // Handle sign-in error
                print("Sign-in error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self?.handleSignInSuccess(user: user)
        }
    }

    func handleSignInSuccess(user: GIDGoogleUser) {
        let emailAddress = user.profile?.email ?? ""
        let fullName = user.profile?.name ?? ""
        let familyName = user.profile?.familyName ?? ""
        let profilePicUrl = user.profile?.imageURL(withDimension: 320)?.absoluteString ?? ""
 
        if let imageURL = URL(string: profilePicUrl) {
            loadImages(from: imageURL) { [weak self] data in
                guard let imageData = data else {
                    print("Failed to fetch image data.")
                    return
                }
                print("Fetched image data from URL.")
 
                self?.fetchUserData(email: emailAddress) { userData in
                    if let userData = userData {
                        // User exists, store data and proceed
                        self?.loginUserData = userData
                        self?.storeUserDataInUserDefaults(userData)
                        DispatchQueue.main.async {
                            self?.presentSplashViewController()
                        }
                        // Execute functions in the background
                        DispatchQueue.global(qos: .background).async {
                            // update last login here in user table
                            self?.updateUserLastLogin(User: userData)
                            
                            // user log table post
                            self?.postUserLogs(User: userData)
                        }
                    } else {
                        // User does not exist, post user data
                        self?.postUserData(firstName: fullName, lastName: familyName, email: emailAddress, userImage: profilePicUrl)
                    }
                }
            }
        } else {
            print("Invalid image URL.")
        }
    }
    func storeUserDataInUserDefaults(userData: UserData) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(userData.Email, forKey: "userEmail")
        userDefaults.set(userData.FirstName, forKey: "userFullName")
       // userDefaults.set(userData., forKey: "userFamilyName")
        userDefaults.set(userData.Userimage, forKey: "userProfilePicUrl")
        userDefaults.synchronize()
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
 
    func postUserLogs(User: UserData){
        let urlString = userLogURL
        guard let apiUrl = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        guard let loginUserID = loginUserID, loginUserID != "" else{return}
        print("Request URL: \(apiUrl)")
        // Create the URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let currentDateTime = dateFormatter.string(from: Date())
        print(currentDateTime)
        // Create the request body
        let requestBody: [String: Any] =  [
            "UserID": loginUserID,
            "LogType": "User",
            "LogDateTime": currentDateTime,
            "LogDetails": "GSignIn"
        ]
        // Convert the request body to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                // Handle the error, e.g., show an alert to the user
                return
            }
            
            // Handle the response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    print("logtable post successfully")
                } else {
                    
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    // Handle other status codes if needed
                }
            }
            
        }.resume()
    }
    func  updateUserLastLogin(User: UserData){
        guard let updateURL = URL(string: userURL) else {
            print("Invalid API URL")
            return
        }
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        print(currentDate)
        
        let updatedDetails: [String: Any] = [
            "PartitionKey": "User",
            "RowKey" : User.Email!,
            "UserID" : User.UserID! ,
            "LastLoginDate": currentDate
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updatedDetails)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON data sent to server: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            
            print("Error encoding JSON: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error updating lastLogin in userTable: \(error.localizedDescription)")
                
            } else if let response = response as? HTTPURLResponse {
                if (200..<300).contains(response.statusCode) {
                    if let data = data {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Server response: \(responseString ?? "")")
                    }
                    
                } else {
                    print("Server returned an error: \(response.statusCode)")
                    
                }
            }
        }
        
        task.resume()
    }
    func fetchUserData(email: String, completion: @escaping (UserData?) -> Void) {
        let apiUrlString = userURL + "?rowkey=\(email)"
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            completion(nil)
            return
        }
        
        fetchJSONData(from: apiUrl) { (result: Result<fetchUserApiResponse, APIError>) in
            switch result {
            case .success(let jsonData):
                if let record = jsonData.record {
                    
                    completion(record)
                    
                } else {
                    completion(nil) // No records found
                }
                
            case .failure(let error):
                print("Error in fetchUserData: \(error)")
                completion(nil) // Error occurred
            }
        }
    }
    func postUserData(firstName: String, lastName: String, email: String, userImage: String) {
        // Construct URL using URLComponents
        let apiUrlString = userURL
        
        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        // Create the request body
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        let requestBody: [String: Any] = [
            "FirstName": firstName,
            "LastName": lastName,
            "Email": email,
            "PasswordHash": "", // Add password if needed
            "UserType": "User",
            "Userimage": userImage,
            "RegistrationDate": currentDate,
            "LastLoginDate": currentDate,
            "Disable": false
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                // Handle post failure
                return
            }
            
            // Handle the response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    print("User Registered successfully")
                    
                    // Fetch user data again
                    self?.fetchUserData(email: email) { [weak self] userData in
                        if let userData = userData {
                            // User data fetched successfully, store in UserDefaults
                            self?.storeUserDataInUserDefaults(userData)
                            
                            // Move to the next screen
                            DispatchQueue.main.async {
                                self?.presentSplashViewController()
                            }
                        } else {
                            DispatchQueue.main.async {
                                
                                
                                self?.showAlert(title : "User" , message: "Something went wrong")
                            }
                            print("Failed to fetch user data after posting")
                        }
                    }
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    // Handle post failure
                }
            }
        }.resume()
    }
    
    func storeUserDataInUserDefaults(_ userData: UserData) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(userData.UserID, forKey: "UserID")
        userDefaults.set(userData.Email, forKey: "userEmail")
        userDefaults.set(userData.FirstName, forKey: "FirstName")
        userDefaults.set(userData.LastName, forKey: "LastName")
        userDefaults.set(userData.Userimage, forKey: "userProfilePicUrl")
        userDefaults.set(userData.LastLoginDate, forKey: "LastLoginDate")
        userDefaults.synchronize() // Ensure UserDefaults changes are saved immediately
    }
    
    func storeUserDataInUserDefaults() {
        guard let userData = loginUserData else {
            return
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userData.UserID, forKey: "UserID")
        userDefaults.set(userData.Email, forKey: "userEmail")
        userDefaults.set(userData.FirstName, forKey: "FirstName")
        userDefaults.set(userData.LastName, forKey: "LastName")
        userDefaults.set(userData.Userimage, forKey: "userProfilePicUrl")
        userDefaults.set(userData.LastLoginDate, forKey: "LastLoginDate")
    }
    
    func presentSplashViewController() {
        if let controller = storyboard?.instantiateViewController(identifier: "splashScreens") as? splashScreens {
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        }
    }
    
    func isInternetAvailable() -> Bool {
        return monitor?.currentPath.status == .satisfied
    }
}
 

func convertImageToBase64(from imageURL: URL, completion: @escaping (String?) -> Void) {
    // Create a URLSession instance
    let session = URLSession.shared
 
    // Create a data task to load the image data asynchronously
    let task = session.dataTask(with: imageURL) { (data, response, error) in
        // Check for errors
        if let error = error {
            print("Failed to load image data: \(error)")
            completion(nil)
            return
        }
 
        // Ensure that data is not nil
        guard let imageData = data else {
            print("No image data received")
            completion(nil)
            return
        }
 
        print("Image data size: \(imageData.count) bytes")
        
        // Convert the image data to Base64-encoded string
        let base64String = imageData.base64EncodedString()
 
        // Call the completion handler with the Base64-encoded string
        completion(base64String)
    }
 
    // Start the data task
    task.resume()
}
