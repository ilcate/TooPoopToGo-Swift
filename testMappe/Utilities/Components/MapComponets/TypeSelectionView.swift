

import SwiftUI

struct TypeSelectionView:  View {
    @Binding var optionsDropDown: [String]
    @State private var editDropDown = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Type")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            HStack {
                
                VStack(alignment: .center){
                    Image("\(optionsDropDown[0])Stroke")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.accent)
                }.frame(width: 30, height: 30)
                    .padding(.leading, -5)
                Text(optionsDropDown[0])
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accentColor)
                Spacer()
                Image("LightArrow")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.accent)
                    .rotationEffect(editDropDown ? .zero : .degrees(180))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 17)
            .background(.white)
            .clipShape(.capsule)
            .onTapGesture {
                withAnimation(.bouncy) {
                    editDropDown.toggle()
                }
            }
            
            if editDropDown {
                ForEach(optionsDropDown.indices.dropFirst(), id: \.self) { index in
                    let element = optionsDropDown[index]
                    HStack {
                        VStack(alignment: .center){
                            Image("\(element)Stroke")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.accent)
                        }.frame(width: 30, height: 30)
                            .padding(.leading, -8)
                       
                        Text(element)
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accentColor)
                        Spacer()
                        
                       
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(Capsule())
                    .onTapGesture {
                        optionsDropDown.remove(at: index)
                        optionsDropDown.insert(element, at: 0)
                        withAnimation(.bouncy) {
                            editDropDown = false
                        }
                    }
                }
            }
        }
    }
}
