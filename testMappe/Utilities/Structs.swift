//
//  Structs.swift
//  testMappe
//
//  Created by Christian Catenacci on 12/04/24.
//

import Foundation
import SwiftUI
import CoreLocation
import SDWebImage
import SDWebImageSVGCoder

@_spi(Experimental) import MapboxMaps


struct Filters: Identifiable{
    var id = UUID()
    var image: UIImage?
    var name: String
    var selected = false 
    
}


struct Item: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct Stars: Identifiable{
    var id = UUID()
    var selected = false
}


struct accessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: accessCameraView
    
    init(picker: accessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            self.picker.selectedImage = selectedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.picker.selectedImage = originalImage
        }
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

struct GestureProperties {
    var offset: CGFloat = 0
    var lastOffset: CGFloat = 0
}


struct NavigationButton: View {
    var title: String
    var urlScheme: String
    var fallbackURL: String
    
    var body: some View {
        FullRoundedButton(text: title)
            .onTapGesture {
                openNavigationURL(urlScheme: urlScheme, fallbackURL: fallbackURL)
            }
    }
    
    private func openNavigationURL(urlScheme: String, fallbackURL: String) {
        if let url = URL(string: urlScheme), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let fallback = URL(string: fallbackURL) {
            UIApplication.shared.open(fallback, options: [:], completionHandler: nil)
        }
    }
}


struct TextBoxSettings:View {
    let text : String
    var body: some View {
       
            HStack{
                Text(text)
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
                Image("LightArrow")
                    .rotationEffect(.degrees(90))
                    .foregroundStyle(.accent)
            }.padding(.horizontal, 16)
            .padding(.vertical, 12)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        
       
    }
}
