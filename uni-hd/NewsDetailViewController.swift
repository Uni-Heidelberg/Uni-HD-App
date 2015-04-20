//
//  NewsDetailViewController.swift
//  uni-hd
//
//  Created by Kevin Geier on 14.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import UIKit

@objc public class NewsDetailViewController: UITableViewController {
	
	public var newsItem: UHDNewsItem? {
		didSet {
			// TODO: add / remove observer in notification center
			self.configureView()
		}
	}
	
	@IBOutlet var headerView: UIView!
	@IBOutlet weak var headerImageView: UIImageView!
	
	@IBOutlet weak var navigationBarContainerView: UIView!
	@IBOutlet weak var navigationBarImageView: UIImageView!
	@IBOutlet weak var navigationBarTitleLabel: UILabel!
	
	
	// MARK: - Lifecycle
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.estimatedRowHeight = 200
		self.tableView.rowHeight = UITableViewAutomaticDimension
		
		self.configureView()
    }
	
	func configureView() {
        if !self.isViewLoaded() {
            return
        }
		
		// configure table header view
		if let image = self.newsItem?.image {
			self.headerImageView?.image = image
			self.tableView.tableHeaderView = self.headerView
		} else {
			self.tableView.tableHeaderView = nil
		}
		
		// configure navigation bar
		self.navigationBarContainerView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
		if let newsItem = self.newsItem {
			self.navigationBarTitleLabel.text = newsItem.source.title;
			self.navigationBarImageView.image = newsItem.source.image;
		} else {
			self.navigationBarTitleLabel.text = NSLocalizedString("News", comment: "")
			if let image = UIImage(named: "allTalksIcon") {
				self.navigationBarImageView.image = image
			}
			else {
				self.navigationBarImageView.hidden = true
			}
		}
		self.navigationBarImageView.layer.cornerRadius = self.navigationBarImageView.bounds.size.height / 2
		self.navigationBarImageView.layer.masksToBounds = true
		
		self.tableView.reloadData()
	}
	
	
	// MARK: - Sections and Rows
	
	// TODO: find better way to link to associated institution
	
	private enum Section {
        case News(articleComponents: [ArticleComponent]), Institution(institution: UHDKit.Institution)
		
		var localizedSectionTitle: String? {
			switch self {
			case .News:
				return nil
			case .Institution:
				return NSLocalizedString("Institution", comment: "")
			}
		}
	}
	
	private var sections: [Section] {
		if let newsItem = self.newsItem {
            var sections: [Section] = [ .News(articleComponents: self.newsRows) ]
			if let institution = newsItem.source.institution {
                sections.append(.Institution(institution: institution))
			}
			return sections
        } else {
            return []
        }
	}
	
	public enum ArticleComponent {
        case Title(title: String), Abstract(abstract: String), Content(content: String)
	}
	
	private var newsRows: [ArticleComponent] {
		if let newsItem = self.newsItem {
            var newsRows: [ArticleComponent] = [ .Title(title: newsItem.title) ]
			if let abstract = newsItem.abstract {
                newsRows.append(.Abstract(abstract: abstract))
			}
			if let content = newsItem.content {
                newsRows.append(.Content(content: content))
			}
			return newsRows
		}
		return []
	}
	

    // MARK: - Table view data source

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.sections.count
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch self.sections[section] {
		case .News(let articleComponents):
			return articleComponents.count
		case .Institution:
			return 1
		}
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let newsItem = self.newsItem!
		
		switch self.sections[indexPath.section] {
		
		case .News(let articleComponents):
			let cell = tableView.dequeueReusableCellWithIdentifier("articleComponent") as! NewsDetailTextCell
            cell.configureForArticleComponent(articleComponents[indexPath.row])
			return cell
			
		case .Institution(let institution):
			let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
			cell.textLabel?.text = institution.title
			return cell
		}
    }
	
	override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.sections[section].localizedSectionTitle
	}
	
	override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	
		switch self.sections[indexPath.section] {
		
		case .Institution(let institution):
			let storyboard = UIStoryboard(name: "campus", bundle: NSBundle(forClass: InstitutionDetailViewController.self))
			let institutionDetailVC = storyboard.instantiateViewControllerWithIdentifier("institutionDetail") as! InstitutionDetailViewController
			institutionDetailVC.institution = institution
			self.navigationController?.pushViewController(institutionDetailVC, animated: true)
			
		default:
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
	}
	
	
	// MARK: Scroll View Delegate
    
    override public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.tableView {
            self.tableView.adjustFrameForParallaxedHeaderView(self.headerImageView)
        }
    }

}
