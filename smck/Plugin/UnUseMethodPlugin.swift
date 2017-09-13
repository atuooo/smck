//
//  UnUseMethodPlugin.swift
//  SMCheckProjectCL
//
//  Created by didi on 2017/3/10.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class UnUseMethodPlugin {
    var methodsUsed = [String]()           //用过的方法集合
    var methodsMFile = [String]()          //m文件pnameId集合
    var methodsDefinedInHFile = [Method]() //h文件定义的方法集合
    var methodsDefinedInMFile = [Method]() //m文件定义的方法集合
    
    func plug(ob:Observable<Any>) {
        _ = ob.subscribe(onNext: { (result) in
            
            if result is Dictionary<String, Any> {
                let dic = result as! Dictionary<String, Any>
                if dic["filePaths"] is String {
//                    self.console.outPrint("\(dic["filePaths"])")
                }
                if dic["currentParsingFileDes"] is String {
                    Console.outPrint("\(dic["currentParsingFileDes"])")
                }
                if dic["firstRoundAFile"] is File {
                    let aFile = dic["firstRoundAFile"] as! File
                    Console.outPrint("\(aFile.name)")
                }
                
                if dic["methodsUsed"] is [String] {
                    self.methodsUsed = dic["methodsUsed"] as! [String]
                }
                if dic["methodsMFile"] is [String] {
                    self.methodsMFile = dic["methodsMFile"] as! [String]
                }
                if dic["methodsDefinedInHFile"] is [Method] {
                    self.methodsDefinedInHFile = dic["methodsDefinedInHFile"] as! [Method]
                }
                if dic["methodsDefinedInMFile"] is [Method] {
                    self.methodsDefinedInMFile = dic["methodsDefinedInMFile"] as! [Method]
                }
                
                if dic.keys.contains("firstRoundUnUsedMethods") {
                    Console.outPrint("\(dic["firstRoundUnUsedMethods"])")
                }
                
            }
        }, onCompleted:{
            //todo:去重
            let methodsUsedSet = Set(self.methodsUsed) //用过方法
            let methodsMFileSet = Set(self.methodsMFile) //m的映射文件
            print("H方法：\(self.methodsDefinedInHFile.count)个")
            print("M方法：\(self.methodsDefinedInMFile.count)个")
            print("用过方法(包括系统的)：\(self.methodsUsed.count)个")
            Console.outPrint("无用方法", to: .description)
            //找出h文件中没有用过的方法
            var unUsedMethods = [Method]()
            
            var lastPath: String = ""
            var logString: String = ""
            
            for aHMethod in self.methodsDefinedInHFile {
                //todo:第一种无参数的情况暂时先过滤。第二种^这种情况过滤
                if aHMethod.params.count == 1 {
                    if aHMethod.params[0].type == "" {
                        continue
                    }
                }
                if aHMethod.returnTypeBlockTf {
                    continue
                }
                
                if !methodsUsedSet.contains(aHMethod.pnameId) {
                    //这里判断的是delegate类型，m里一定没有定义，所以这里过滤了各个delegate
                    //todo:处理delegate这样的情况
                    if methodsMFileSet.contains(aHMethod.pnameId) {
                        //todo:定义一些继承的类，将继承方法加入头文件中的情况
//                    if aHMethod.pnameId == "responseModelWithData:" {
//                        continue
//                    }
                        unUsedMethods.append(aHMethod)
                        
                        if lastPath != aHMethod.filePath {
                            logString += "\n\(aHMethod.filePath.removingPercentEncoding!):\n\n- \(aHMethod.pnameId)\n"
                            
//                            Console.outPrint("\n\(aHMethod.filePath.removingPercentEncoding!):\n\n- \(aHMethod.pnameId)\n")
                        } else {
                            logString += "- \(aHMethod.pnameId)\n"
//                            Console.outPrint("- \(aHMethod.filePath.removingPercentEncoding!)\n")
                        }
                        
                        lastPath = aHMethod.filePath
                        
//                        Console.outPrint("\(aHMethod.filePath): -- \(aHMethod.pnameId)")
                    }
                }
            }
            
            Console.outPrint(logString)
//            Console.outPrint("\(unUsedMethods)")
        })
    }
}
