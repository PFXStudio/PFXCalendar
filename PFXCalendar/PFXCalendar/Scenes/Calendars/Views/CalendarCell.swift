//
//  CalendarCell.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit
class CalendarCell: RxCollectionViewCell {
    var viewModel: CalendarCellViewModel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func configure(viewModel: RxCellViewModel, indexPath: IndexPath) {
        guard let viewModel = viewModel as? CalendarCellViewModel else { return }
        self.viewModel = viewModel
        self.weekDayLabel.text = viewModel.calendarModel.date.weekdaySymbol
        self.dayLabel.text = viewModel.calendarModel.date.dayKr
    }
}
