//
//  CalendarHeaderCell.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit

class CalendarHeaderCell: UICollectionReusableView {
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(dateText: String) {
        self.dateLabel.text = dateText
    }
}
