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

/** 格式化富文本
 *
 *  @param string       字符串
 *  @param font         字体size
 *  @param color        字体颜色
 *  @param alignment    文本水平位置
 *
 */
public func kAttributedStyle(_ string: String?,
                             _ font: NSFont,
                             _ color: NSColor = .black,
                             _ alignment: NSTextAlignment = .left,
                             _ lineSpacing: CGFloat = 0) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = alignment
    if lineSpacing > 0 {
        paragraphStyle.lineSpacing = lineSpacing
    }
    return NSAttributedString(string: string ?? "",
                              attributes: [
                                NSAttributedString.Key.font: font,
                                NSAttributedString.Key.foregroundColor: color,
                                NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
}

/** 格式化NSColor [默认alpha]
 *
 *  @param r    red值
 *  @param g    green值
 *  @param b    blue值
 *  @param a    alpha值
 *
 */
public func kColor(_ r: CGFloat,
                   _ g: CGFloat,
                   _ b: CGFloat,
                   _ a: CGFloat = 1.0) -> NSColor {
    let denominatorRGB: CGFloat = 255.0
    return NSColor(red: r/denominatorRGB, green: g/denominatorRGB, blue: b/denominatorRGB, alpha: a)
}

/** 格式化NSNotificationName
 *
 *  @param name    通知name
 *
 */
public func kNotificationName(_ name: String) -> NSNotification.Name {
    return NSNotification.Name(rawValue: name)
}

/** 格式化NSRect
 *
 *  @param x        x坐标
 *  @param y        y坐标
 *  @param width    宽
 *  @param height   高
 *
 */
public func kFrame(_ x: CGFloat,
                   _ y: CGFloat,
                   _ width: CGFloat,
                   _ height: CGFloat) -> NSRect {
    return NSRect(x: x, y: y, width: width, height: height)
}
