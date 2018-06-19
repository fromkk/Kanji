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
        
        let directories = [
            "/System/Library/Fonts/",
            "/Library/Fonts/",
            "/Users/\(username)/Library/Fonts/",
        ]
        
        for directory in directories {
            let url = URL(fileURLWithPath: directory).appendingPathComponent(font)
            if fileManager.fileExists(atPath: url.path) {
                return url.path
            }
        }
        return nil
    }
}
