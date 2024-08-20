//
//  UIView+Extension.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//

import UIKit

extension UIView{
   @IBInspectable var cornerRadius: CGFloat{
        get{ return cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }
}

