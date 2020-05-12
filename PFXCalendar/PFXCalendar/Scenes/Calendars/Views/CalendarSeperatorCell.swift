//
//  CalendarSeperatorCell.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/12.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CalendarSeperatorCell: RxCollectionViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    var viewModel: CalendarSeperatorCellViewModel!
    
    override func configure(viewModel: RxCellViewModel, indexPath: IndexPath) {
        guard let viewModel = viewModel as? CalendarSeperatorCellViewModel else { return }
        self.viewModel = viewModel
        self.monthLabel.text = viewModel.yyyyMM
    }
}
