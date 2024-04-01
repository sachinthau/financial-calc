//
//  SavingsHelpView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

struct SavingsHelpView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(
                            .system(size: 20)
                        )
                        .padding(20)
                })
                
                Text("Savings Help")
                    .font(
                        .system(size: 16, weight: .heavy, design: .rounded)
                    )
            }
            
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "staroflife.fill")
                    .foregroundColor(.purple)
                    .opacity(0.7)
                    .font(
                        .system(size: 14)
                    )
                    .padding(10)
                Text("You can calculate savings with no. further payments or with regular contributions")
                    .font(
                        .system(size: 16, weight: .regular, design: .rounded)
                    )
            }
            .padding()
            
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "staroflife.fill")
                    .foregroundColor(.purple)
                    .opacity(0.7)
                    .font(
                        .system(size: 14)
                    )
                    .padding(10)
                Text("Present Value, Future Value, Interest Rate, No of Payments Per Year and Payment can be calculated using this app.")
                    .font(
                        .system(size: 16, weight: .regular, design: .rounded)
                    )
            }
            .padding()
            
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "staroflife.fill")
                    .foregroundColor(.purple)
                    .opacity(0.7)
                    .font(
                        .system(size: 14)
                    )
                    .padding(10)
                Text("Leave the field blank on the parameter that you want to solve and please fill the rest.")
                    .font(
                        .system(size: 16, weight: .regular, design: .rounded)
                    )
            }
            .padding()
            
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "staroflife.fill")
                    .foregroundColor(.purple)
                    .opacity(0.7)
                    .font(
                        .system(size: 14)
                    )
                    .padding(10)
                Text("When calculating future value either payment can be specified or leave it empty for fixed sum investment.")
                    .font(
                        .system(size: 16, weight: .regular, design: .rounded)
                    )
            }
            .padding()
            
            Spacer()
        }
    }
}

struct SavingsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsHelpView()
    }
}
