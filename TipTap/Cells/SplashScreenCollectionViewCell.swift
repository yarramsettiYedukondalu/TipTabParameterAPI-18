//
//  SplashScreenCollectionViewCell.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//

import UIKit

class SplashScreenCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cell"
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    
    @IBOutlet weak var slideTitleLabel: UILabel!
   
    @IBOutlet weak var slideImageView: UIImageView!
    
    func setup(_ slide:splashScreenSlide){
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.descrition
    }
}
