//
//  SavingsView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-27.
//

import SwiftUI

enum PlusMinus: String {
    case plus = "+"
    case minus = "-"
}

struct SavingsView: View {
    
    @ObservedObject private var viewModel = SavingsViewModel.shared
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
                    
                    Section(header: Text("Payment")) {
                        HStack(spacing: 16) {
                            Picker("", selection: $plusMinus) {
                                Text(PlusMinus.plus.rawValue)
                                    .tag(PlusMinus.plus)
                                Text(PlusMinus.minus.rawValue)
                                    .tag(PlusMinus.minus)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 100)
                            
                            VStack(alignment: .leading) {
                                TextField("Value", text: $viewModel.payment.value)
                                    .keyboardType(.decimalPad)
                                
                                if viewModel.payment.isError {
                                    Text("Invalid entry")
                                        .foregroundColor(.red).opacity(0.7)
                                        .font(.system(size: 10, weight: .semibold)
                                        )
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Payment Made At")) {
                        Picker("", selection: $viewModel.paymentMadeAtEnd) {
                            Text("Beginning")
                                .tag(false)
                            Text("End")
                                .tag(true)
                        }
                        .pickerStyle(.segmented)
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
                                SavingsHistoryView()
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
                                SavingsHelpView()
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
            .navigationTitle("Savings")
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

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsView()
    }
}
