//
//  RxViewModel.swift
//  WeddingBell
//
//  Created by jinwoo.park on 2020/04/22.
//  Copyright © 2020 How To Marry. All rights reserved.
//

import Foundation
import RxSwift

class RxViewModel {
    var disposeBag = DisposeBag()
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func initialize() {
        self.disposeBag = DisposeBag()
    }
}
