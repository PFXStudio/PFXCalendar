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
        let numberOfColums: CGFloat = 7
        let width = self.view.frame.size.width
        let xInset: CGFloat = 0
        let cellSpacing: CGFloat = 11
        let size = CGSize(width: (width / numberOfColums) - (xInset + cellSpacing), height: (width / numberOfColums) - (xInset + cellSpacing))
        flowLayout.minimumLineSpacing = 8
        flowLayout.itemSize = size
    }
    
    func bindOutputs() {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
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
            
            return UICollectionViewCell()
            }, configureSupplementaryView: { (ds ,cv, kind, ip) in
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let cell = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CalendarMonthHeaderCell.self), for: ip) as? CalendarMonthHeaderCell else {
                        return UICollectionReusableView()
                    }
                    let model = ds.sectionModels[ip.section]
                    guard let year = model.header?.components(separatedBy: "-").first,
                        let month = model.header?.components(separatedBy: "-").last else {
                            return UICollectionReusableView()
                    }
                    
                    cell.configure(dateText: "\(year) \(month)")
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
