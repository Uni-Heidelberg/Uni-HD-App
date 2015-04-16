//
//  NewsDetailTextCell.swift
//  uni-hd
//
//  Created by Kevin Geier on 16.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit

public class NewsDetailTextCell: UITableViewCell {

	@IBOutlet weak var articleComponentTextView: UITextView!
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	public func configure(forNewsItem newsItem: UHDNewsItem!, forArticleComponent articleComponent: NewsDetailViewController.ArticleComponent) {
	
		self.articleComponentTextView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
		
		switch articleComponent {
		
		case .Title:
			self.articleComponentTextView.text = newsItem.title
			self.articleComponentTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
			
		case .Abstract:
			// TODO: get adequate abstract from server
			let abstract = newsItem.abstract as NSString
			let maxAbstractLength = 200
			
			if abstract.length > maxAbstractLength {
				var subString = abstract.substringToIndex(maxAbstractLength)
				self.articleComponentTextView.text = (subString as String) + "..."
			}
			else {
				self.articleComponentTextView.text = newsItem.abstract
			}
			
			let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleSubheadline)
			if let boldFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(fontDescriptor.symbolicTraits | UIFontDescriptorSymbolicTraits.TraitBold) {
					self.articleComponentTextView.font = UIFont(descriptor: boldFontDescriptor, size: boldFontDescriptor.pointSize)
			}
			
		case .Content:
			self.articleComponentTextView.text = newsItem.content
			self.articleComponentTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		}
	}
}
