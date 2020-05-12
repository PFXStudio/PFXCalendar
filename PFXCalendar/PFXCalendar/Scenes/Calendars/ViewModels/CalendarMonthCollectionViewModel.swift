//
//  CalendarMonthCollectionViewModel.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class CalendarMonthCollectionViewModel: RxViewModel {
    struct Input {
        var load: AnyObserver<(Date, Date)>
    }

    struct Output {
        var sections: Observable<[RxSectionCollectionViewModel]>
        var loading: Observable<Bool>
        var error: Observable<String>
    }

    struct Dependency {
    }

    var input: CalendarMonthCollectionViewModel.Input!
    var output: CalendarMonthCollectionViewModel.Output!
    var dependency: CalendarMonthCollectionViewModel.Dependency!
    private var loadSubject = PublishSubject<(Date, Date)>()
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var sectionsSubject = BehaviorRelay<[RxSectionCollectionViewModel]>(value: [RxSectionCollectionViewModel()])

    init(dependency: Dependency) {
        super.init()
        
        self.input = CalendarMonthCollectionViewModel.Input(load: self.loadSubject.asObserver())
        self.output = CalendarMonthCollectionViewModel.Output(sections: self.sectionsSubject.asObservable(),
                                                   loading: self.loadingSubject.asObservable(),
                                                   error: self.errorSubject.asObservable()
        )
        
        self.dependency = dependency
        self.bindInputs()
    }
    
    func bindInputs() {
        self.loadSubject
            .subscribe(onNext: { [weak self] dates in
                guard let self = self,
                    let startDate = dates.0.startOfWeek else { return }
                
                let endDate = dates.1
                var sections = [RxSectionCollectionViewModel]()
                let gregorian = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
                let daysDiff = gregorian!.components(NSCalendar.Unit.day, from: startDate, to: endDate, options: NSCalendar.Options(rawValue: 0)).day! as Int
                
                guard var pivotDate = gregorian!.date(byAdding: NSCalendar.Unit.day, value: 0, to: startDate as Date, options: NSCalendar.Options(rawValue: 0)) else {
                    return
                }
                
                var items = [RxCellViewModel]()
                let viewModel = CalendarSeperatorCellViewModel(reuseIdentifier: "CalendarSeperatorCell", identifier: "CalendarSeperatorCell" + String.random())
                viewModel.yyyyMM = "\(pivotDate.yearKr)년 \(pivotDate.monthKr)월"
                items.append(viewModel)

                for index in 0..<daysDiff {
                    guard let date = gregorian!.date(byAdding: NSCalendar.Unit.day, value: index, to: startDate as Date, options: NSCalendar.Options(rawValue: 0)) else {
                        continue
                    }
                    
                    let model = CalendarModel(date: date)
                    if pivotDate.monthKr != date.monthKr {
                        for _ in pivotDate.weekdayIndex..<date.maxWeekdayIndex {
                            items.append(CalendarEmptyCellViewModel(reuseIdentifier: "CalendarMonthEmptyCell", identifier: "CalendarMonthEmptyCell" + String.random()))
                        }
                        
                        let viewModel = CalendarSeperatorCellViewModel(reuseIdentifier: "CalendarSeperatorCell", identifier: "CalendarSeperatorCell" + String.random())
                        viewModel.yyyyMM = "\(date.yearKr)년 \(date.monthKr)월"
                        items.append(viewModel)
                        for _ in 0..<date.weekdayIndex {
                            items.append(CalendarEmptyCellViewModel(reuseIdentifier: "CalendarMonthEmptyCell", identifier: "CalendarMonthEmptyCell" + String.random()))
                        }
                    }
                    
                    let cellViewModel = CalendarCellViewModel(reuseIdentifier: "CalendarMonthCell", identifier: "CalendarMonthCell" + String.random())
                    cellViewModel.calendarModel = model
                    items.append(cellViewModel)
                    pivotDate = date
                }

                var oldSections = self.sectionsSubject.value
                oldSections.removeAll()
                let section = RxSectionCollectionViewModel(header: "", items: items)
                sections.append(section)

                self.sectionsSubject.accept(sections)
            })
            .disposed(by: self.disposeBag)
    }
    
}

