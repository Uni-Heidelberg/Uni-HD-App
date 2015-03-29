//
//  UHDBuildingDetailPropertyCell.swift
//  uni-hd
//
//  Created by Nils Fischer on 16.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit

class InstitutionDetailPropertyCell: UITableViewCell {

    @IBOutlet var titleLabel: UIButton!
    @IBOutlet var contentLabel: UILabel!
    
    func configureForContactProperty(contactProperty: Institution.ContactProperty) {
        switch contactProperty.content {
        case .Email(let email):
            self.contentLabel.text = email
        case .Phone(let phone):
            self.contentLabel.text = phone // TODO: use formatter
        case .Website(let website):
            self.contentLabel.text = website.absoluteString
        case .Post(let address):
            self.contentLabel.text = address.localizedDescription // TODO: use localized description / formatter
        }
        var title = contactProperty.content.description
        if let description = contactProperty.description {
            title += " | \(description)"
        }
        self.titleLabel.setTitle(title, forState: .Normal)
    }

}
