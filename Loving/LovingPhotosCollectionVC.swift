//
//  LovingPhotosCollectionVC.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/7.
//  Copyright © 2016年 scau. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class LovingPhotosCollectionVC: UIViewController {

    lazy var imageURLsStr: [String] = []
    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "icon.png")!
        return image
    }()
    
    var collectionView: UICollectionView!

    @IBAction func refreshPhotos(_ sender: UIBarButtonItem) {
        let severUrl3 = severUrlStr + "Photos.plist"
        NetManager.download(urlStr: severUrl3, isShowHUB: true){
            self.setArr()
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func uploadPhotos(_ sender: UIBarButtonItem) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInstanceProperties()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setArr()
    }
    
    private func setArr() {
        let path = NSHomeDirectory() + "/Documents/Photos.plist"
        if let URLs = NSArray(contentsOfFile: path){
            self.imageURLsStr = []
            for urlStr in URLs {
                self.imageURLsStr.append(severUrlStr + (urlStr as! String))
            }
        }
        
    }
    
    // MARK: Private - Setup
    
    private func setUpInstanceProperties() {
        title = "爱的瞬间"

    }
    
    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(LovingImageCell.self, forCellWithReuseIdentifier: LovingImageCell.ReuseIdentifier)
        
        view.addSubview(self.collectionView)
        
        collectionView.frame = self.view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    fileprivate func sizeForCollectionViewItem() -> CGSize {
        let viewWidth = view.bounds.size.width
        
        var cellWidth = (viewWidth - 4 * 8) / 3.0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellWidth = (viewWidth - 7 * 8) / 6.0
        }
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK: - UICollectionViewDataSource

extension LovingPhotosCollectionVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLsStr.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LovingImageCell.ReuseIdentifier,
            for: indexPath
            ) as! LovingImageCell
        
        let aURLStr = imageURLsStr[(indexPath as NSIndexPath).row]
        
        cell.configureCell(
            with: (URL(string: aURLStr)?.absoluteString)!,
            placeholderImage: placeholderImage
        )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LovingPhotosCollectionVC : UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return sizeForCollectionViewItem()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8.0
    }
}

// MARK: - UICollectionViewDelegate

extension LovingPhotosCollectionVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = (indexPath as NSIndexPath).row        
        let imageViewController = LovingPhotoVC()
        imageViewController.urlIndex = index
        self.navigationController?.pushViewController(imageViewController, animated: false)
    }

}
