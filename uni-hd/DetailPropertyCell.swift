//
//  DetailPropertyCell.swift
//  uni-hd
//
//  Created by Nils Fischer on 16.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit

public class DetailPropertyCell: UITableViewCell {

    @IBOutlet public var titleLabel: UILabel!
    @IBOutlet public var contentLabel: UILabel!
    
    override public func tintColorDidChange() {
        titleLabel.textColor = self.tintColor
    }
    
    public func configureForContactProperty(contactProperty: Institution.ContactProperty) {
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
        self.titleLabel.text = title
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

}
