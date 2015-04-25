//
//  NewsDetailTextCell.swift
//  uni-hd
//
//  Created by Kevin Geier on 16.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit
import VILogKit

public class NewsDetailTextCell: UITableViewCell {

	@IBOutlet weak var articleComponentTextView: UITextView!
	
	public func configureForArticleComponent(articleComponent: NewsDetailViewController.ArticleComponent) {
	
		self.articleComponentTextView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
		
		switch articleComponent {
		
		case .Title(let title):
			articleComponentTextView.text = title
			articleComponentTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
			
		case .Abstract(let abstract):
			// TODO: get adequate abstract from server
			let maxAbstractLength = 200
			
			if count(abstract) > maxAbstractLength {
				var subString = (abstract as NSString).substringToIndex(maxAbstractLength)
				self.articleComponentTextView.text = (subString as String) + "..."
			}
			else {
				self.articleComponentTextView.text = abstract
			}
			
			let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleSubheadline)
			if let boldFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(fontDescriptor.symbolicTraits | UIFontDescriptorSymbolicTraits.TraitBold) {
					self.articleComponentTextView.font = UIFont(descriptor: boldFontDescriptor, size: boldFontDescriptor.pointSize)
			}
			
		case .Content(let content):
			self.articleComponentTextView.text = content
			self.articleComponentTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            
        case .Date:
            log("Tried to configure NewsDetailTextCell for Date.", forLevel: .Warning)
            return
		}
        
        self.layoutIfNeeded()
        
	}
}
