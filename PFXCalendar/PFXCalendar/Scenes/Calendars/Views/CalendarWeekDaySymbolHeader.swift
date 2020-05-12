//
//  CalendarWeekDaySymbolHeader.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/12.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit

class CalendarWeekDaySymbolHeaderCell: UICollectionReusableView {
    @IBOutlet var marginConstraints: [NSLayoutConstraint]!

    func initialize(constant: CGFloat) {
        for constraint in self.marginConstraints {
            constraint.constant = constant
        }
    }
}
