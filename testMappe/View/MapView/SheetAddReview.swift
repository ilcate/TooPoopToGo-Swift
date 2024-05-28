import SwiftUI

struct SheetAddReview: View {
    @Environment(\.dismiss) var dismiss
    @State var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @EnvironmentObject var api: ApiManager
    @State var idB : String
    
    @State private var descNewAnnotation = ""
    
    var body: some View {
        VStack{
            UpperSheet(text: "Describe how you felt", pBottom: 12, pHor: 20)
            RatingsView(cleanStar: $cleanStar, comfortStar: $comfortStar, moodStar: $moodStar)
                .padding(.horizontal, 20)
            
            TextFieldCustom(stateVariable : $descNewAnnotation ,  name: "Leave a comment")
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            FullRoundedButton(text: "Send Review!")
                .onTapGesture {
                    let lastIndexClean = cleanStar.indices.reversed().first(where: { cleanStar[$0].selected })
                    let lastIndexComfort = cleanStar.indices.reversed().first(where: { comfortStar[$0].selected })
                    let lastIndexAccessibility = cleanStar.indices.reversed().first(where: { moodStar[$0].selected })

                    api.addReview(idB: idB, parameters: AddRating(cleanliness_rating: lastIndexClean, comfort_rating: lastIndexComfort, accessibility_rating: lastIndexAccessibility, review: descNewAnnotation ))
                    
                    dismiss()
                }
            
        }
        
    }
}

