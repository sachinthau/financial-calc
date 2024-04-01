//
//  GlassMorphicCardView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

struct GlassMorphicCardView : View {
    
    var tabItem: TabItem
    private let size: CGFloat = CGFloat(160)
    @ObservedObject private var viewModel = MainViewModel.shared
    
    init(tabItem: TabItem) {
        self.tabItem = tabItem
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .opacity(0.1)
                .background(
                    Color.white
                        .opacity(0.08)
                        .blur(radius: 10)
                )
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            .linearGradient(.init(colors: [
                                .white,
                                .purple.opacity(0.5),
                                .clear,
                                .clear,
                                .white
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 2.5
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
            VStack {
                Image(systemName: tabItem.iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 76, weight: .thin))
                
                Text(tabItem.title)
                    .foregroundColor(.white)
                    .font(
                        .system(size: 16, weight: .heavy, design: .rounded)
                    )
                    .padding(.top, 4)
            }
        }
        .frame(width: size, height: size)
        .onTapGesture {
            self.viewModel.setSelectedTabIndex(index: tabItem.index)
        }
    }
}
