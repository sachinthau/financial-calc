//
//  SavingsViewModel.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI
import CoreData

class LoanViewModel: ObservableObject {
    
    static let shared = LoanViewModel()
    
    private let userDefaults = UserDefaults.standard;
    private let commonFunctions = CommonFunctions()
    private let dataContainer: NSPersistentContainer
    
    @Published var savedRecords: [LoanData] = []
    
    
    @Published var presentValue = FormComponentModel(value: "", keyTag: "loanPresentValue") {
        didSet {
            userDefaults.set(presentValue.value, forKey: presentValue.keyTag)
            presentValue.clearError()
        }
    }
    @Published var futureValue = FormComponentModel(value: "", keyTag: "loanFutureValue") {
            didSet {
                userDefaults.set(futureValue.value, forKey: futureValue.keyTag)
                futureValue.clearError()
            }
        }
    @Published var compoundsPerYear = FormComponentModel(value: "", keyTag: "loanCompoundsPerYear") {
            didSet {
                userDefaults.set(compoundsPerYear.value, forKey: compoundsPerYear.keyTag)
                compoundsPerYear.clearError()
            }
        }
    @Published var interest = FormComponentModel(value: "", keyTag: "loanInterest") {
            didSet {
                userDefaults.set(interest.value, forKey: interest.keyTag)
                interest.clearError()
            }
        }
    @Published var payment = FormComponentModel(value: "", keyTag: "loanPayment") {
            didSet {
                userDefaults.set(payment.value, forKey: payment.keyTag)
                payment.clearError()
            }
        }
    @Published var paymentsPerYear = FormComponentModel(value: "", keyTag: "loanPaymentsPerYear") {
            didSet {
                userDefaults.set(paymentsPerYear.value, forKey: paymentsPerYear.keyTag)
                paymentsPerYear.clearError()
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
        self.compoundsPerYear.value = userDefaults.string(forKey: compoundsPerYear.keyTag) ?? ""
        self.futureValue.value = userDefaults.string(forKey: futureValue.keyTag) ?? ""
        self.interest.value = userDefaults.string(forKey: interest.keyTag) ?? ""
        self.payment.value = userDefaults.string(forKey: payment.keyTag) ?? ""
        self.paymentsPerYear.value = userDefaults.string(forKey: paymentsPerYear.keyTag) ?? ""
        self.presentValue.value = userDefaults.string(forKey: presentValue.keyTag) ?? ""
    }
    
    func fetchDataRecords() {
        let request = NSFetchRequest<LoanData>(entityName: "LoanData")
        
        do {
            savedRecords = try dataContainer.viewContext.fetch(request)
            
        } catch let error {
            print("ERROR FETCH LoanData RECORDS ::: \(error)")
        }
    }
    
    func addDataRecord() {
        let newRecord = LoanData(context: dataContainer.viewContext)
        
        newRecord.compoundsPerYear = self.compoundsPerYear.formattedValue
        newRecord.futureValue = self.futureValue.formattedValue
        newRecord.interest = self.interest.formattedValue * 100
        newRecord.payment = self.payment.formattedValue
        newRecord.paymentsPerYear = self.paymentsPerYear.formattedValue
        newRecord.presentValue = self.presentValue.formattedValue
        
        saveDataRecord()
    }
    
    func saveDataRecord() {
        do {
            try dataContainer.viewContext.save()
            fetchDataRecords()
        } catch let error {
            print("ERROR SAVE LoanData RECORD ::: \(error)")
        }
        
    }
    
    func deleteRecord(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        let record = savedRecords[index]
        dataContainer.viewContext.delete(record)
        
        saveDataRecord()
    }
    
    func onSelectRecord(record: LoanData) {
        self.compoundsPerYear.value = record.compoundsPerYear.description
        self.futureValue.value = record.futureValue.description
        self.interest.value = record.interest.description
        self.payment.value = record.payment.description
        self.paymentsPerYear.value = record.paymentsPerYear.description
        self.presentValue.value = record.presentValue.description
        
        objectWillChange.send()
    }
    
    // calc button press handler
    func onPressCalc() {
        self.prepareEachValue(formComponent: paymentsPerYear)
        self.prepareEachValue(formComponent: futureValue)
        self.prepareEachValue(formComponent: presentValue)
        self.prepareEachValue(formComponent: interest)
        self.prepareEachValue(formComponent: payment)
        self.prepareEachValue(formComponent: compoundsPerYear)

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

        if(presentValue.isEmpty)
        {
            emptyFormComponents.append(presentValue)
            functionToPerform = calculatePresentValue
        }
        if(futureValue.isEmpty)
        {
            emptyFormComponents.append(futureValue)
            functionToPerform = calculateFutureValue
        }
        if(interest.isEmpty)
        {
            emptyFormComponents.append(interest)
            functionToPerform = calculateInterest
        }
        if(paymentsPerYear.isEmpty)
        {
            emptyFormComponents.append(paymentsPerYear)
            functionToPerform = calculateNoOfPayment
        }
        if(compoundsPerYear.isEmpty)
        {
            emptyFormComponents.append(compoundsPerYear)
        }
        if(payment.isEmpty)
        {
            emptyFormComponents.append(payment)
            functionToPerform = calculateFutureValue
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

            if functionToPerform != nil
            {
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
    func calculatePresentValue()
     {
         let a =  compoundsPerYear.formattedValue * paymentsPerYear.formattedValue
         let b =   1 + (interest.formattedValue / compoundsPerYear.formattedValue)
         presentValue.formattedValue = futureValue.formattedValue / pow(b,a)
         presentValue.value = commonFunctions.getFormattedDecimalString(value: presentValue.formattedValue)
     }

    func calculateInterest()
    {
        let a =  1 / (compoundsPerYear.formattedValue * paymentsPerYear.formattedValue)
        let b =  futureValue.formattedValue / presentValue.formattedValue
        interest.formattedValue = (pow(b,a) - 1) * compoundsPerYear.formattedValue * 100
        interest.value = commonFunctions.getFormattedDecimalString(value: interest.formattedValue)
    }

    func calculateNoOfPayment()
    {
        let a =  log(futureValue.formattedValue / presentValue.formattedValue)
        let b =   log(1 + (interest.formattedValue / compoundsPerYear.formattedValue)) * compoundsPerYear.formattedValue
        paymentsPerYear.formattedValue = a/b
        paymentsPerYear.value = commonFunctions.getFormattedDecimalString(value: paymentsPerYear.formattedValue)
    }

    func calculateFutureValue()
    {
        let a = compoundsPerYear.formattedValue * paymentsPerYear.formattedValue
        let b =  1 + (interest.formattedValue / compoundsPerYear.formattedValue)
        futureValue.formattedValue = pow(b,a) * presentValue.formattedValue

        payment.value = commonFunctions.getFormattedDecimalString(value: payment.formattedValue)
        futureValue.value = commonFunctions.getFormattedDecimalString(value: futureValue.formattedValue)
    }


    func calculateFutureValueofSeriesEnd(a: Double, b: Double) -> Double
    {
        let answer: Double = payment.formattedValue * ((pow(b,a) - 1)/(interest.formattedValue/compoundsPerYear.formattedValue))
        return answer
    }

    func calculateFutureValueofSeriesBegining(a: Double, b: Double) -> Double
    {
        let answer: Double = calculateFutureValueofSeriesEnd(a: a, b: b) * b
        return answer
    }

    func calculatePayment()
    {
        interest.formattedValue = interest.formattedValue / 100

        let a =  compoundsPerYear.formattedValue * paymentsPerYear.formattedValue
        let b =   1 + (interest.formattedValue / compoundsPerYear.formattedValue)
        let c = ((pow(b,a) - 1) / (interest.formattedValue / compoundsPerYear.formattedValue))

        let futureValueOfSeries: Double = futureValue.formattedValue - (pow(b,a) * presentValue.formattedValue)
        var finalAnswer: Double = 0

        finalAnswer = futureValueOfSeries / c
        
        payment.value = commonFunctions.getFormattedDecimalString(value: finalAnswer)
    }
    
    func clearValues() {
        self.compoundsPerYear.value = ""
        self.futureValue.value = ""
        self.interest.value = ""
        self.payment.value = ""
        self.paymentsPerYear.value = ""
        self.presentValue.value = ""
        
        objectWillChange.send()
    }
}
