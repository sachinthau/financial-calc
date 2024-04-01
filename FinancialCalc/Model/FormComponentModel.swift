//
//  TextFieldModel.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

class FormComponentModel
{
    var value: String
    var formattedValue: Double = 0
    var keyTag: String
    var isEmpty: Bool = true
    var isError: Bool = false
    
    init(value: String, keyTag: String) {
        self.value = value
        self.keyTag = keyTag
    }
    
    func setError() {
        self.isError = true
    }
    
    func clearError() {
        self.isError = false
    }
}
