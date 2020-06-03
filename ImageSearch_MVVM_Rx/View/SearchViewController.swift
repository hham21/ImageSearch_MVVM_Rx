//
//  SearchViewController.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Toaster

typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<ImageSection>

final class SearchViewController: UIViewController {
    struct Constant {
        static let minSpacing: CGFloat = 1.0
        static let numberOfSpace: CGFloat = 2.0
        static let numberOfCells: CGFloat = 3.0
    }
    
    private var disposeBag: DisposeBag = .init()
    
    private let searchController: UISearchController = .init(searchResultsController: nil)
    private let flowLayout: UICollectionViewFlowLayout = .init()
    private lazy var collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: flowLayout)
    private lazy var dataSource: DataSource = createDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        layoutViews()
    }
    
    private func setAttributes() {
        title = "이미지 검색"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        flowLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = Constant.minSpacing
            $0.minimumInteritemSpacing = Constant.minSpacing
        }
        
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        }
        
        searchController.do {
            $0.obscuresBackgroundDuringPresentation = false
        }
    }
    
    private func layoutViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(viewModel: SearchViewModel) {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(onNext: { text in
                Toast(text: text).show()
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchController.dismiss(animated: true)
            })
            .bind(to: viewModel.searchBarText)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.dataSource[indexPath]
                viewModel.itemSelected.accept(item)
            })
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> DataSource {
        return .init(configureCell: { _, cv, indexPath, item -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            cell.configure(with: item)
            return cell
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = Constant.minSpacing * Constant.numberOfSpace
        let width: CGFloat = (collectionView.bounds.width - spacing) / Constant.numberOfCells
        return CGSize(width: width, height: width)
    }
}
