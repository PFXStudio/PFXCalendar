//
//  HorizontalCalendarHeaderCell.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit

class HorizontalCalendarHeaderCell: UICollectionReusableView {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    func configure(year: String, month: String) {
        self.yearLabel.text = year
        self.monthLabel.text = month
    }
}
