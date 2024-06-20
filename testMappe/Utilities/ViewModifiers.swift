import SwiftUI

struct UIButtonStyle: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: 44, height: 44)
            .background(backgroundColor)
            .clipShape(Circle())
            .foregroundColor(.accentColor)  // Uso .foregroundColor invece di .foregroundStyle
    }
}

struct ResizableImageStyleBig: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: 320)
            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
            .clipped()
            .padding(.top, -2)
    }
}


struct ResizableImageStyleSmall: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fill)
            .frame(width: 88, height: 96)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
    }
}


extension Image {
    func uiButtonStyle(backgroundColor: Color) -> some View {
        self.modifier(UIButtonStyle(backgroundColor: backgroundColor))
    }
    func resizableImageStyleBig() -> some View {
        self.modifier(ResizableImageStyleBig())
    }
    func resizableImageStyleSmall() -> some View {
        self.modifier(ResizableImageStyleSmall())
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
            .foregroundColor(fontColor)  // Uso .foregroundColor invece di .foregroundStyle
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

extension View {
    func applyMaxFrame(_ maxFrame: Bool) -> some View {
        if maxFrame {
            return self.frame(maxWidth: .infinity, maxHeight: .infinity).eraseToAnyView()
        } else {
            return self.eraseToAnyView()
        }
    }
    
    func applyShape(_ shape: CustomAsyncImage.ImageShape) -> some View {
        switch shape {
        case .rectangle(let cornerRadius):
            return self
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .eraseToAnyView()
        case .circle:
            return self
                .clipShape(Circle())
                .eraseToAnyView()
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

extension SecureField {
    func normalTextStyle(fontName: String, fontSize: CGFloat, fontColor: Color) -> some View {
        self.modifier(NormalTextStyle(fontName: fontName, fontSize: fontSize, fontColor: fontColor))
    }
}


struct GrayscaleModifier: ViewModifier {
    let amount: Double
    
    func body(content: Content) -> some View {
        content
            .saturation(1 - amount)
    }
}


extension View {
    func applyGrayscale(_ amount: Double) -> some View {
        self.modifier(GrayscaleModifier(amount: amount))
    }
}
