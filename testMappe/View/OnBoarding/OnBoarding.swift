import SwiftUI

struct OnBoardingView: View {
    @ObservedObject var oBModel: OnBoardingModel
    @Binding var path: [String]
    

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                    Text("Skip")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                        .underline()
                        .onTapGesture {
                            path.append("ChoseLogM")
                        }
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()
            ZStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(Array(oBModel.titles.enumerated()), id: \.element) { index, name in
                            VStack {
                                Spacer()
                                Image("onBoarding\(index + 1)")
                                    .resizable()
                                    .renderingMode(.original)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 280, height: 280)
                                    .padding(.top, 36)

                                VStack(spacing: 12) {
                                    Text(oBModel.titles[index])
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 26, fontColor: .accent)
                                        .padding(.top, 70)
                                    Text(oBModel.didas[index])
                                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                                        .padding(.horizontal, 32)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                               
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
                            .padding(.trailing, 10)
                        }
                    }
                    .padding(.trailing, -10)
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $oBModel.position, anchor: .leading)
                .contentMargins(20, for: .scrollContent)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .padding(.bottom, 32)

                VStack {
                    Spacer()
                    HStack(spacing: 6) {
                        ForEach(oBModel.titles, id: \.self) { imageName in
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(imageName == oBModel.position ? .accent : Color.cLightBrown50)
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 3.5)
                }
                .padding(.bottom, 8)
            }

            Spacer()

            FullRoundedButton(text: oBModel.position == oBModel.titles.last ? "Start" : "Next")
                .onTapGesture {
                    oBModel.nextButton(path: path) { updatedPath in
                        path = updatedPath
                    }
                }

        }
        .background(Color.white)
        .onAppear {
            oBModel.position = oBModel.titles[0]
        }
    }
}

