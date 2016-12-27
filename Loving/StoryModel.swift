//
//  StoryModel.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/4.
//  Copyright © 2016年 scau. All rights reserved.
//

import Foundation


struct Story {
    let time:String
    let title:String
    let main:String
    
    init(dict:NSDictionary) {
        time = dict["time"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        main = dict["main"] as? String ?? ""
        
    }
}
