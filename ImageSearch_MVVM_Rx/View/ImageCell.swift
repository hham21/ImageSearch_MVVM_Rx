//
//  ImageCell.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    static let identifier: String = .init(describing: ImageCell.self)
    
    private let imageView: UIImageView = .init()
    private let favoriteButton: UIButton = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        imageView.do {
            $0.backgroundColor = .lightGray
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
        }
        
        favoriteButton.do {
            $0.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            $0.tintColor = .red
            $0.isHidden = true
        }
    }
    
    private func layoutViews() {
        addSubview(imageView)
        addSubview(favoriteButton)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.right.equalToSuperview()
        }
    }
    
    func configure(with data: ImageCellData) {
        imageView.kf.setImage(with: data.url)
        favoriteButton.isHidden = !data.favorite
    }
}
