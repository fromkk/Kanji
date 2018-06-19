//
//  FontManager.swift
//  Kanji
//
//  Created by Kazuya Ueoka on 2018/06/19.
//

import Foundation

public class FontManager {
    public static func path(of font: String) -> String? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: font) {
            return font
        }
        
        guard let username = Command.run("whoami")?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
            print("user name not found")
            exit(1)
        }
        
        let fontLibrary = URL(fileURLWithPath: "/System/Library/Fonts/").appendingPathComponent(font)
        let fontUser = URL(fileURLWithPath: "/Users/\(username)/Library/Fonts/").appendingPathComponent(font)
        
        if fileManager.fileExists(atPath: fontLibrary.path) {
            return fontLibrary.path
        } else if fileManager.fileExists(atPath: fontUser.path) {
            return fontUser.path
        } else {
            return nil
        }
    }
}
