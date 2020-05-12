//
//  RxCellViewModel.swift
//  WeddingBell
//
//  Created by How To Marry on 2020/04/17.
//  Copyright © 2020 How To Marry. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

public class RxCellViewModel: IdentifiableType, Equatable {
    let reuseIdentifier: String
    let identifier: String
    var disposeBag = DisposeBag()
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func initialize() {
        self.disposeBag = DisposeBag()
    }

    init(reuseIdentifier: String, identifier: String) {
        self.reuseIdentifier = reuseIdentifier
        self.identifier = identifier
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - IdentifiableType

    public typealias Identity = String

    public var identity : Identity {
        return identifier
    }

    // MARK: - Equatable

    public static func == (lhs: RxCellViewModel, rhs: RxCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
