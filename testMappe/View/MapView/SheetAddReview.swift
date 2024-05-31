import SwiftUI

struct SheetAddReview: View {
    @Environment(\.dismiss) var dismiss
    @State var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @EnvironmentObject var api: ApiManager
    @ObservedObject var mapViewModel: MapModel
    @State var idB : String
    
    
    var body: some View {
        VStack{
            UpperSheet(text: "Describe how you felt", pBottom: 12, pHor: 20)
            RatingsView(cleanStar: $cleanStar, comfortStar: $comfortStar, moodStar: $moodStar)
                .padding(.horizontal, 20)
            
            TextFieldCustom(stateVariable : $mapViewModel.descNewAnnotation ,  name: "Leave a comment")
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            FullRoundedButton(text: "Send Review!")
                .onTapGesture {
                    mapViewModel.sendReview(api: api, cleanStar: cleanStar, comfortStar: comfortStar, moodStar: moodStar, idB: idB)
                    
                    dismiss()
                }
            
        }
        
    }
}

