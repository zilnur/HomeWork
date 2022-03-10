//
//  ConfigTableViewCell.swift
//  HomeWork
//
//  Created by Ильнур Закиров on 09.03.2022.
//

import UIKit

class ConfigTableViewCell: UITableViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(label)
        
        [label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
         label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
         label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -100),
         label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ].forEach{$0.isActive = true}
    }
    
}
