//
//  ContentView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = MainViewModel.shared

    let tabBarIcons = [
        TabItem(index: 0, title: NSLocalizedString("home", comment: ""), iconName: "rectangle.3.group"),
        TabItem(index: 1, title: NSLocalizedString("savings", comment: ""), iconName: "archivebox"),
        TabItem(index: 2, title: NSLocalizedString("mortgage", comment: ""), iconName: "house.fill"),
        TabItem(index: 3, title: NSLocalizedString("loan", comment: ""), iconName: "dollarsign.circle")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch viewModel.selectedTabIndex {
                case 0:
                    HomeView(tabItems: tabBarIcons)
                case 1:
                    SavingsView()
                case 2:
                    MortgageView()
                case 3:
                    LoanView()
                default:
                    Text("Remaining tabs")
                }
            }
            
            // Tabbar section
            HStack(alignment: .firstTextBaseline) {
                let selectedTabColor = colorScheme == .dark ? Color(.white) : Color(.black)
                let tabColor = colorScheme == .dark ? Color(.white).opacity(0.5) : .init(white: 0.8)
                
                ForEach(0..<tabBarIcons.count, id: \.self) { index in
                    let isSelected = viewModel.selectedTabIndex == index
                    let tabItem = tabBarIcons[index]
                    
                    Button(action: {
                        viewModel.setSelectedTabIndex(index: index)
                    }, label: {
                        Spacer()
                        if index == 0 {
                            VStack {
                                Image(systemName: tabItem.iconName)
                                    .font(
                                        .system(size: 44, weight: .bold)
                                    )
                                    .foregroundColor(
                                        isSelected ? Color(hex: 0x8B0ACF) : tabColor
                                    )
                                
                                Text(tabItem.title)
                                    .padding(.top, 2)
                                    .foregroundColor(
                                        isSelected ? Color(hex: 0x8B0ACF) : tabColor
                                    )
                                    .font(
                                        .system(size: 10, weight: .heavy, design: .rounded)
                                    )
                            }
                        } else {
                            VStack {
                                Image(systemName: tabItem.iconName)
                                    .font(
                                        .system(size: isSelected ? 28 : 24, weight: .bold)
                                    )
                                    .foregroundColor(
                                        isSelected ? selectedTabColor : tabColor
                                    )
                                
                                Text(tabItem.title)
                                    .padding(.top, 2)
                                    .foregroundColor(
                                        isSelected ? selectedTabColor : tabColor
                                    )
                                    .font(
                                        .system(size: 10, weight: .heavy, design: .rounded)
                                    )
                            }
                        }
                        Spacer()
                    })
                }
            }
            .padding(.top, 8)
            .background(
                Color.white
                    .shadow(color: viewModel.selectedTabIndex == 0 ? Color.indigo : Color.gray, radius: 8, x: 0, y: 0)
                    .mask(Rectangle().padding(.top, -20))
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.light)
    }
}

// Hexadecimal colors
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
