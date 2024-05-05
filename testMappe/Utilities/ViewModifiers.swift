
import SwiftUI

struct UIButtonStyle: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: 44, height: 44)
            .background(backgroundColor)
            .clipShape(Circle())
            .foregroundStyle(.accent)
    }
}

extension Image {
    func uiButtonStyle(backgroundColor: Color) -> some View {
        self.modifier(UIButtonStyle(backgroundColor: backgroundColor))
    }
}

struct NormalTextStyle: ViewModifier {
    let fontName: String
    let fontSize: CGFloat
    let fontColor: Color

    init(fontName: String, fontSize: CGFloat, fontColor: Color) {
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: fontSize))
            .foregroundStyle(fontColor)
    }
}

extension Text {
    func normalTextStyle(fontName: String, fontSize: CGFloat, fontColor: Color) -> some View {
        self.modifier(NormalTextStyle(fontName: fontName, fontSize: fontSize, fontColor: fontColor))
    }
}

extension TextField {
    func normalTextStyle(fontName: String, fontSize: CGFloat, fontColor: Color) -> some View {
        self.modifier(NormalTextStyle(fontName: fontName, fontSize: fontSize, fontColor: fontColor))
    }
}

