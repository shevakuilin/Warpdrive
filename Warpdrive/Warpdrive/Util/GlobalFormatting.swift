//
//  GlobalFormatting.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/12.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa
import Foundation

/** 格式化print输出
 *
 *  @param message  自定义显示内容 [e.g., "array.first"]
 *  @param file     包含这个符号的⽂件的路径
 *  @param method   包含这个符号的⽅法名字
 *  @param line     符号出现处的⾏号
 *
 */
public func printLog<T>(_ message: T,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line) {
    #if DEBUG
    print("文件位置 => [\((file as NSString).lastPathComponent) \(method):] - [Line \(line)], 输出内容 => 「 \(message) 」")
    #endif
}