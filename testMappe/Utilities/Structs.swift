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

