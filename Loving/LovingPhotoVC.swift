//
//  LovingPhotoVC.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/7.
//  Copyright © 2016年 scau. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit

let KScreenWidth = UIScreen.main.bounds.size.width
let KScreenHeight = UIScreen.main.bounds.size.height
let placeholderImage = UIImage(named:"launch.jpg")!

class LovingPhotoVC: UIViewController, UIScrollViewDelegate {
    var imageURLsStr: [String] = []
    var urlIndex: Int!
    var imageView: UIImageView!
    var isHideBar = false
    
    var scrollView: UIScrollView!
    var nextImageView:UIImageView!
    var previousView:UIImageView!


    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setArr()
        setScrollView()
        //点击事件
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTheImage))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGesture)
        
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
    
    // MARK: - Private - Setup Methods
    
    private func setScrollView(){
        
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        
        scrollView = UIScrollView(frame:self.view.bounds)
        scrollView.contentSize = CGSize(width: 3 * width, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator  = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        self.view.addSubview(scrollView)
        
        //初始化当前视图
        imageView = UIImageView()
        //初始化下一个视图
        nextImageView = UIImageView()
        //初始化上一个视图
        previousView = UIImageView()
        
        self.setImageView()
        
        imageView.frame = CGRect(x:width, y:0, width:width, height:height)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        nextImageView.frame = CGRect(x:width * 2, y:0, width:width, height:height);
        nextImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(nextImageView)
        nextImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        previousView.frame = CGRect(x:0, y:0, width:width, height:height)
        previousView.contentMode = .scaleAspectFit
        scrollView.addSubview(previousView)
        previousView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = self.view.bounds.size.width
        
        self.reloadImage()
        scrollView.setContentOffset(CGPoint(x:width,y:0), animated: false)
    }
    
    private func reloadImage(){
        let width = self.view.bounds.size.width
        let offset = scrollView.contentOffset
        if offset.x > width { //向右滑动
            urlIndex = (urlIndex + 1) % self.imageURLsStr.count
        }else if(offset.x < width){ //向左滑动
            urlIndex = (urlIndex + self.imageURLsStr.count - 1) % self.imageURLsStr.count
        }
        
        self.setImageView()
    }
    private func setImageView() {
        let curURL = URL(string: self.imageURLsStr[self.urlIndex])!
        let preURL = URL(string: self.imageURLsStr[(urlIndex + self.imageURLsStr.count - 1) % self.imageURLsStr.count])!
        let nexURL = URL(string: self.imageURLsStr[(self.urlIndex + 1) % self.imageURLsStr.count])!
        title = curURL.deletingPathExtension().lastPathComponent
        imageView.af_setImage(
            withURL: curURL,
            placeholderImage: placeholderImage,
            filter: nil//CircleFilter(),
        )
        previousView.af_setImage(
            withURL: preURL,
            placeholderImage: placeholderImage,
            filter: nil//CircleFilter()
        )
        nextImageView.af_setImage(
            withURL: nexURL,
            placeholderImage: placeholderImage,
            filter: nil//CircleFilter(),
        )
        
      
    }
    
    func tapTheImage(){
        if self.isHideBar {
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
            self.isHideBar = false
            self.view.backgroundColor = UIColor.white
        }else{
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.isHideBar = true
            self.view.backgroundColor = UIColor.black
        }
        
    }
}
