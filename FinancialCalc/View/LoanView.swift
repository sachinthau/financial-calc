//
//  LoanView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

struct LoanView: View {
    
    @ObservedObject private var viewModel = LoanViewModel.shared
    @State private var plusMinus = PlusMinus.plus
    @State private var showHistory = false
    @State private var showHelp = false
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemGreen
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black], for: .selected
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Form view design
                Form {
                    Section {
                        VStack(alignment: .leading) {
                            TextField("Present Value", text: $viewModel.presentValue.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.presentValue.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            TextField("Future Value", text: $viewModel.futureValue.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.futureValue.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            TextField("Interest (%)", text: $viewModel.interest.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.interest.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            TextField("No of Payments Per Year", text: $viewModel.paymentsPerYear.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.paymentsPerYear.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            TextField("Compounds Per Year", text: $viewModel.compoundsPerYear.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.compoundsPerYear.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            TextField("Payment", text: $viewModel.payment.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.payment.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("History")
                                .foregroundColor(Color(hex: 0x1E90FF))
                            
                            Spacer()
                            
                            Button {
                                showHistory.toggle()
                            } label: {
                                Label("", systemImage: "clock.arrow.circlepath")
                                    .font(.system(size: 20))
                            }
                            .fullScreenCover(isPresented: $showHistory, content: {
                                LoanHistoryView()
                            })
                        }
                        
                        HStack {
                            Text("Help")
                                .foregroundColor(Color(hex: 0x1E90FF))
                            
                            Spacer()
                            
                            Button {
                                showHelp.toggle()
                            } label: {
                                Label("", systemImage: "questionmark.circle")
                                    .font(.system(size: 20))
                            }
                            .fullScreenCover(isPresented: $showHelp, content: {
                                LoanHelpView()
                            })
                        }
                    }
                    
                    Button(role: .destructive) {
                        viewModel.clearValues()
                    } label: {
                        Text("Clear All")
                    }
                }
            }
            
            // Navigation view config
            .navigationTitle("Loan")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        hideKeyboard()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    
                    Button("Calculate", action: viewModel.onPressCalc)
                        .alert(isPresented: $viewModel.allFieldsFilledAlertPresented) {
                            Alert(title: Text("Alert"),
                                  message: Text("Please leave one of the values blank to perform the calculation"),
                                  dismissButton:
                                    .default(Text("Ok"),
                                             action: {
                                viewModel.allFieldsFilledAlertPresented = false
                            })
                            )
                        }
                }
            }
        }
    }
}

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        LoanView()
    }
}

