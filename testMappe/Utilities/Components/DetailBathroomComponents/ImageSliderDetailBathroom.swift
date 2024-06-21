import SwiftUI

struct ImageSliderDetailBathroom: View {
    @EnvironmentObject var api : ApiManager
    @State var bathroom : BathroomApi
    @State private var currentImage : Photos?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            if bathroom.photos?.count != 1 {
                ScrollView(.horizontal){
                    LazyHStack(spacing: 0){
                        if !bathroom.photos!.isEmpty {
                            ForEach(Array(bathroom.photos!.enumerated()), id: \.1.self) { index, _ in
                                if let photos = bathroom.photos, !photos.isEmpty, let photo = photos[index].photo, let url = URL(string: "\(api.url)\(photo)") {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .resizableImageStyleBig()
                                    } placeholder: {
                                        DeatailImageDef()
                                    }
                                } else {
                                    DeatailImageDef()
                                }
                            }
                        }else{
                            DeatailImageDef()
                        }
                        
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $currentImage, anchor: .leading)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea(.all, edges: .top)
            }else{
                VStack{
                    if let photos = bathroom.photos, !photos.isEmpty, let photo = photos[0].photo, let url = URL(string: "\(api.url)\(photo)") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .resizableImageStyleBig()
                            
                        } placeholder: {
                            DeatailImageDef()
                        }
                    } else {
                        DeatailImageDef()
                    }
                }.ignoresSafeArea(.all, edges: .top)
                    
                
            }
            
            VStack{
                HStack{
                    Image("BackArrow")
                        .uiButtonStyle(backgroundColor: .white)
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                    ShareLink(item: "Hi, I suggest you to open Too Poop To Go and search for “\(bathroom.name!)”, it could save you in case of need") {
                        Image("Share")
                            .uiButtonStyle(backgroundColor: .white)
                    }
                        
                }.padding(.top,  8)
                Spacer()
            }.padding(.horizontal, 20)
            
            if bathroom.photos!.count > 1 {
                VStack {
                    Spacer()
                    withAnimation(.smooth) {
                        
                        HStack{

                            HStack(spacing: 6) {
                                ForEach(bathroom.photos!, id: \.self) { imageName in
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(imageName == currentImage ? Material.ultraThick : Material.ultraThin)
                                    
                                }
                            }
                            .padding(.vertical, 2)
                            .padding(.horizontal, 3.5)
                            
                            Spacer()
                            
                            
                        }
                    }
                }
                .padding(.bottom, 16)
                .padding(.leading, 20)
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: 280)
        .onAppear{
            
            if !bathroom.photos!.isEmpty{
                currentImage = bathroom.photos![0]
            }
           
        }
        .navigationBarBackButtonHidden(true)
    }
}
