
import SwiftUI

struct RatingsBathroomDetail: View {
    @Binding var informationStat: GetRatingStats
    @State var starToDisplay: [Int] = [5, 5, 5]
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(informationStat.review_count == 0 ? "Has no reviews" : informationStat.review_count == 1 ? "With \(informationStat.review_count) review" : "With \(informationStat.review_count) reviews")
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 20, fontColor: .accent)
                Spacer()
                HStack(spacing: 4) {
                    Image("StarFill")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.accentColor)
                    Text(informationStat.overall_rating)
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 30)
            .padding(.horizontal, 12)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundStyle(.cLightBrown)
            HStack {
                VStack(spacing: 1) {
                    Text("Cleanliness")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                    DispStarsRating(starToDisplay: starToDisplay[0])
                }
                .frame(maxWidth: .infinity, maxHeight: 30)
                Rectangle()
                    .frame(maxWidth: 2, maxHeight: .infinity)
                    .foregroundStyle(.cLightBrown)
                    .ignoresSafeArea(.all)
                VStack(spacing: 1) {
                    Text("Comfort")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                    DispStarsRating(starToDisplay: starToDisplay[1])
                }
                .frame(maxWidth: .infinity, maxHeight: 30)
                Rectangle()
                    .frame(maxWidth: 2, maxHeight: .infinity)
                    .foregroundStyle(.cLightBrown)
                    .ignoresSafeArea(.all)
                VStack(spacing: 1) {
                    Text("Accessibility")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                    
                    DispStarsRating(starToDisplay: starToDisplay[2])
                }
                .padding(.horizontal, -2)
                .frame(maxWidth: .infinity, maxHeight: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: 55)
            .padding(.top, -10)
            .padding(.horizontal, 12)
            .ignoresSafeArea(.all)
        }
        .frame(maxWidth: .infinity, maxHeight: 105)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.cLightBrown, lineWidth: 2)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .task{
            if let cleanlinessRating = Double(informationStat.cleanliness_rating),
               let comfortRating = Double(informationStat.comfort_rating),
               let accessibilityRating = Double(informationStat.accessibility_rating) {
                
                let roundedCleanliness = Int(cleanlinessRating.rounded())
                let roundedComfort = Int(comfortRating.rounded())
                let roundedAccessibility = Int(accessibilityRating.rounded())
                starToDisplay = [roundedCleanliness, roundedComfort, roundedAccessibility]
                
            } else {
                starToDisplay = [5, 5, 5]
            }
        }
    }
    
    
}
