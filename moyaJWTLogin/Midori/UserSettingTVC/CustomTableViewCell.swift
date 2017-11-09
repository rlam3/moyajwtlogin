//
//  CustomTableViewCell.swift
//  Midori
//
//  Created by Raymond Lam on 4/12/17.
//  Copyright © 2017 Midori. All rights reserved.
//

import UIKit
import Static
import FlatUIColors
import TinyConstraints

class CustomTableViewCell: UITableViewCell, Cell {

    // MARK: - Properties
    private lazy var centeredLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = FlatUIColors.alizarin()
        
        contentView.addSubview(centeredLabel)
        
        centeredLabel.center(in: contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CellType
    func configure(row: Row) {
        centeredLabel.text = row.text
    }
    
}
