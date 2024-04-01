//
//  LoanHistoryView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

struct LoanHistoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = LoanViewModel.shared
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
                
                Text("Loan History")
                    .font(
                        .system(size: 16, weight: .heavy, design: .rounded)
                    )
            }

            List {
                ForEach(0..<viewModel.savedRecords.count, id: \.self) { index in
                    let record = viewModel.savedRecords[index]
                    let presentValue = commonFunctions.getFormattedDecimalString(value: record.presentValue)
                    let futureValue = commonFunctions.getFormattedDecimalString(value: record.futureValue)
                    let interestRate = commonFunctions.getFormattedDecimalString(value: record.interest)
                    
                    Text("\(presentValue), \(futureValue), \(interestRate) % ...")
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

struct LoanHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        LoanHistoryView()
    }
}
