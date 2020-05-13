//
//  HorizontalCalendarCollectionViewController.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class HorizontalCalendarCollectionViewController: UICollectionViewController {
    var viewModel: HorizontalCalendarCollectionViewModel!
    private var rxDataSource: RxCollectionViewSectionedAnimatedDataSource<RxSectionCollectionViewModel>?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HorizontalCalendarCollectionViewModel(dependency: HorizontalCalendarCollectionViewModel.Dependency())
        self.bindOutputs()
        var dateComponent = DateComponents(timeZone: TimeZone(abbreviation: "GMT"))
        dateComponent.month = 2
        let startDate = Date()
        guard let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate) else {
            return
        }
        
        self.viewModel.input.load.onNext((startDate, endDate))
    }
    
    func bindOutputs() {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }

        self.rxDataSource = RxCollectionViewSectionedAnimatedDataSource<RxSectionCollectionViewModel>(configureCell: { dataSource, collectionView, indexPath, cellViewModel in
            self.collectionViewLayout.invalidateLayout()
            guard let viewModel = try? (dataSource.model(at: indexPath) as? RxCellViewModel),
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath) as? HorizontalCalendarCell else {
                    assert(true)
                    return UICollectionViewCell()
            }
            
            cell.configure(viewModel: viewModel, indexPath: indexPath)
            return cell
            }, configureSupplementaryView: { (ds ,cv, kind, ip) in
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let cell = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HorizontalCalendarHeaderCell.self), for: ip) as? HorizontalCalendarHeaderCell else {
                        return UICollectionReusableView()
                    }
                    let model = ds.sectionModels[ip.section]
                    guard let year = model.header?.components(separatedBy: "-").first,
                        let month = model.header?.components(separatedBy: "-").last else {
                            return UICollectionReusableView()
                    }
                    
                    cell.configure(year: year, month: month)
                    return cell
                }
                
                return UICollectionReusableView()
            })

        self.viewModel.output.sections
            .asDriver(onErrorJustReturn: [RxSectionCollectionViewModel()])
            .drive(self.collectionView.rx.items(dataSource: self.rxDataSource!))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemSelected
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                guard let navigationController = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarNavigationController") as? UINavigationController else { return }
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
}
