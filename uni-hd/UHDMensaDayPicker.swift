//
//  UHDMensaDayPicker.swift
//  uni-hd
//
//  Created by Nils Fischer on 25.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit
import VILogKit

@objc
protocol UHDMensaDayPickerDelegate {
    
    optional func dayPicker(dayPicker: UHDMensaDayPicker, canSelectDate date: NSDate) -> Bool
    optional func dayPicker(dayPicker: UHDMensaDayPicker, didSelectDate date: NSDate?, previousDate: NSDate?)
    
}

@objc

class UHDMensaDayPicker: UIView {
    

    var itemWidth: CGFloat = 50 {
        didSet {
            adjustItemSize()
        }
    }
    
    @IBOutlet var delegate: UHDMensaDayPickerDelegate?
    
    private(set) var selectedDate: NSDate? {
        didSet(previousDate) {
            if let selectedDate = selectedDate {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .FullStyle
                selectedDateButton.setTitle(dateFormatter.stringFromDate(selectedDate), forState: .Normal)
            } else {
                selectedDateButton.setTitle(nil, forState: .Normal)
            }
            delegate?.dayPicker?(self, didSelectDate: selectedDate, previousDate: previousDate)
        }
    }
    

    @IBOutlet private var collectionView: UICollectionView!
    
    @IBOutlet private var selectedDateButton: UIButton!


    private var centerIndex = 0
    private let collectionViewLength = 50
    private let startDate = NSDate()
    
    
    // MARK: Public Interface
    
    func selectDate(date: NSDate, animated: Bool, scrollPosition: UICollectionViewScrollPosition)
    {
        if scrollPosition != .None && indexPathForDate(date) == nil {
            recenterToIndex(indexForDate(date))
        }
        collectionView.selectItemAtIndexPath(indexPathForDate(date), animated: animated, scrollPosition: scrollPosition)
        selectedDate = date
    }
    
    func scrollToDate(date: NSDate, atScrollPosition scrollPosition: UICollectionViewScrollPosition, animated: Bool)
    {
        let index = indexForDate(date)
        if indexPathForIndex(index) == nil && scrollPosition != .None {
            recenterToIndex(index)
        }
        collectionView.scrollToItemAtIndexPath(indexPathForIndex(index)!, atScrollPosition: scrollPosition, animated: animated)
    }
    
    
    // MARK: User Interaction
    
    @IBAction func selectedDatePressed(sender: UIButton)
    {
        if let selectedDate = selectedDate {
            scrollToDate(selectedDate, atScrollPosition: .Left, animated: true)
        }
    }
    

    // MARK: View Management
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // TODO: find a way to scroll to startDate on on load. changing itemWidth messes up the solution below
        // collectionView.scrollToItemAtIndexPath(indexPathForDate(startDate), atScrollPosition: .Left, animated: false);
        adjustItemSize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustItemSize()
    }
    
    private func adjustItemSize() {
        (collectionView.collectionViewLayout as UICollectionViewFlowLayout).itemSize = CGSize(width: itemWidth, height: collectionView.bounds.height)
        collectionView.collectionViewLayout.invalidateLayout() // TODO: make sure this works
    }
    
    
    // MARK: Index Path / Index Conversion
    
    private func indexForIndexPath(indexPath: NSIndexPath) -> Int
    {
        return indexPath.row - collectionViewLength / 2 + centerIndex
    }
    
    private func indexPathForIndex(index: Int) -> NSIndexPath?
    {
        let row = index - centerIndex + collectionViewLength / 2
        return row >= 0 && row < collectionViewLength ? NSIndexPath(forRow: row, inSection: 0) : nil
    }
    
    
    // MARK: Index / Date Conversion
    
    private func dateForIndex(index: Int) -> NSDate
    {
        let deltaDays = NSDateComponents()
        deltaDays.day = index
        return NSCalendar.currentCalendar().dateByAddingComponents(deltaDays, toDate: startDate, options: .allZeros)!
    }
    
    private func dateForIndexPath(indexPath: NSIndexPath) -> NSDate
    {
        return dateForIndex(indexForIndexPath(indexPath))
    }
    
    private func indexForDate(date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(.DayCalendarUnit, fromDate: startDate, toDate: date, options: .allZeros).day
    }
    
    private func indexPathForDate(date: NSDate) -> NSIndexPath?
    {
        return indexPathForIndex(indexForDate(date))
    }

}


// MARK: Collection View Datasource

extension UHDMensaDayPicker: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return collectionViewLength
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mensaDayPickerCell", forIndexPath: indexPath) as UHDMensaDayPickerCell
        let date = dateForIndexPath(indexPath)
        cell.configureForDate(date)
        cell.enabled = delegate?.dayPicker?(self, canSelectDate: date) ?? true
        return cell
    }
    
}


// MARK: Collection View Delegate

extension UHDMensaDayPicker: UICollectionViewDelegate {
    
    
    // MARK: Infinite Scrolling

    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView != collectionView {
            return
        }
  
        if scrollView.contentOffset.x <= itemWidth * CGFloat(collectionViewLength) / 4 || scrollView.contentOffset.x >= itemWidth * CGFloat(collectionViewLength) * 3 / 4 {
            recenterToIndex(centerIndex + Int(scrollView.contentOffset.x / itemWidth) - collectionViewLength / 2)
        }
    }
    
    private func recenterToIndex(index: Int)
    {
        if indexPathForIndex(index) != nil {
            collectionView.contentOffset.x -= itemWidth * CGFloat(index - centerIndex)
        }
        centerIndex = index
        collectionView.reloadItemsAtIndexPaths(collectionView.indexPathsForVisibleItems()) // TODO: necessary?
        
        if let selectedDate = selectedDate {
            collectionView.selectItemAtIndexPath(indexPathForDate(selectedDate), animated: false, scrollPosition: .None)
        }

        logger.log("Recentered to index \(index).", forLevel: .Debug)
    }
    

    // MARK: Snapping to item bounds

    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if scrollView != collectionView {
            return
        }

        let itemWidth = (collectionView.collectionViewLayout as UICollectionViewFlowLayout).itemSize.width
        let indexOfItemToSnap = Int(round(targetContentOffset.memory.x / itemWidth))
        
        if indexOfItemToSnap + 1 == collectionView.numberOfItemsInSection(0) { // handle last item
            targetContentOffset.memory.x = collectionView.contentSize.width -
                collectionView.bounds.size.width
        } else {
            targetContentOffset.memory.x = CGFloat(indexOfItemToSnap) * itemWidth
        }
    }
    
    
    // MARK: Date Selection
        
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedDate = dateForIndexPath(indexPath)
    }

}


// MARK: Logging

extension UHDMensaDayPicker {
    
    var logger: VILogger {
        return VILogger.loggerForKeyPath("UHDMensaDayPicker")
    }
}
