//
//  CalendarMonthCollectionViewController.swift
//  PFXCalendar
//
//  Created by jinwoo.park on 2020/05/11.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class CalendarMonthCollectionViewController: UICollectionViewController {
    var viewModel: CalendarMonthCollectionViewModel!
    private var rxDataSource: RxCollectionViewSectionedAnimatedDataSource<RxSectionCollectionViewModel>?
    var disposeBag = DisposeBag()
    var gap: CGFloat = 0

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeNavigationBar()
        self.initializeFlowLayout()
        self.viewModel = CalendarMonthCollectionViewModel(dependency: CalendarMonthCollectionViewModel.Dependency())
        self.bindOutputs()
        let startDate = Date()
        var dateComponent = DateComponents(timeZone: TimeZone(abbreviation: "GMT"))
        dateComponent.month = 6
        guard let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate) else { return }
        self.viewModel.input.load.onNext((startDate, endDate))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initializeNavigationBar() {
        self.title = "방문 예약"

        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.setValue(true, forKey: "hidesShadow")
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray, .font: UIFont(name: "HelveticaNeue-Bold", size: 18)!]
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkGray, .font: UIFont(name: "HelveticaNeue-Bold", size: 15)!]

        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
//        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(touchedCloseButton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func touchedCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }

    func initializeFlowLayout() {
    }
    
    func bindOutputs() {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }

        self.rxDataSource = RxCollectionViewSectionedAnimatedDataSource<RxSectionCollectionViewModel>(configureCell: { dataSource, collectionView, indexPath, cellViewModel in
            self.collectionViewLayout.invalidateLayout()
            guard let viewModel = try? (dataSource.model(at: indexPath) as? RxCellViewModel) else { return UICollectionViewCell() }
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath) as? CalendarMonthCell {
                cell.configure(viewModel: viewModel, indexPath: indexPath)
                return cell
            }
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath) as? CalendarMonthEmptyCell {
                return cell
            }

            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath) as? CalendarSeperatorCell {
                cell.configure(viewModel: viewModel, indexPath: indexPath)
                return cell
            }

            return UICollectionViewCell()
            }, configureSupplementaryView: { (ds ,cv, kind, ip) in
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let cell = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CalendarWeekDaySymbolHeaderCell.self), for: ip) as? CalendarWeekDaySymbolHeaderCell else {
                        return UICollectionReusableView()
                    }

                    cell.initialize(constant: self.gap)
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
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension CalendarMonthCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let items = self.rxDataSource?.sectionModels[indexPath.section].items else { return CGSize(width: 0, height: 0) }
        let viewModel = items[indexPath.row]
        if viewModel is CalendarSeperatorCellViewModel {
            return CGSize(width: self.collectionView.frame.width, height: 44)
        }

//        #error("컬렉션 뷰 왼쪽 오른쪽 마진 32")
//        #error("셀 간격 11 * 6 = 66")
//        #error("월~일 라벨 크기 7개")
//        let width = (self.collectionView.frame.width - 32 - 66 - (8.3 * 7)) / numberOfColums
        let numberOfColums: CGFloat = 7
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        
        var margin = layout.sectionInset.left + layout.sectionInset.right
        margin = margin + layout.minimumInteritemSpacing * (numberOfColums - 1)
        margin = margin + 8.3 * numberOfColums
        let gap = (self.collectionView.frame.width - margin) / numberOfColums
        self.gap = gap

        if viewModel is CalendarCellViewModel || viewModel is CalendarEmptyCellViewModel {
            let width = self.collectionView.frame.width - (layout.sectionInset.left + layout.sectionInset.right)
            let cellSpacing: CGFloat = layout.minimumInteritemSpacing
            let size = CGSize(width: (width / numberOfColums) - cellSpacing, height: (width / numberOfColums) - cellSpacing)
            return size
        }
        
        return CGSize(width: 0, height: 0)
    }
}
