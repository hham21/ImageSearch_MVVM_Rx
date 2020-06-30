//
//  BaseCollectionViewController.swift
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
    
    let flowLayout: BaseCollectionViewLayout = .init()
    lazy var collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: flowLayout)
    lazy var dataSource: DataSource = createDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        layoutViews()
    }
    
    private func setAttributes() {
        flowLayout.do {
            $0.delegate = self
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
    
    private func createDataSource() -> DataSource {
        .init(configureCell: { _, cv, indexPath, item -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            cell.configure(with: item)
            return cell
        })
    }
}

// MARK: - BaseCollectionViewLayoutDelegate

extension BaseCollectionViewController: BaseCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = Constant.minSpacing * Constant.numberOfSpace
        let width: CGFloat = (collectionView.bounds.width - spacing) / Constant.numberOfCells
        let ratio: CGFloat = CGFloat(dataSource[indexPath].height) / CGFloat(dataSource[indexPath].width)
        return CGFloat(ratio) * width
    }
}
