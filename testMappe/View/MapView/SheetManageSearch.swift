
import SwiftUI

//TODO: un bel refactor di tutte le parti sopra delle sheet con un unico bel componente
//TODO: componente riutilizzabile del bottone lungo
public struct SheetManageSearch: View {
    @ObservedObject var mapViewModel : MapModel

    
    
    @State private var range = 100.0...3904.35
    @State private var selection  = 100.0...300.0
     var minimumDistance : CGFloat = 155.27986
    @State private var slider1: GestureProperties = .init()
    @State private var slider2: GestureProperties = .init()
    @State private var indicatorWidth: CGFloat = 0
    
    
    

    
    
    private func calculateNewRange(_ size: CGSize){
        indicatorWidth = slider2.offset - slider1.offset + 1
        
        let maxWidth = size.width - 100
        let startProgress = slider1.offset / maxWidth
        let endProgress = slider2.offset / maxWidth
        
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
        
        selection = newRangeStart...newRangeEnd
    }
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        VStack{
            HStack {
                Text("What are you looking for?")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                    .onTapGesture {
            
                    }
                Spacer()
                Image("Close")
                    .resizable()
                    .foregroundStyle(.accent)
                    .padding(4)
                    .background(.white)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .onTapGesture {
                        dismiss()
                    }
            }
            
            HStack{
                Text("Distance")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
                Text("\(Int(selection.lowerBound))-\(Int(selection.upperBound))")
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
            }
            
            GeometryReader { reader in
                let maxSliderWhith = reader.size.width - 28
                let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance/(range.upperBound-range.lowerBound)) * maxSliderWhith
                
                ZStack(alignment: .leading){
                    Capsule()
                        .foregroundStyle(.white)
                        .frame(height: 5)
                    
                    HStack(spacing: 0){
                        Circle()
                            .foregroundStyle(.accent)
                            .frame(width: 14, height: 14)
                            .contentShape(.rect)
                            .overlay(alignment: .leading){
                                Rectangle()
                                    .foregroundStyle(.accent)
                                    .frame(width: indicatorWidth, height: 5)
                                    .offset(x: 13.5)
                                    .allowsHitTesting(false)
                            }
                            .offset(x: slider1.offset)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged{ value in
                                        var translation = value.translation.width + slider1.lastOffset
                                        translation = min(max(translation, 0), slider2.offset - minimumDistance)
                                        slider1.offset = translation
                                        calculateNewRange(reader.size)

                                    }.onEnded{ _ in
                                        slider1.lastOffset = slider1.offset
                                    }
                            )
                        Circle()
                            .foregroundStyle(.accent)
                            .frame(width: 14, height: 14)
                            .contentShape(.rect)
                            .offset(x: slider2.offset)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged{ value in
                                        var translation = value.translation.width + slider2.lastOffset
                                        translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWhith)
                                        slider2.offset = translation
                                        calculateNewRange(reader.size)
                                    }.onEnded{ _ in
                                        slider2.lastOffset = slider2.offset
                                    }
                            )
                    }
                }
                .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)

            }
            .frame(height: 14)
            
            HStack{
                Text("Tags")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
            }
            FilterBottom(mapViewModel: mapViewModel)
                
        }.padding(.horizontal, 20)
        
    }
}

struct GestureProperties {
    var offset: CGFloat = 0
    var lastOffset: CGFloat = 0
}


