
import UIKit

class splashScreens: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControle: UIPageControl!
    var currentPage = 0
    var Slides : [splashScreenSlide] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.layer.cornerRadius = 7
        collectionView.delegate = self
        collectionView.dataSource = self
        skipButton.layer.borderWidth = 1.0
        //skipButton.layer.borderColor = UIColor.red.cgColor
        //CGColor(red: 225.0, green: 55.0, blue: 67.0, alpha: 100.0)
       //  Do any additional setup after loading the view.
       let Slidesdata = [splashScreenSlide(title: "Good Dining Experience", descrition: "Elevate your dining experience", image: UIImage(named: "men")!), splashScreenSlide(title: "Easy Tipping", descrition: "Easy tipping processing,allowing you to express your appreciation effortlessly.", image: UIImage(named: "MicrosoftTeams-image")!), splashScreenSlide(title: "Pick Up Or Delivery", descrition: "We make food ordering fast, simple and free - no matter if you order online or cash ", image: UIImage(named: "MicrosoftTeams")!)]
        Slides.append(contentsOf: Slidesdata)
    }
    @IBAction func skipButtonClicked(_ sender: Any) {
           if Reachability.isConnectedToNetwork() {
               navigateToLocationController()
           } else {
               navigateToInternetViewController()
           }
       }

       func navigateToLocationController() {
           let controller = self.storyboard?.instantiateViewController(identifier: "Location") as? Location
           controller?.modalPresentationStyle = .fullScreen
           self.present(controller!, animated: true)
       }

       func navigateToInternetViewController() {
           let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as? InternetViewController
           controller?.modalPresentationStyle = .fullScreen
           self.present(controller!, animated: true)
       }
}
extension splashScreens : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"GoogleProfileSplashScreenCVC", for: indexPath) as! GoogleProfileSplashScreenCVC
            cell.setup()
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:SplashScreenCollectionViewCell.identifier, for: indexPath) as! SplashScreenCollectionViewCell
            
            cell.setup(Slides[indexPath.row - 1])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
        pageControle.currentPage = currentPage
    }

}

