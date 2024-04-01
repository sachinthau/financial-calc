//
//  CommonFunctions.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import Foundation

class CommonFunctions
{
    func getFormattedDecimalDouble(value: Double) -> Double
    {
        return (value * 100).rounded() / 100
    }
    
    func getFormattedDecimalString(value: Double) -> String
    {
        return String(format: "%.02f", value)
    }
}

