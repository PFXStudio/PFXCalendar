//
//  RxSectionCollectionViewModel.swift
//  WeddingBell
//
//  Created by How To Marry on 2020/04/17.
//  Copyright © 2020 How To Marry. All rights reserved.
//

import Foundation
import RxDataSources

struct RxSectionCollectionViewModel : AnimatableSectionModelType, IdentifiableType, Equatable {

    static func == (lhs: RxSectionCollectionViewModel, rhs: RxSectionCollectionViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    var identifier = String.random(length: 20)

    var header: String? = ""

    var items: [RxCellViewModel]

    init(header: String? = "", items: [RxCellViewModel] = []) {
        self.header = header
        self.items = items
    }

    // MARK: -

    var identity: String {
        return identifier
    }

    typealias Identity = String

    typealias Item = RxCellViewModel

    init(original: RxSectionCollectionViewModel, items: [Item]) {
        self = original
        self.items = items
    }
}
