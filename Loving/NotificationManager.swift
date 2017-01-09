//
//  NotificationManager.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/6.
//  Copyright © 2016年 scau. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        return
    }
    
//MARK:-- UNUserNotificationCenterDelegate代理方法
    //点击action按钮通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let categoryIdentifier = response.notification.request.content.categoryIdentifier;
        
        if categoryIdentifier == "message" {//识别需要被处理的拓展
            
            if response.actionIdentifier == "reply.custom" {//识别用户点击的是哪个 action
                
                //假设点击了输入内容的 UNTextInputNotificationAction 把 response 强转类型
                let textResponse = response as! UNTextInputNotificationResponse
                //获取输入内容
                let userText = textResponse.userText
                print(userText)
                //发送 userText 给需要接收的方法
//                xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
            }else{
                let title = response.actionIdentifier
                print(title)
                
            }
        completionHandler()// 需要执行这个方法
        }
    }
    
    //前台收到通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([ .sound, .alert])
    }
    
//MARK:-- 注册通知
    func registerNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        //注册通知
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ (granted, error) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
                UIApplication.shared.registerForRemoteNotifications()
                //创建本地通知
                let contents = self.content(withTitle: "本地通知", subtitle: "爱你", body: "每时每刻都在想你", sound: nil, badge: 1, categoryIdentifier:"message")
                self.registerLocalNotification(with: contents, repeats: false)
                //注册action
                self.registerAction()
                
            }
        }
        
    }
    
    //注册APNS远程通知成功与失败
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let device_ns = NSData.init(data: deviceToken)
        let token:String = device_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>" ))
        print("注册远程通知------token:\(token)")
        let deviceTokens = deviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        print("注册远程通知------deviceToken:\(deviceTokens)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册远程通知------error:\(error)")
    }
    
//MARK: -- 功能
    //本地通知的content
    func content(withTitle title:String, subtitle:String?, body:String, sound:UNNotificationSound?, badge:Int?, paths:[String?]? = nil, categoryIdentifier:String? = nil, launchImageName imageName:String? = nil, userInfo:String? = nil ) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        if subtitle != nil {
            content.subtitle = subtitle!
        }
        content.body = body
        if sound != nil {
            content.sound = sound
        }else{
            
            
        }
        if badge != nil  {
            content.badge = badge! as NSNumber
        }
        if paths != nil  {
            var attachments = [UNNotificationAttachment]()
            for path in paths!{
                if path != nil {
                    do{
                        let attachment = try UNNotificationAttachment(identifier: "atta1", url: URL(fileURLWithPath: path!), options: nil)
                        attachments.append(attachment)
                    }
                    catch{
                        
                    }
                }
            }
            content.attachments = attachments
        }
        if categoryIdentifier != nil {
            content.categoryIdentifier = categoryIdentifier!
        }
        if imageName != nil {
            content.launchImageName = imageName!
        }
        return content
    }
    //创建本地通知的方法 需要自己配置时间或components
    func registerLocalNotification(with content:UNMutableNotificationContent, repeats: Bool = false) {
        
        let timeInterval:TimeInterval = 6
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        
//        var components = DateComponents()
//        components.year = 2222
//        components.month = 11
//        components.day = 12
//        components.hour = 7
//        let trigger2 = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        
        let requestIdentifier = "message"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger1)
        UNUserNotificationCenter.current().add(request) { (error) in
            //错误代码
            print("error:\(error)")
        }
    }
    
    //action
    func registerAction()  {
        let action1 = UNNotificationAction(identifier: "😊，想你啦！", title: "😊，想你啦！", options: [.authenticationRequired, .destructive, .foreground])
        let action2 = UNNotificationAction(identifier: "😠，别烦我！", title: "😠，别烦我！", options: [])
        let action3 = UNNotificationAction(identifier: "💏，晚安啦！", title: "💏，晚安啦！", options: [])
        let action4 = UNTextInputNotificationAction(identifier: "reply.custom", title: "自定义回复", options: .authenticationRequired, textInputButtonTitle: "回复", textInputPlaceholder: "请输入回复内容")
        let categroy1 = UNNotificationCategory(identifier: "message", actions: [action1, action2, action3,action4], intentIdentifiers: ["message"], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([categroy1])
        
    }
    
    
    //MARK:-- 添加 远程通知
    func addRemoteNotification() {
        //ios10新版文案多样推送
        /*
         {
         "aps":{
         "alert":{
         "title":"Testing.. (52)",
         "subtitle":"subtitle",
         "body":"body"},
         "badge":1,
         "sound":"default"}
         }
         */
        
    }
    
    func addRemoteNotificationDownload() {
        //后台做一些操作增加字段："content-available":1
        /*
         {
         "aps":{"alert":"Testing.. (34)",
         "badge":1,
         "sound":"default",
         "content-available":1}
         }
         */
    }
    
    
    func addRemoteNotificationSilentDownload(){
        //去掉alert、badge、sound字段实现静默推送，增加增加字段："content-available":1，也可以在后台做一些事情。
        /*
         {
         "aps":{"content-available":1}
         }
         */
    }
    
    func addRemoteNotificationCategory(){
        //指定操作策略，需增加字段："category":"categoryId"
        /*
         {
         "aps":{"alert":"Testing.. (34)",
         "badge":1,
         "sound":"default",
         "category":"category1"}
         }
         */
    }
    
    
    //MARK:--远程附件
    func addRemoteNotificationAttachment(){
        //为了给远程推送增加附件，使推送是可变的，需增加字段："mutable-content":1
        /*
         {
         "aps":{"alert":"Testing.. (34)",
         "badge":1,
         "sound":"default",
         "mutable-content":1}
         }
         */
    }
    
    
    func addRemoteWithCustomUI() {
        //    指定操作策略是Notification Content Extension（通知内容扩展）里配置文件里面category的id之一
        //    /*
        //     {
        //     "aps":{"alert":"Testing.. (34)",
        //     "badge":1,
        //     "sound":"default",
        //     "category":"category-custom-ui"}
        //     }
        //     */
        
    }

    
}


