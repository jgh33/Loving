//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by 焦国辉 on 2017/1/8.
//  Copyright © 2017年 scau. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        let size = view.bounds.size
         preferredContentSize = CGSize(width: size.width, height: 64)
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        self.imageView.image = UIImage(named: "icon.png")
    }

}
