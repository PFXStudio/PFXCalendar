//
//  RxCollectionViewCell.swift
//  WeddingBell
//
//  Created by How To Marry on 2020/04/17.
//  Copyright © 2020 How To Marry. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ConfigurableCollectionViewCellProtocol where Self: UICollectionViewCell {
    func configure(viewModel: RxCellViewModel, indexPath: IndexPath)
}

typealias ConfigurableCollectionViewCell = UICollectionViewCell & ConfigurableCollectionViewCellProtocol

class RxCollectionViewCell: ConfigurableCollectionViewCell {
    var disposeBag = DisposeBag()
    var indexPath: IndexPath?
    deinit {
        self.disposeBag = DisposeBag()
    }

    func configure(viewModel: RxCellViewModel, indexPath: IndexPath) {
        self.indexPath = indexPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
