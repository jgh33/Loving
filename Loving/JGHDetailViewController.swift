//
//  JGHDetailViewController.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/4.
//  Copyright © 2016年 scau. All rights reserved.
//

import UIKit

class JGHDetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var story:Story!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false//顶部空白消除
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = self.story.title
        self.textView.text = self.story.main
        self.textView.isEditable = false
        self.textView.showsVerticalScrollIndicator = false

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
