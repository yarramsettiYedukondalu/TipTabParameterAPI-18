//
//  support File.swift
//  mostPolupar
//
//  Created by ToqSoft on 31/10/23.
//

import Foundation
import UIKit
class supportFile {
    func roundBtn(myBtn:UIButton){
        myBtn.layer.cornerRadius = myBtn.frame.size.height / 2
        myBtn.clipsToBounds = true
    }
    func roundLabel(myLabel:UILabel){
        myLabel.layer.cornerRadius = 5
        myLabel.layer.masksToBounds = true
        
    }
    func circle(uibtn:UIButton){
        uibtn.layer.cornerRadius = uibtn.frame.size.width / 2
        uibtn.clipsToBounds = true
    }
    //    func labelSizes(mylabel: UILabel, mysize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor) {
    //        mylabel.font = UIFont.systemFont(ofSize: mysize, weight: fontWeight)
    //        mylabel.textColor = textColor
    //    }
    func cornerView(myView:UIView){
        myView.layer.cornerRadius = 5.0
        myView.layer.masksToBounds = true
    }
    
//  public  func BadgeCorners(myLabel: UILabel,notibadgeLabel:UILabel, loginuserFavouriteItemArray: [Any], loginuserFavouriteRestaurantArray: [Any]) {
//        if myLabel == notibadgeLabel {
//            myLabel.text = "3"
//        } else {
//            let itemcount = loginuserFavouriteItemArray.count + loginuserFavouriteRestaurantArray.count
//            myLabel.text = "\(itemcount)"
//        }
//        myLabel.layer.cornerRadius = 10
//        myLabel.clipsToBounds = true
//    }
    
}
