import SwiftUI

struct DisplayTagsB: View {
    let arrOfAllTags = ["Accessible", "Free", "Babies", "Newest", "Public", "Shop", "Restaurant", "Bar"]
    let arrBool: [Bool]
    let limit: Int
    
    var body: some View {
        HStack {
            let displayedTags = arrOfAllTags.indices.filter { arrBool[$0] }.prefix(limit)
            ForEach(displayedTags, id: \.self) { index in
                SmallTag(text: arrOfAllTags[index])
            }
        }
    }
}
