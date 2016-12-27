//
//  LovingImageCell.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/7.
//  Copyright © 2016年 scau. All rights reserved.
//

import Alamofire
import AlamofireImage
import Foundation
import UIKit

class LovingImageCell : UICollectionViewCell {
    class var ReuseIdentifier: String { return "org.alamofire.identifier.\(type(of: self))" }
    let imageView: UIImageView
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        imageView = {
            let imageView = UIImageView(frame: frame)
            
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            imageView.contentMode = .center
            imageView.clipsToBounds = true
            
            return imageView
        }()
        
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.frame = contentView.bounds
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    func configureCell(with URLString: String, placeholderImage: UIImage) {
        let size = imageView.frame.size
        
        imageView.af_setImage(
            withURL: URL(string: URLString)!,
            placeholderImage: placeholderImage,
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 20.0),
            imageTransition: .crossDissolve(0.2)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.af_cancelImageRequest()
        imageView.layer.removeAllAnimations()
        imageView.image = nil
    }
}
