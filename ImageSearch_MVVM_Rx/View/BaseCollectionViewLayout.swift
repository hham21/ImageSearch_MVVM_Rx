//
//  BaseCollectionViewLayout.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/30.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit

protocol BaseCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath) -> CGFloat
}

class BaseCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: BaseCollectionViewLayoutDelegate?
    
    struct Constant {
        static let numberOfColumns: Int = 3
        static let cellPadding: CGFloat = 1.0
    }
    
    private var cache: [UICollectionViewLayoutAttributes] = .init()
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        if let collectionView = collectionView {
            let insets: UIEdgeInsets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        } else {
            return 0
        }
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll()
        
        guard let collectionView = collectionView else {
            return
        }
        guard collectionView.numberOfSections > 0, cache.isEmpty else {
            return
        }
        
        let columnWidth: CGFloat = contentWidth / CGFloat(Constant.numberOfColumns)
        var xOffset: [CGFloat] = .init()
        
        for column in 0 ..< Constant.numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column: Int = 0
        var yOffSet: [CGFloat] = .init(repeating: 0, count: Constant.numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath: IndexPath = .init(item: item, section: 0)
            let imageHeight: CGFloat = delegate?.collectionView(collectionView, heightForIndexPath: indexPath) ?? 150
            let height: CGFloat = Constant.cellPadding * 3 + imageHeight
            let frame: CGRect = .init(x: xOffset[column], y: yOffSet[column], width: columnWidth, height: height)
            let insetFrame: CGRect = frame.insetBy(dx: Constant.cellPadding, dy: Constant.cellPadding)
            let attributes: UICollectionViewLayoutAttributes = .init(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffSet[column] = yOffSet[column] + height
            column = column < (Constant.numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = .init()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
