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

            OTPTextField(numberOfFields: 6, otpValues: $oBModel.otp)
                .onAppear {
                    focusedField = 0
                }
                .padding(.horizontal, 20)

            Spacer()
            if !oBModel.otpOk {
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

struct OTPTextField: View {
    let numberOfFields: Int
    @Binding var otpValues: [String]
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $otpValues[index], onEditingChanged: { editing in
                    if editing {
                        oldValue = otpValues[index]
                    }
                })
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                .keyboardType(.numberPad)
                .frame(width: 48, height: 48)
                .background(.cLightGray)
                .cornerRadius(5)
                .multilineTextAlignment(.center)
                .focused($fieldFocus, equals: index)
                .onChange(of: otpValues[index]) { o, newValue in
                    
                    if !newValue.isEmpty {
                        if otpValues[index].count > 1 {
                            let currentValue = Array(otpValues[index])
                            if String(currentValue[0]) == oldValue {
                                otpValues[index] = String(currentValue.suffix(1))
                            } else {
                                otpValues[index] = String(currentValue.prefix(1))
                            }
                        }

                        if index == numberOfFields - 1 {
                            fieldFocus = nil
                        } else {
                            fieldFocus = (fieldFocus ?? 0) + 1
                        }
                    } else {
                        fieldFocus = (fieldFocus ?? 0) - 1
                    }
                }
            }
        }
    }
}

extension String {
    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }
}
