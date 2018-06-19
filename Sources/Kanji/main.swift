import Foundation
import Cgd
import KanjiCore

func showHelp() {
    print("""
kanji --character <character> --width <width> --height <height> --font <font> --output <output>

character | set character for create image
width     | set image width
height    | set image height
font      | set font name
output    | set image output path
""")
}

let arguments = Arguments().parse()

guard let character = arguments["character"], character.count == 1 else {
    showHelp()
    exit(1)
}

let font = arguments["font"] ?? "ヒラギノ角ゴシック W3.ttc"

guard let fontPath = FontManager.path(of: font) else {
    print("font \(font) is not found")
    exit(1)
}

guard let outputPath = arguments["output"] else {
    print("output path not found")
    showHelp()
    exit(1)
}

do {
    try Kanji.setup(with: outputPath)
} catch {
    print(error)
    exit(1)
}

let width: Int32 = Int32(arguments["width"] ?? "300")!
let height: Int32 = Int32(arguments["height"] ?? "300")!

let pointer = gdImageCreateTrueColor(width, height)!

let white = gdImageColorAllocate(pointer, 255, 255, 255)
gdImageFilledRectangle(pointer, 0, 0, width, height, white)

guard let size = Kanji.imageSize(character, fontPath: fontPath, height: height, pointer: pointer) else {
    exit(1)
}

Kanji.draw(character, fontPath: fontPath, height: height, size: size, pointer: pointer)



let handler = fopen(outputPath, "wb")
gdImagePng(pointer, handler)
fclose(handler)

gdImageColorDeallocate(pointer, white)
gdImageDestroy(pointer)

print("Done! \(outputPath)")
