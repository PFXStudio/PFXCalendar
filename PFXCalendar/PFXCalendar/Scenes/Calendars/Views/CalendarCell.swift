//
//  CalendarCell.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CalendarCell: RxCollectionViewCell {
    var viewModel: HorizontalCalendarCellViewModel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func configure(viewModel: RxCellViewModel, indexPath: IndexPath) {
        guard let viewModel = viewModel as? HorizontalCalendarCellViewModel else { return }
        self.viewModel = viewModel
        self.dayLabel.text = viewModel.calendarModel.date.dayKr
    }
}
