//
//  FavouriteSectionHeaderViewController.swift
//  TipTap
//
//  Created by ToqSoft on 16/12/23.
//

import UIKit

class FavouriteSectionHeaderViewController: UICollectionReusableView {
    // Add any UI elements you want in your header, for example, a title label
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    // Add any additional setup or customization here
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        // Add your UI elements to the header view
        addSubview(titleLabel)
        
        // Customize the layout (constraints, etc.) as needed
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            // Add more constraints if needed
        ])
    }
}
