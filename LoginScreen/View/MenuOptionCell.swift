//
//  MenuOptionCellTableViewCell.swift
//  SideMenu
//
//  Created by Ankitha Kamath on 26/10/21.
//

import UIKit

class MenuOptionCell: UITableViewCell {

    let iconImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Sample text"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .lightGray
        
        addSubview(iconImageview)
        iconImageview.translatesAutoresizingMaskIntoConstraints = false
        iconImageview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageview.leftAnchor.constraint(equalTo: leftAnchor,constant: 12).isActive = true
        iconImageview.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageview.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageview.rightAnchor, constant: 12).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
}
