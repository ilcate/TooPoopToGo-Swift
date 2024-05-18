//
//  Classes.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 18/05/24.
//

import Foundation

class TabBarSelection: ObservableObject {
    //pubilished fa si che il valore sia reattivo
    @Published var selectedTab: Int = 0
    @Published var destination: [CGFloat] = []
}

class IsTexting: ObservableObject {
    @Published var texting = false
    @Published var page = false
}

class OnBoarding: ObservableObject {//salvataggio in locale della variabile
    @Published var onBoarding: Bool {
        didSet {
            UserDefaults.standard.set(onBoarding, forKey: "onBoarding")
        }
    }
    init() {
        self.onBoarding = UserDefaults.standard.bool(forKey: "onBoarding")
    }
}
