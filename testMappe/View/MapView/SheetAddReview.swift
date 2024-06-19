import SwiftUI

struct SheetAddReview: View {
    @Environment(\.dismiss) var dismiss
    @State var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var mapViewModel: MapModel
    @State var idB : String
    @State var showError = false
    
    
    var body: some View {
        VStack{
            UpperSheet(text: "Describe how you felt", pBottom: 10, pHor: 20)
                .padding(.top, 10)
            RatingsView(cleanStar: $cleanStar, comfortStar: $comfortStar, moodStar: $moodStar)
                .padding(.horizontal, 20)
            
            TextFieldCustom(stateVariable : $mapViewModel.descNewAnnotation, name: "Leave a comment")
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            ZStack{
                FullRoundedButton(text: "Send Review!")
                    .onTapGesture {
                        if  mapViewModel.descNewAnnotation != ""{
                            mapViewModel.sendReview(api: api, cleanStar: cleanStar, comfortStar: comfortStar, moodStar: moodStar, idB: idB)
                            mapViewModel.resetAddParams()
                            
                            dismiss()
                        } else {
                            showError = true
                        }
                       
                    }
                
                if showError {
                    Text("Remember to comment it")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .red)
                        .padding(.bottom, 70)
                }
                
                
            } .padding(.bottom, -20).ignoresSafeArea()
            
            
            
            
        }
        
    }
}

