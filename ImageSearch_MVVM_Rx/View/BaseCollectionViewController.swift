//
//  BaseViewController.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/04.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<ImageSection>

class BaseCollectionViewController: UIViewController {
    struct Constant {
        static let minSpacing: CGFloat = 1.0
        static let numberOfSpace: CGFloat = 2.0
        static let numberOfCells: CGFloat = 3.0
    }
    
    var disposeBag: DisposeBag = .init()
    
    let flowLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: flowLayout)
    lazy var dataSource: DataSource = createDataSource()
    
    private func createDataSource() -> DataSource {
        return .init(configureCell: { _, cv, indexPath, item -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            cell.configure(with: item)
            return cell
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        layoutViews()
    }
    
    private func setAttributes() {
        flowLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = Constant.minSpacing
            $0.minimumInteritemSpacing = Constant.minSpacing
        }
        
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        }
    }
    
    private func layoutViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = Constant.minSpacing * Constant.numberOfSpace
        let width: CGFloat = (collectionView.bounds.width - spacing) / Constant.numberOfCells
        return CGSize(width: width, height: width)
    }
}
