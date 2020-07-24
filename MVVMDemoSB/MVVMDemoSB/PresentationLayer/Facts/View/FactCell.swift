//
//  FactCell.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import Foundation
import UIKit

class FactCell: UITableViewCell {
    
    
    let title = UILabel()
    let lableDescription = UILabel()
    let imageView2 = UIImageView()
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        //configure imageview
        contentView.addSubview(imageView2)
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView2.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        imageView2.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        imageView2.widthAnchor.constraint(equalToConstant:40).isActive = true
        imageView2.heightAnchor.constraint(equalToConstant:40).isActive = true
        imageView2.backgroundColor = .lightGray
        imageView2.layer.cornerRadius = 20
        imageView2.clipsToBounds = true
        
        // configure titleLabel
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: imageView2.trailingAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        title.numberOfLines = 0
        title.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        
        // configure authorLabel
        contentView.addSubview(lableDescription)
        lableDescription.translatesAutoresizingMaskIntoConstraints = false
        lableDescription.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        lableDescription.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        lableDescription.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lableDescription.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        lableDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true

        lableDescription.numberOfLines = 0
        lableDescription.font = UIFont(name: "Avenir-Book", size: 12)
        lableDescription.textColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
