//
//  SavingsViewModel.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI
import CoreData

class SavingsViewModel: ObservableObject {
    
    static let shared = SavingsViewModel()
    
    private let userDefaults = UserDefaults.standard;
    private let commonFunctions = CommonFunctions()
    private let dataContainer: NSPersistentContainer
    
    @Published var savedRecords: [SavingsData] = []
    
    @Published var futureValue = FormComponentModel(value: "", keyTag: "futureValue") {
            didSet {
                userDefaults.set(futureValue.value, forKey: futureValue.keyTag)
                futureValue.clearError()
            }
        }
    @Published var compoundsPerYear = FormComponentModel(value: "", keyTag: "compoundsPerYear") {
            didSet {
                userDefaults.set(compoundsPerYear.value, forKey: compoundsPerYear.keyTag)
                compoundsPerYear.clearError()
            }
        }
    
    @Published var interest = FormComponentModel(value: "", keyTag: "interest") {
            didSet {
                userDefaults.set(interest.value, forKey: interest.keyTag)
                interest.clearError()
            }
        }
    @Published var payment = FormComponentModel(value: "", keyTag: "payment") {
            didSet {
                userDefaults.set(payment.value, forKey: payment.keyTag)
                payment.clearError()
            }
        }
    @Published var paymentMadeAtEnd = false {
            didSet {
                userDefaults.set(paymentMadeAtEnd, forKey:"paymentMadeAtEnd")
            }
        }
    @Published var paymentsPerYear = FormComponentModel(value: "", keyTag: "paymentsPerYear") {
            didSet {
                userDefaults.set(paymentsPerYear.value, forKey: paymentsPerYear.keyTag)
                paymentsPerYear.clearError()
            }
        }
    @Published var presentValue = FormComponentModel(value: "", keyTag: "presentValue") {
            didSet {
                userDefaults.set(presentValue.value, forKey: presentValue.keyTag)
                presentValue.clearError()
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
        
        if userDefaults.object(forKey: "paymentMadeAtEnd") != nil
        {
            self.paymentMadeAtEnd = userDefaults.bool(forKey: "paymentMadeAtEnd")
        } else {
            self.paymentMadeAtEnd = false
        }
    }
    
    func fetchDataRecords() {
        let request = NSFetchRequest<SavingsData>(entityName: "SavingsData")
        
        do {
            savedRecords = try dataContainer.viewContext.fetch(request)
            
        } catch let error {
            print("ERROR FETCH SavingsData RECORDS ::: \(error)")
        }
    }
    
    func addDataRecord() {
        let newRecord = SavingsData(context: dataContainer.viewContext)
        
        newRecord.compoundsPerYear = self.compoundsPerYear.formattedValue
        newRecord.futureValue = self.futureValue.formattedValue
        newRecord.interest = self.interest.formattedValue * 100
        newRecord.payment = self.payment.formattedValue
        newRecord.paymentsPerYear = self.paymentsPerYear.formattedValue
        newRecord.presentValue = self.presentValue.formattedValue
        newRecord.paymentMadeAtEnd = self.paymentMadeAtEnd
        
        saveDataRecord()
    }
    
    func saveDataRecord() {
        do {
            try dataContainer.viewContext.save()
            fetchDataRecords()
        } catch let error {
            print("ERROR SAVE SavingsData RECORD ::: \(error)")
        }
        
    }
    
    func deleteRecord(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        let record = savedRecords[index]
        dataContainer.viewContext.delete(record)
        
        saveDataRecord()
    }
    
    func onSelectRecord(record: SavingsData) {
        self.compoundsPerYear.value = record.compoundsPerYear.description
        self.futureValue.value = record.futureValue.description
        self.interest.value = record.interest.description
        self.payment.value = record.payment.description
        self.paymentMadeAtEnd = record.paymentMadeAtEnd
        self.paymentsPerYear.value = record.paymentsPerYear.description
        self.presentValue.value = record.presentValue.description
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
            if(futureValue.formattedValue == 0)
            {
               calculateFutureValue()
            }
            else
            {
                if functionToPerform != nil
                {
                    // we need the payment value only when calculating future value, therefore clear payment value
                    payment.value = "0"
                    prepareEachValue(formComponent: payment)

                    functionToPerform!()
                }
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

        if(payment.formattedValue > 0)
        {
            if(paymentMadeAtEnd)
            {
                futureValue.formattedValue += calculateFutureValueofSeriesEnd(a: a, b: b)
            }
            else
            {
                futureValue.formattedValue += calculateFutureValueofSeriesBegining(a: a, b: b)
            }
        }

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

        if(paymentMadeAtEnd)
        {
            finalAnswer = futureValueOfSeries / c
        }
        else
        {
            finalAnswer = futureValueOfSeries / (c * b)
        }
        payment.value = commonFunctions.getFormattedDecimalString(value: finalAnswer)
    }
    
    func clearValues() {
        self.compoundsPerYear.value = ""
        self.futureValue.value = ""
        self.interest.value = ""
        self.payment.value = ""
        self.paymentMadeAtEnd = false
        self.paymentsPerYear.value = ""
        self.presentValue.value = ""
        
        objectWillChange.send()
    }
}
