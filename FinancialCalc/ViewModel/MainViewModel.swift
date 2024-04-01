//
//  MainViewModel.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    static let shared = MainViewModel()
    
    @Published var selectedTabIndex = 0
    
    func setSelectedTabIndex(index: Int) {
        self.selectedTabIndex = index
        objectWillChange.send()
    }
    
    private init() {
        // Private init
    }
}
