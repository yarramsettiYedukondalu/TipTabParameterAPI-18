import UIKit
import ImageIO

class PaymentSuccessViewController: UIViewController {
    @IBOutlet weak var waiterImage: UIImageView!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var image: UIImageView!
    var transactionHistory: [Transaction] = []
    var name:String = ""
    @IBOutlet weak var dataLabel: UILabel!
    var amount:String = ""
    var personImage :String?
    var data:String = ""
    var waiterTransction:String = ""
    // Property to track if the animation has already been played
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    private var hasPlayedAnimation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print(waiterTransction)
        designView.cellBackViewShadow()
        nameLabel.text = "\(name)"
        amountLabel.text = "SAR:  \(amount)"
        dataLabel.text = data
        if let url = URL(string: personImage ?? "") {
               print("Loading image from URL: \(url)")
               loadImage(from: url) { [weak self] image in
                   DispatchQueue.main.async {
                       if let image = image {
                           print("Image downloaded successfully")
                           self?.waiterImage.image = image
                       } else {
                           print("Failed to download image")
                       }
                   }
               }
           } else {
               print("Invalid URL: \(personImage)")
           }
        // Check if the animation has already been played
        if !hasPlayedAnimation {
            if let gifURL = Bundle.main.url(forResource: "Animation - 1723182018748", withExtension: "gif"),
               let gifData = try? Data(contentsOf: gifURL) {
                // Create an animated image without looping
                image.image = UIImage.animatedImageOnce(with: gifData, speed: 15)
                
                // Mark the animation as played
                hasPlayedAnimation = true
            }
        }
    }
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned from server")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            if image == nil {
                print("Unable to create image from data")
            }
            
            completion(image)
        }.resume()
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func viewDetails(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PaymentDetailsPageViewController")as! PaymentDetailsPageViewController
        
        controller.dateFiled = data
        controller.waiterName = name
        controller.waiterAmount = amount
      
        controller.waiterProfileImage = personImage
        controller.waiterTransction = waiterTransction
        controller.modalTransitionStyle = .flipHorizontal
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func doneButton(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "TipTapHomeVC")as! TipTapHomeVC
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
      //  controller. = personImage ?? ""
        self.present(controller, animated: true)
        
    }
    
}

extension UIImage {
    static func animatedImageOnce(with gifData: Data, speed: Double) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else {
            return nil
        }
        
        var images: [UIImage] = []
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        
        let duration = Double(images.count) / speed
        
        // Create an animated image that plays only once
        let animatedImage = UIImage.animatedImage(with: images, duration: duration)
        
        // Set the animationRepeatCount to 1 and return the final frame after animation
        let imageView = UIImageView(image: animatedImage)
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            imageView.stopAnimating()
        }
        
        return animatedImage
    }
}

