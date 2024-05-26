import SwiftUI

struct SheetAddReview: View {
    @Environment(\.dismiss) var dismiss
    var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    
    @State private var descNewAnnotation = ""
    
    var body: some View {
        VStack{
            UpperSheet(text: "Describe how you felt", pBottom: 12, pHor: 20)
            RatingsView()
                .padding(.horizontal, 20)
            
            TextFieldCustom(stateVariable : $descNewAnnotation ,  name: "Leave a comment")
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            FullRoundedButton(text: "Send Review!")
                .onTapGesture {
                    dismiss()
                }
            
        }
        
    }
}

