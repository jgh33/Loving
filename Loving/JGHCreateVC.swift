//
//  JGHCreateVC.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/6.
//  Copyright © 2016年 scau. All rights reserved.
//

import UIKit

class JGHCreateVC: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentztextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func uploadStory(_ sender: UIBarButtonItem) {
        self.titleField.resignFirstResponder()
        self.contentztextView.resignFirstResponder()
        let alert = UIAlertController(title: "警告", message: "确定要上传到服务器吗", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let toS = UIAlertAction(title: "发布到故事", style: .default) { (_) in
            self.writeFile(name: "StoriesList.plist")
            NetManager.upload(name: "StoriesList.plist")
        }
        let toP = UIAlertAction(title: "发布到诗", style: .default) { (_) in
            self.writeFile(name: "PoetriesList.plist")
            NetManager.upload(name: "PoetriesList.plist")
        }
        alert.addAction(toP)
        alert.addAction(toS)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.titleField.text = ""
        self.contentztextView.text = ""
        self.titleField.resignFirstResponder()
        self.contentztextView.resignFirstResponder()
    }
    @IBAction func title_end() {
        self.contentztextView.becomeFirstResponder()
    }
    
   
    func writeFile(name:String) {
        let path = NSHomeDirectory() + "/Documents/" + name
        if let stories = NSMutableArray(contentsOfFile: path){
            let dateF = DateFormatter()
            dateF.dateFormat = "yyyy-MM-dd"
            let timeStr = dateF.string(from: Date())
            print(timeStr)
            let dict:NSDictionary = ["time":timeStr,"title":self.titleField.text!,"main":self.contentztextView.text]
            stories.add(dict)
            print(stories.count)
            let fm = FileManager.default
            print(path)
            if fm.createFile(atPath: path, contents: nil, attributes: nil) {
                stories.write(toFile: path, atomically: true)
            }
        }
        
    }
    

}
