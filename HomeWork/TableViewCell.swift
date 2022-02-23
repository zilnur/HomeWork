//
//  TableViewCell.swift
//  HomeWork
//
//  Created by Ильнур Закиров on 23.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        
        self.contentView.addSubview(image)
        
        [self.image.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
         self.image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: -10),
         self.image.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -100),
         self.image.heightAnchor.constraint(equalTo: self.image.widthAnchor),
         self.image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ].forEach{$0.isActive = true}
    }
}
