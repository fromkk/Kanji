//
//  Kanji.swift
//  KanjiCore
//
//  Created by Kazuya Ueoka on 2018/06/19.
//

import Foundation
import Cgd

enum Brect: Int {
    case lowerLeftX
    case lowerLeftY
    case lowerRightX
    case lowerRightY
    case upperRightX
    case upperRightY
    case upperLeftX
    case upperLeftY
}

public class Kanji {
    
    public static func setup(with path: String) throws {
        let url = URL(fileURLWithPath: path)
        let filename = url.lastPathComponent
        let directory = path.replacingOccurrences(of: filename, with: "")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: directory) {
            try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    public static func imageSize(_ text: String, fontPath: String, height: Int32, pointer: UnsafeMutablePointer<gdImage>) -> Size? {
        let text = UnsafeMutablePointer<Int8>(mutating: (text as NSString).utf8String!)
        let fontPointer = UnsafeMutablePointer<Int8>(mutating: fontPath)
        let brect = UnsafeMutablePointer<Int32>.allocate(capacity: 100)
        defer { brect.deallocate() }
        
        let black = gdImageColorAllocate(pointer, 0, 0, 0)
        defer { gdImageColorDeallocate(pointer, black) }
        
        let error = gdImageStringFT(nil, brect, black, fontPointer, Double(height) * 0.7, 0, 0, 0, text)
        if nil != error {
            print("font size get failed")
            return nil
        }
        
        return Size(width: brect[Brect.lowerRightX.rawValue] - brect[Brect.lowerLeftX.rawValue], height: brect[Brect.lowerRightY.rawValue] - brect[Brect.upperRightY.rawValue])
    }
    
    public static func draw(_ text: String, fontPath: String, height: Int32, size: Size, pointer: UnsafeMutablePointer<gdImage>) {
        let text = UnsafeMutablePointer<Int8>(mutating: (text as NSString).utf8String!)
        let fontPointer = UnsafeMutablePointer<Int8>(mutating: fontPath)
        let brect = UnsafeMutablePointer<Int32>(mutating: nil)
        
        let black = gdImageColorAllocate(pointer, 0, 0, 0)
        defer { gdImageColorDeallocate(pointer, black) }
        
        let left = (pointer.pointee.sx - size.width) / 2
        
        let error = gdImageStringFT(pointer, brect, black, fontPointer, Double(height) * 0.7, 0, left, Int32(Double(height) * 0.9), text)
        if nil != error {
            print("font write failed")
            return
        }
    }
}
