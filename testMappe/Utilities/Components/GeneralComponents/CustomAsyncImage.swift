
import SwiftUI


struct CustomAsyncImage: View {
    @EnvironmentObject var api : ApiManager
    enum ImageShape {
        case rectangle(cornerRadius: CGFloat)
        case circle
    }
    
    var imageUrlString: String?
    var placeholderImageName: String
    var size: CGSize?
    var shape: ImageShape
    var maxFrame: Bool
    
    private var imageUrl: URL? {
        if let imageUrlString = imageUrlString {
            if imageUrlString.hasPrefix("https://"){
                return URL(string: imageUrlString)
            }else if imageUrlString.hasPrefix("http://") {
                return URL(string: imageUrlString.replacingOccurrences(of: "http://", with: "https://"))
            } else {
                return URL(string: "\(api.url)\(imageUrlString)")
            }
        }
        return nil
    }
    
    var body: some View {
        Group {
            if let url = imageUrl {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        configureImage(image)
                    } else {
                        configureImage(Image(placeholderImageName))
                    }
                }
            } else {
                configureImage(Image(placeholderImageName))
            }
        }
        .applyMaxFrame(maxFrame)
        .frame(width: size?.width, height: size?.height)
    }
    
    private func configureImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size?.width, height: size?.height)
            .applyShape(shape)
    }
}


