//
//  UHDMensaDayPickerCell.swift
//  uni-hd
//
//  Created by Nils Fischer on 25.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

import UIKit

class UHDMensaDayPickerCell: UICollectionViewCell {
    
    @IBOutlet private weak var weekdayLabel: UILabel!
    @IBOutlet private weak var selectionIndicatorView: UIView!
    @IBOutlet private weak var dayLabel: UILabel!
    
    private var effectiveTintColor: UIColor {
        return enabled ? ( isToday ? tintColor : UIColor.blackColor() ) : UIColor.lightGrayColor()
    }
    
    private lazy var dayFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    private lazy var weekdayFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter
    }()

    
    override var selected: Bool {
        didSet {
            configureView()
        }
    }
    override var highlighted: Bool {
        didSet {
            configureView()
        }
    }
    
    private var isToday = false

    var enabled: Bool = false {
        didSet {
            configureView()
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        configureView()
    }
    
    private func configureView()
    {
        selectionIndicatorView.backgroundColor = effectiveTintColor
        selectionIndicatorView.hidden = !selected
        dayLabel.textColor = selected ? UIColor.whiteColor() : effectiveTintColor
    }
    
    internal func configureForDate(date: NSDate)
    {
        isToday = NSCalendar.currentCalendar().isDateInToday(date)
        
        configureView()
        
        dayLabel.text = dayFormatter.stringFromDate(date)
        weekdayLabel.text = weekdayFormatter.stringFromDate(date)
    }
    
}
