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
                
//                let endDate = dates.1,
                var sections = [RxSectionCollectionViewModel]()
                var section = RxSectionCollectionViewModel()
                var dateComponent = DateComponents(timeZone: TimeZone(abbreviation: "GMT"))
                dateComponent.month = 6
                let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
                let gregorian = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
                let daysDiff = gregorian!.components(NSCalendar.Unit.day, from: startDate, to: endDate!, options: NSCalendar.Options(rawValue: 0)).day! as Int
                var calendarModels = [CalendarModel]()
                var currentMonth = ""
                var items = [RxCellViewModel]()
                for index in 0..<daysDiff {
                    guard let date = gregorian!.date(byAdding: NSCalendar.Unit.day, value: index, to: startDate as Date, options: NSCalendar.Options(rawValue: 0)) else {
                        continue
                    }
                    
                    let model = CalendarModel(date: date)
                    calendarModels.append(model)
                    if currentMonth != date.monthKr {
                        if items.count > 0 {
                            section = RxSectionCollectionViewModel(header: "\(date.yearKr)년-\(currentMonth)월", items: items)
                            sections.append(section)
                        }

                        items = [RxCellViewModel]()
                        currentMonth = date.monthKr
                        if date.weekdayIndex != date.maxWeekdayIndex {
                            for _ in 0..<date.weekdayIndex {
                                items.append(RxCellViewModel(reuseIdentifier: "CalendarMonthEmptyCell", identifier: "CalendarMonthEmptyCell" + String.random()))
                            }
                        }
                    }
                    
                    let cellViewModel = CalendarCellViewModel(reuseIdentifier: "CalendarMonthCell", identifier: "CalendarMonthCell" + String.random())
                    cellViewModel.calendarModel = model
                    items.append(cellViewModel)
                }

                var oldSections = self.sectionsSubject.value
                oldSections.removeAll()
                self.sectionsSubject.accept(sections)
            })
            .disposed(by: self.disposeBag)
    }
    
}

