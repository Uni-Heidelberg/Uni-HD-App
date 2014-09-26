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
    
    var isToday = false
    
    var effectiveTintColor: UIColor {
        return isToday ? tintColor : UIColor.blackColor()
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
    
    func configureForDate(date: NSDate)
    {
        isToday = NSCalendar.currentCalendar().isDateInToday(date)
        
        configureView()
        
        dayLabel.text = dayFormatter.stringFromDate(date)
        weekdayLabel.text = weekdayFormatter.stringFromDate(date)
    }
    
}
