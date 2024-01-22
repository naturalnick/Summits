//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Nick on 9/29/23.
//

import SwiftUI

enum AlertError: LocalizedError {
    case invalidJSON, fileNotFound, formDateInvalid
    
    var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "Error"
        case .fileNotFound:
            return "Error"
        case .formDateInvalid:
            return "Date Invalid"
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .invalidJSON:
            return "Something went wrong while displaying the data."
        case .fileNotFound:
            return "Problem retrieving the data."
        case .formDateInvalid:
            return "Please select a date in the past."
        }
    }
    
}
