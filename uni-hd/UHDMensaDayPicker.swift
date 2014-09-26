//
//  UHDMensaDayPicker.swift
//  uni-hd
//
//  Created by Nils Fischer on 25.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit


protocol UHDMensaDayPickerDelegate {
    
    func dayPicker(dayPicker: UHDMensaDayPicker, didSelectDate date: NSDate)
    
}


class UHDMensaDayPicker: UIView {
    
    
    internal var delegate: UHDMensaDayPickerDelegate?
    
    internal var selectedDate: NSDate?
    

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerNib(UINib(nibName: "UHDMensaDayPickerCell", bundle: NSBundle(forClass: UHDMensaDayPickerCell.self)), forCellWithReuseIdentifier: "mensaDayPickerCell")
        return collectionView
        }()
    
    private var centerIndex = 0
    private let collectionViewLength = 50
    private let startDate = NSDate()
    

    // MARK: View Management
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.addSubview(collectionView)
        collectionView.scrollToItemAtIndexPath(indexPathForIndex(centerIndex), atScrollPosition: .Left, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
        (collectionView.collectionViewLayout as UICollectionViewFlowLayout).itemSize = CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    
    // MARK: Index Management
    
    private func indexForIndexPath(indexPath: NSIndexPath) -> Int
    {
        return indexPath.row - collectionViewLength / 2 + centerIndex
    }
    
    private func indexPathForIndex(index: Int) -> NSIndexPath
    {
        return NSIndexPath(forRow: index + collectionViewLength / 2 - centerIndex, inSection: 0)
    }
    
    
    // MARK: Date Management
    
    private func dateForIndex(index: Int) -> NSDate
    {
        let deltaDays = NSDateComponents()
        deltaDays.day = index
        return NSCalendar.currentCalendar().dateByAddingComponents(deltaDays, toDate: startDate, options: NSCalendarOptions.allZeros)!
    }
    
    private func dateForIndexPath(indexPath: NSIndexPath) -> NSDate
    {
        return dateForIndex(indexForIndexPath(indexPath))
    }
    
    private func indexForDate(date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(.DayCalendarUnit, fromDate: startDate, toDate: date, options: .allZeros).day
    }
    
    private func indexPathForDate(date: NSDate) -> NSIndexPath
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
        
        let itemWidth = (collectionView.collectionViewLayout as UICollectionViewFlowLayout).itemSize.width
        let adjustment: InfiniteScrollAdjustment = InfiniteScrollAdjustment(contentOffset: scrollView.contentOffset.x, itemWidth: itemWidth, collectionViewLength: collectionViewLength)
        
        // TODO: make if-clause
        switch adjustment {
        case .None:
            break
        default:
            
            var newCenterIndex = indexForIndexPath(collectionView.indexPathForItemAtPoint(collectionView.contentOffset)!)
            var newContentOffset = CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y)
            
            switch adjustment {
            case .Leading(let adjustment):
                newCenterIndex += 1
                newContentOffset.x += adjustment
            case .Trailing(let adjustment):
                newContentOffset.x -= adjustment
            default:
                break
            }
            
            centerIndex = newCenterIndex
            collectionView.contentOffset = newContentOffset
            
            if let selectedDate = selectedDate {
                collectionView.selectItemAtIndexPath(indexPathForDate(selectedDate), animated: false, scrollPosition: UICollectionViewScrollPosition.allZeros)
            }
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if scrollView != collectionView {
            return
        }
        
        // MARK: Snapping to item bounds
        
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
        delegate?.dayPicker(self, didSelectDate: dateForIndexPath(indexPath))
    }

}

enum InfiniteScrollAdjustment {
    
    case Leading(adjustment: CGFloat), Trailing(adjustment: CGFloat), None
    
    init(contentOffset: CGFloat, itemWidth: CGFloat, collectionViewLength: Int) {
        
        let trailingAdjustment = itemWidth * ceil(CGFloat(collectionViewLength) / 4)
        
        switch contentOffset {
        case _ where contentOffset <= itemWidth * floor(CGFloat(collectionViewLength) / 4):
            self = .Leading(adjustment: itemWidth * floor(CGFloat(collectionViewLength) / 4))
        case _ where contentOffset >= itemWidth * ceil(CGFloat(collectionViewLength) * 3 / 4):
            self = .Trailing(adjustment: itemWidth * ceil(CGFloat(collectionViewLength) / 4))
        default:
            self = .None
        }
        
    }
}
