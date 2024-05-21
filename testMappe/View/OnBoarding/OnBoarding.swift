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
                        ForEach(oBModel.PagesOnBoarding, id: \.self) { name in
                            VStack {
                                Image("ImagePlaceHolder3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 260, height: 340)

                                VStack(spacing: 12) {
                                    Text("\(name) fun in town")
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 26, fontColor: .accent)
                                    Text("Welcome to Too Poop To Go, your best firend when in need for a nice and comfy toilet!")
                                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                                        .padding(.horizontal, 36)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.top, 28)
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
                        ForEach(oBModel.PagesOnBoarding, id: \.self) { imageName in
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

            FullRoundedButton(text: oBModel.position == oBModel.PagesOnBoarding.last ? "Start" : "Next")
                .onTapGesture {
                    oBModel.nextButton(path: path) { updatedPath in
                        path = updatedPath
                    }
                }

        }
        .background(Color.cLightBrown)
        .onAppear {
            oBModel.position = oBModel.PagesOnBoarding[0]
        }
    }
}
