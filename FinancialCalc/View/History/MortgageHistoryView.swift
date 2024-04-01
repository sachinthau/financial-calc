//
//  MortgageView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

struct MortgageHistoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = MortgageViewModel.shared
    private let commonFunctions = CommonFunctions()
    
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
                
                Text("Mortgage History")
                    .font(
                        .system(size: 16, weight: .heavy, design: .rounded)
                    )
            }

            List {
                ForEach(0..<viewModel.savedRecords.count, id: \.self) { index in
                    let record = viewModel.savedRecords[index]
                    let loanAmount = commonFunctions.getFormattedDecimalString(value: record.loanAmount)
                    let payment = commonFunctions.getFormattedDecimalString(value: record.payment)
                    let interestRate = commonFunctions.getFormattedDecimalString(value: record.interest)
                    
                    Text("\(loanAmount), \(payment), \(interestRate) % ...")
                        .font(
                            .system(size: 14, weight: .semibold, design: .rounded)
                        )
                        .onTapGesture {
                            viewModel.onSelectRecord(record: record)
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                .onDelete(perform: viewModel.deleteRecord)
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct MortgageHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MortgageHistoryView()
    }
}
