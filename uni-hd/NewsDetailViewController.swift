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
		
		// configure table header view
		if let image = self.newsItem?.image {
			self.headerImageView?.image = image
			self.tableView.tableHeaderView = self.headerView
		}
		else {
			self.tableView.tableHeaderView = nil
		}
		
		// configure navigation bar
		self.navigationBarContainerView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
		if let newsItem = self.newsItem {
			self.navigationBarTitleLabel.text = newsItem.source.title;
			self.navigationBarImageView.image = newsItem.source.image;
		}
		else {
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

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	// MARK: - Sections and Rows
	
	// TODO: find better way to link to associated institution
	
	private enum Section {
		case News, Institution
		
		// read-only computed property
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
			var sections: [Section] = [Section.News]
			if let institution = newsItem.source.institution {
				sections.append(Section.Institution)
			}
			return sections
		}
		return []
	}
	
	public enum ArticleComponent {
		case Title, Abstract, Content
	}
	
	private var newsRows: [ArticleComponent] {
		if let newsItem = self.newsItem {
			var newsRows: [ArticleComponent] = [ArticleComponent.Title]
			if newsItem.abstract != nil {
				newsRows.append(ArticleComponent.Abstract)
			}
			if newsItem.content != nil {
				newsRows.append(ArticleComponent.Content)
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
		case .News:
			return self.newsRows.count
		case .Institution:
			return 1
		}
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let newsItem = self.newsItem!
		
		switch self.sections[indexPath.section] {
		
		case .News:
			let cell = tableView.dequeueReusableCellWithIdentifier("articleComponent") as! NewsDetailTextCell
			switch self.newsRows[indexPath.row] {
			case .Title:
				cell.configure(forNewsItem: newsItem, forArticleComponent: .Title)
			case .Abstract:
				cell.configure(forNewsItem: newsItem, forArticleComponent: .Abstract)
			case .Content:
				cell.configure(forNewsItem: newsItem, forArticleComponent: .Content)
			}
			return cell
			
		case .Institution:
			let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
			cell.textLabel?.text = newsItem.source.institution.title
			return cell
		}
    }
	
	override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.sections[section].localizedSectionTitle
	}
	
	override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	
		switch self.sections[indexPath.section] {
		
		case .Institution:
			let storyboard = UIStoryboard(name: "campus", bundle: NSBundle(forClass: InstitutionDetailViewController.self))
			let institutionDetailVC = storyboard.instantiateViewControllerWithIdentifier("institutionDetail") as! InstitutionDetailViewController
			institutionDetailVC.institution = self.newsItem?.source.institution
			self.navigationController?.pushViewController(institutionDetailVC, animated: true)
			
		default:
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
	}
	
	
	// MARK: Scroll View Delegate
    
    override public func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView==self.tableView) {
            self.tableView.adjustFrameForParallaxedHeaderView(self.headerImageView)
        }
    }

}
