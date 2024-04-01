//
//  MortgageViewModel.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI
import CoreData

class MortgageViewModel: ObservableObject {
    
    static let shared = MortgageViewModel()
    
    private let userDefaults = UserDefaults.standard;
    private let commonFunctions = CommonFunctions()
    private let dataContainer: NSPersistentContainer
    
    @Published var savedRecords: [MortgageData] = []
    
    @Published var interest = FormComponentModel(value: "", keyTag: "mortgageInterest") {
            didSet {
                userDefaults.set(interest.value, forKey: interest.keyTag)
                interest.clearError()
            }
        }
    @Published var payment = FormComponentModel(value: "", keyTag: "mortgagePayment") {
            didSet {
                userDefaults.set(payment.value, forKey: payment.keyTag)
                payment.clearError()
            }
        }
    
    @Published var noOfYears = FormComponentModel(value: "", keyTag: "noOfYears") {
            didSet {
                userDefaults.set(noOfYears.value, forKey: noOfYears.keyTag)
                noOfYears.clearError()
            }
        }
    @Published var loanAmount = FormComponentModel(value: "", keyTag: "mortgageAmount") {
            didSet {
                userDefaults.set(loanAmount.value, forKey: loanAmount.keyTag)
                loanAmount.clearError()
            }
        }
    @Published var allFieldsFilledAlertPresented = false
    
    private init() {
        // Config persistance data
        dataContainer = NSPersistentContainer(name: "Financial_Calc")
        dataContainer.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA ::: \(error)")
            } else {
                print("CORE DATA LOADED")
            }
        }
        
        fetchDataRecords()
        
        // get user default values if available and set to the each instance value property
        self.loanAmount.value = userDefaults.string(forKey: loanAmount.keyTag) ?? ""
        self.noOfYears.value = userDefaults.string(forKey: noOfYears.keyTag) ?? ""
        self.interest.value = userDefaults.string(forKey: interest.keyTag) ?? ""
        self.payment.value = userDefaults.string(forKey: payment.keyTag) ?? ""
    }
    
    func fetchDataRecords() {
        let request = NSFetchRequest<MortgageData>(entityName: "MortgageData")
        
        do {
            savedRecords = try dataContainer.viewContext.fetch(request)
            
        } catch let error {
            print("ERROR FETCH MortgageData RECORDS ::: \(error)")
        }
    }
    
    func addDataRecord() {
        let newRecord = MortgageData(context: dataContainer.viewContext)
        
        newRecord.loanAmount = self.loanAmount.formattedValue
        newRecord.noOfYears = self.noOfYears.formattedValue
        newRecord.interest = self.interest.formattedValue * 100
        newRecord.payment = self.payment.formattedValue
        
        saveDataRecord()
    }
    
    func saveDataRecord() {
        do {
            try dataContainer.viewContext.save()
            fetchDataRecords()
        } catch let error {
            print("ERROR SAVE MortgageData RECORD ::: \(error)")
        }
        
    }
    
    func deleteRecord(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        let record = savedRecords[index]
        dataContainer.viewContext.delete(record)
        
        saveDataRecord()
    }
    
    func onSelectRecord(record: MortgageData) {
        self.loanAmount.value = record.loanAmount.description
        self.noOfYears.value = record.noOfYears.description
        self.interest.value = record.interest.description
        self.payment.value = record.payment.description
        
        objectWillChange.send()
    }
    
    // calc button press handler
    func onPressCalc() {
        self.prepareEachValue(formComponent: loanAmount)
        self.prepareEachValue(formComponent: noOfYears)
        self.prepareEachValue(formComponent: interest)
        self.prepareEachValue(formComponent: payment)

        self.validateForm()
        objectWillChange.send()
    }
    
    private func prepareEachValue(formComponent: FormComponentModel)
    {
        if let value = Double(formComponent.value) {
            formComponent.isEmpty = false
            let formattedValue  = commonFunctions.getFormattedDecimalDouble(value: value)
            formComponent.formattedValue = formattedValue
            formComponent.value = commonFunctions.getFormattedDecimalString(value: formattedValue)
        } else {
            formComponent.isEmpty = true
            formComponent.formattedValue = 0
        }
    }
    
    private func validateForm()
    {
        // Empty fields store
        var emptyFormComponents = [FormComponentModel] ()

        // Calculation method store
        var functionToPerform : (() -> ())?

        if(loanAmount.isEmpty)
        {
            emptyFormComponents.append(loanAmount)
            functionToPerform = calculateLoanAmount
        }
        if(noOfYears.isEmpty)
        {
            emptyFormComponents.append(noOfYears)
            functionToPerform = calculateNoOfYears
        }
        if(interest.isEmpty)
        {
            emptyFormComponents.append(interest)
            functionToPerform = calculateInterest
        }
        if(payment.isEmpty)
        {
            emptyFormComponents.append(payment)
            functionToPerform = calculatePayment
        }


        // If not empty field, display alert
        if(emptyFormComponents.count == 0)
        {
            allFieldsFilledAlertPresented = true
        }

        // found exaclty one empty field to perform our operation
        else if(emptyFormComponents.count == 1)
        {
            interest.formattedValue = interest.formattedValue / 100 //0.50

            //calculate future value based on PMT
            if functionToPerform != nil
            {
                prepareEachValue(formComponent: payment)
                functionToPerform!()
            }

            // Add for the core data
            addDataRecord()
        }
        else
        {
            // Show red in text fields
            emptyFormComponents.forEach {formCoponent in
                formCoponent.setError()
            }
        }

    }

   // Different calculators
    func calculateLoanAmount()
     {
         // TODO
     }

    func calculateInterest()
    {
        // TODO
    }

    func calculateNoOfYears()
    {
        // TODO
    }

    func calculatePayment()
    {
        let interestRate = interest.formattedValue / 12
        let noMonths = noOfYears.formattedValue * 12
        
        payment.formattedValue = loanAmount.formattedValue * interestRate / (1 - (pow(1/(1 + interestRate), noMonths)));
        
        payment.value = commonFunctions.getFormattedDecimalString(value: payment.formattedValue)
    }
    
    func clearValues() {
        self.noOfYears.value = ""
        self.loanAmount.value = ""
        self.interest.value = ""
        self.payment.value = ""
        
        objectWillChange.send()
    }
}
