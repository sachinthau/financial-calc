//
//  ContentView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-26.
//

import SwiftUI

struct HomeView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var tabItems: [TabItem]
    
    init(tabItems: [TabItem]) {
        self.tabItems = tabItems
    }
    
    var body: some View {
        let heightDivider = screenHeight < 720 ? CGFloat(20) : CGFloat(10);
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text("Hello,")
                    .foregroundColor(.white)
                    .font(
                        .system(size: 48, weight: .heavy, design: .rounded)
                    )
                Text("Have a nice day ...!")
                    .foregroundColor(.white.opacity(0.6))
                    .font(
                        .system(size: 24, weight: .heavy, design: .rounded)
                    )
            }
            .padding(.bottom, screenHeight / heightDivider)
            .padding(.leading, 20)
            
            HStack {
                VStack {
                    GlassMorphicCardView(tabItem: tabItems[1])
                        .padding()
                    
                    GlassMorphicCardView(tabItem: tabItems[2])
                        .padding()
                }
                
                VStack {
                    GlassMorphicCardView(tabItem: tabItems[3])
                        .padding()
                }
            }
            .padding(.bottom, screenHeight / heightDivider)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(Color(hex: 0x8B0ACF))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(tabItems: [])
    }
}
