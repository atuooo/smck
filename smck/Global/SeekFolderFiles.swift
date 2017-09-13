//
//  SeekFolderFiles.swift
//  SMCheckProjectCL
//
//  Created by daiming on 2017/3/7.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class SeekFolderFiles {
    
    class func seekWith(_ folderPath:String, matchingExtension:[String] = ["m","h"]) -> [String] {
        let fileFolderPath = folderPath
        let fileFolderStringPath = fileFolderPath.replacingOccurrences(of: "file://", with: "")
        let fileManager = FileManager.default;
        //深度遍历
        let enumeratorAtPath = fileManager.enumerator(atPath: fileFolderStringPath)
        //过滤文件后缀
        let filterPath = NSArray(array: (enumeratorAtPath?.allObjects)!)
                            .pathsMatchingExtensions(matchingExtension)
                            .filter{ !$0.contains("Pods/") }
                            .filter{ !$0.contains("Frameworks/") }
                            .filter{ !$0.contains("工具/Alipay") && !$0.contains("Share/分享sdk/") && !$0.contains("Share/UMengShare/") }
        
        let rePaths = filterPath.map { (aPath) -> String in
            let fullPath = folderPath
            let nsFullPath = folderPath as NSString
            var slash = "/"
            if nsFullPath.lastPathComponent == slash {
                slash = ""
            }
            return "file://".appending(fullPath.appending(slash + aPath))
        }
        return rePaths
    }
}
