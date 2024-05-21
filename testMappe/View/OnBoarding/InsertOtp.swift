import SwiftUI

struct InsertOtp: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var onBoarding: OnBoarding
    @Binding var path: [String]
    @FocusState var focusedField: Int?

    @ObservedObject var oBModel: OnBoardingModel

    var body: some View {
        VStack {
            HStack {
                Text("Insert otp")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 6)

            Spacer()

            HStack(spacing: 8) {
                ForEach(0..<6) { index in
                    TextField("", text: $oBModel.otp[index])
                        .frame(width: 40, height: 40)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: index)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: oBModel.otp[index], { oldValue, newValue in
                            oBModel.handleTextChange(at: index, newValue: newValue, focusedField: &focusedField)
                        })
                    
                    
                        .onReceive(oBModel.otp.publisher.collect()) { _ in
                            oBModel.sanitizeOTP()
                        }
                }
            }
            .onAppear {
                focusedField = 0
            }
            .padding(.horizontal, 20)

            Spacer()
            if !oBModel.otpOk{
                Text("The code is wrong, try again!")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .red)
            }

            FullRoundedButton(text: "Confirm Account")
                .onTapGesture {
                    oBModel.insertOTP(path: path, api: api, onBoarding: onBoarding) { updatedPath in
                        path = updatedPath
                    }
                }

        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(Color.cLightBrown)
    }
}

