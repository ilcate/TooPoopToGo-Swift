import SwiftUI

struct InsertOtp: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var onBoarding: OnBoarding
    @State private var otp = Array(repeating: "", count: 6)
    @Binding var path: [String]
    @FocusState private var focusedField: Int?

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
                    TextField("", text: $otp[index])
                        .frame(width: 40, height: 40)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: index)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: otp[index]) { newValue in
                            handleTextChange(at: index, newValue: newValue)
                        }
                        .onReceive(otp.publisher.collect()) { _ in
                            sanitizeOTP()
                        }
                }
            }
            .onAppear {
                focusedField = 0
            }
            .padding(.horizontal, 20)

            Spacer()

            FullRoundedButton(text: "Confirm Account")
                .onTapGesture {
                    let otpString = otp.joined()
                    let otpToSend = SendOtp(otp: otpString, email: api.email)

                    api.activateAccount(parameters: otpToSend) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                onBoarding.onBoarding = true
                                path.removeAll()
                                let loginInfo = LogInInformation(username: api.username, password: api.password)
                                api.getToken(userData: loginInfo) { result in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success(let token):
                                            api.saveToken(token: token)
                                        case .failure(_):
                                            path.append("LogIn")
                                            onBoarding.onBoarding = false
                                        }
                                    }
                                }
                            case .failure(let error):
                                print("sorry but no \(error)")
                            }
                        }
                    }
                }

        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(Color.cLightBrown)
    }

    private func handleTextChange(at index: Int, newValue: String) {
        if newValue.count > 1 {
            otp[index] = String(newValue.last!)
        }
        if !newValue.isEmpty {
            if index < 5 {
                focusedField = index + 1
            } else {
                focusedField = nil
            }
        }
    }

    private func sanitizeOTP() {
        for i in 0..<6 where otp[i].count > 1 {
            otp[i] = String(otp[i].last!)
        }
    }
}
