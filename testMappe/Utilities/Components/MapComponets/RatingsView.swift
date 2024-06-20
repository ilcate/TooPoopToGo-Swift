import SwiftUI


struct RatingsView: View {
    @Binding var cleanStar : [Stars]
    @Binding var comfortStar : [Stars]
    @Binding var moodStar : [Stars]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ratings")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            VStack {
                RatingsStars(RatingName: "Cleanliness", RatingStars: $cleanStar)
                RatingsStars(RatingName: "Comfort", RatingStars: $comfortStar)
                RatingsStars(RatingName: "Accessible", RatingStars: $moodStar)
                
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
