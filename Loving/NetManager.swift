//
//  NetManager.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/4.
//  Copyright © 2016年 scau. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD
import Toast

struct NetManager {
    
/*
     
     
    static func GET(urlStr: String, parameters:[String:NSObject]?, isShowHUB:Bool = true, success:((AnyObject?) -> Void)?, failure:((NSError) -> Void)?){
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.timeoutInterval = 10
        let mainWindow = UIApplication.shared.delegate!.window!
        if isShowHUB {
            MBProgressHUD.showAdded(to: mainWindow, animated: true)
        }
        manager.get(urlStr, parameters: parameters, progress: nil, success: { (task, responseObject) in
            if isShowHUB{
                MBProgressHUD.hideAllHUDs(for: mainWindow, animated: true)
            }
            success?(responseObject as AnyObject?)
        })
        { (task, error) in
            if isShowHUB{
                MBProgressHUD.hideAllHUDs(for: mainWindow, animated: true)
                mainWindow!.makeToast("失败！服务器出错！")
            }
            failure?(error as NSError)
        }
    }
    
    
    static func POST(urlStr: String, parameters:[String:NSObject]?, isShowHUB:Bool = true, success:((AnyObject?) -> Void)?, failure:((NSError) -> Void)?){
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.timeoutInterval = 10
        let mainWindow = UIApplication.shared.delegate!.window!
        if isShowHUB {
            MBProgressHUD.showAdded(to: mainWindow, animated: true)
        }
        manager.post(urlStr, parameters: parameters, progress: nil, success: { (task, responseObject) in
            if isShowHUB{
                MBProgressHUD.hideAllHUDs(for: mainWindow, animated: true)
            }
            success?(responseObject as AnyObject?)
        })
        { (task, error) in
            if isShowHUB{
                MBProgressHUD.hideAllHUDs(for: mainWindow, animated: true)
                mainWindow!.makeToast("失败！服务器出错！")
            }
            failure?(error as NSError)
        }
    }
    
*/
    static func download(urlStr: String, isShowHUB:Bool = true, completionHandler: (() -> Void)?){

        let mainWindow = UIApplication.shared.delegate!.window!
        if isShowHUB {
            MBProgressHUD.showAdded(to: mainWindow!, animated: isShowHUB)
        }
        let destination: DownloadRequest.DownloadFileDestination = { targetPath, response in
            let path = NSHomeDirectory() + "/Documents/" + response.suggestedFilename!
            let fileURL = URL(fileURLWithPath: path)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(urlStr, to: destination).responseData { response in
            if isShowHUB{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: mainWindow!, animated: isShowHUB)
                    
                }
            }
            switch response.result{
            case .success(let data):
                print(data)
                mainWindow!.makeToast(" 更新完毕")
            case .failure(let error):
                mainWindow!.makeToast("失败！服务器出错！")
                print("Downloaded failure!: \(error)")
            }
            print(response.destinationURL?.path ?? "没有文件")
            completionHandler?()
        }
        
    }
    
    
    
    static func upload(name:String, isShowHUB:Bool = true) {
    
        
        
        let mainWindow = UIApplication.shared.delegate!.window!
        if isShowHUB {
            MBProgressHUD.showAdded(to: mainWindow!, animated: true)
        }
        
        let path = NSHomeDirectory() + "/Documents/"
        let data = NSData(contentsOfFile: path + name) as! Data
        Alamofire.upload(multipartFormData: { (mdata) in
            mdata.append(data, withName: "file", fileName: name, mimeType: "text/plist")
            print(mdata)
        }, to: severUrlStr + "upload.php", encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    if isShowHUB{
                        MBProgressHUD.hide(for: mainWindow!, animated: true)
                    }
                    mainWindow!.makeToast("更新完毕")

                }
            case .failure(let encodingError):
                print(encodingError)
                if isShowHUB{
                    MBProgressHUD.hide(for: mainWindow!, animated: true)
                }
                mainWindow!.makeToast("更新失败")
            }
            
            
        })
    }

}
