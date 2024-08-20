//
//  SplashViewController.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//

import UIKit

class SplashViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var pageControle: UIPageControl!
    var currentPage = 0
    var Slides : [splashScreenSlide] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        skipButton.layer.cornerRadius = 7
        collectionView.delegate = self
        collectionView.dataSource = self
        skipButton.layer.borderWidth = 1.0
        
        skipButton.layer.borderColor = UIColor.red.cgColor
        
        //CGColor(red: 225.0, green: 55.0, blue: 67.0, alpha: 100.0)
       //  Do any additional setup after loading the view.
        
        
        Slides = [splashScreenSlide(title: "Discover Place Near You", descrition: "We make it simple to find the food you crave. Enter your address and let us do the rest", image: UIImage(named: "14")!), splashScreenSlide(title: "Choose A Tasty Dish", descrition: "When you order Eat Street, we'll specials and rewards", image: UIImage(named: "13")!), splashScreenSlide(title: "Pick Up Or Delivery", descrition: "We make food ordering fast, simple and free - no matter if you order online or cash ", image: UIImage(named: "12")!)]
    }
    

    
    @IBAction func skipButtonClicked(_ sender: Any) {
        
        skipButton.backgroundColor = UIColor(red: 224/255.0, green: 50/255.0, blue: 73/255.0, alpha: 1.0)

        skipButton.setTitleColor(UIColor.white, for: .normal)
        
        let controller = self.storyboard?.instantiateViewController(identifier: "Location") as? Location
        controller?.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true)
    }
}

extension SplashViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:SplashScreenCollectionViewCell.identifier, for: indexPath) as! SplashScreenCollectionViewCell
        
        cell.setup(Slides[indexPath.row])
        return cell
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
