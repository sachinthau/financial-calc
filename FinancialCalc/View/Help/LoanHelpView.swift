//
//  LoanHelpView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

struct LoanHelpView: View {
    
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
                
                Text("Loan Help")
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
                Text("You can calculate loan with no. payments or interest rate")
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
            
            Spacer()
        }
    }
}

struct LoanHelpView_Previews: PreviewProvider {
    static var previews: some View {
        LoanHelpView()
    }
}
