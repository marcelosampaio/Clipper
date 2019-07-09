//
//  String+Utils.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 09/07/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    // MARK: - Date Validation
    func isValidDate() -> Bool? {
        let date = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if date.isEmpty{
            return false
        }
        if date.range(of:" ") != nil {
            return false
        }
        
        let components = self.split(separator: "/")
        // 3 components at leas (day, month and year)
        if components.count < 3 {
            return false
        }
        
        let day : String = String(components[0])
        let month : String = String(components[1])
        let year : String = String(components[2])
        let entryDate : String = year + month + day
        
        // check components length
        if day.count < 2 {
            return false
        }
        
        if let dayInt : Int = Int(day) {
            if dayInt < 1 {
                return false
            }
        }else{
            return false
        }
        
        // month
        if month.count < 2 {
            return false
        }
        if let monthInt : Int = Int(month) {
            if monthInt < 1 {
                return false
            }
        }else{
            return false
        }
        
        // year
        if year.count < 4 {
            return false
        }
        if let yearInt : Int = Int(year) {
            if yearInt < 1 {
                return false
            }
        }else{
            return false
        }
        
        
        
        
        // check month's last day
        if lastDay(month: month, year: year).isEmpty {
            return false
        }
        // day cannot be greatear than last day of the month
        let lastDayOfTheMonth : Int = Int(lastDay(month: month, year: year))!
        if Int(day)! > lastDayOfTheMonth {
            return false
        }
        
        // check all the date
        if !isValidYear(entryDate: entryDate) {
            return false
        }
        
        return true
    }
    
    private func lastDay(month: String, year: String) -> String {
        var day = [String]()
        day.append("")      // filler (0)
        day.append("31")    // January (1)
        day.append("28")    // February (2)
        day.append("31")    // March (3)
        day.append("30")    // April (4)
        day.append("31")    // May (5)
        day.append("30")    // June (6)
        day.append("31")    // July (7)
        day.append("31")    // August (8)
        day.append("30")    // September (9)
        day.append("31")    // October (10)
        day.append("30")    // November (11)
        day.append("31")    // December (12)
        
        if !validMonth(month) {
            return ""
        }
        
        if month == "02" {
            // TO DO:  28 or 29 ???
            let rest = Int(year)! % 4
            if rest == 0 {
                return "29"
            }else{
                return day[2]
            }
        }else{
            if let index = Int(month) {
                return day[index]
            }
        }
        return ""
    }
    
    private func validMonth(_ month: String) -> Bool {
        if month == "01" || month == "02" || month == "03" || month == "04" || month == "05" || month == "06" || month == "07" || month == "08" || month == "09" || month == "10" || month == "11" || month == "12" {
            return true
        }
        
        return false
    }
    
    private func isValidYear(entryDate: String) -> Bool {
        // current date
        let calendar = Calendar.current
        let currentDate = calendar.dateComponents([.day, .month, .year], from: Date())
        let currentDateString : String = String(format: "%04d", currentDate.year!) + String(format: "%02d", currentDate.month!) + String(format: "%02d", currentDate.day!)
        
        if entryDate > currentDateString {
            return false
        }
        
        
        let year = entryDate.prefix(4)
        //        if (Int(year)! < 1900) || (currentDate.year! - Int(year)! <= 15) {
        if Int(year)! < 1900 {
            return false
        }
        
        return true
    }
    
    
    // MARK: - Email Validation
    func isValidEmail() -> Bool? {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty {
            return false
        }
        
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1,
            allMatches.first?.url?.absoluteString.contains("mailto:") == true
        {
            return true
        }
        return false
    }
    
    
    // MARK: - Password Validation
    func isValidPassword() -> Bool? {
        let password = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.isEmpty{
            return false
        }
        if password.range(of:" ") != nil {
            return false
        }
        
        return true
    }
    
    // MARK: - Name Validation
    func isValidName() -> Bool? {
        let name = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty{
            return false
        }
        
        return true
    }
    
    // MARK: - Cpf
    func isValidCpf() -> Bool {
        let cpf = self.trimmingCharacters(in: .whitespacesAndNewlines)
        var cpfClean = cpf.replacingOccurrences(of: ".", with: "")
        cpfClean = cpfClean.replacingOccurrences(of: "-", with: "")
        
        if cpfClean.isEmpty || isFakeCpf(cpfClean){
            return false
        }
        
        var i = 0
        var firstSum = 0
        var secondSum = 0
        var firstDigit = 0
        var secondDigit = 0
        var firstDigitCheck = 0
        var secondDigitCheck = 0
        
        for character in cpfClean {
            let value = Int(character.description) ?? 0
            
            // step 1
            if i <= 8 {
                let sumarizer = (value * (10 - i))
                firstSum += sumarizer
            }
            // step2
            if i <= 9 {
                let sumarizer = (value * (11 - i))
                secondSum += sumarizer
            }
            //
            if i == 9 {
                firstDigitCheck = value
            }else if i == 10 {
                secondDigitCheck = value
            }
            // digit control
            i = i + 1
        }
        
        // with firstSum I'll get firstDigit
        if (firstSum % 11 < 2) {
            firstDigit = 0;
        }
        else {
            firstDigit = 11 - (firstSum % 11);
        }
        
        // with secondSum I'll get secondDigit
        if (secondSum % 11 < 2) {
            secondDigit = 0;
        }
        else {
            secondDigit = 11 - (secondSum % 11)
        }
        
        // validate digits
        if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck)) {
            return true;
        }
        
        
        return false
    }
    
    // Prevent valid digits to accept as true
    private func isFakeCpf(_ cpf: String) -> Bool {
        if (cpf == "00000000000" || cpf == "11111111111" || cpf == "22222222222" || cpf == "33333333333" || cpf == "44444444444" || cpf == "55555555555" || cpf == "66666666666" || cpf == "77777777777" || cpf == "88888888888" || cpf == "99999999999") {
            return true
        }
        return false
    }
    
    // MARK: - Cnpj
    func isValidCnpj() -> Bool {
        let cnpj = self.trimmingCharacters(in: .whitespacesAndNewlines)
        var cnpjClean = cnpj.replacingOccurrences(of: ".", with: "")
        cnpjClean = cnpjClean.replacingOccurrences(of: "-", with: "")
        cnpjClean = cnpjClean.replacingOccurrences(of: "/", with: "")
        
        if cnpjClean.isEmpty || cnpjClean == "00000000000000" {
            return false
        }
        
        var i = 0
        var firstSum = 0
        var secondSum = 0
        var firstDigit = 0
        var secondDigit = 0
        var firstDigitCheck = 0
        var secondDigitCheck = 0
        
        let firstMultipliers : [Int] = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        let secondMultipliers : [Int] = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        
        for character in cnpjClean {
            
            let value = Int(character.description) ?? 0
            
            // step 1
            if i <= 11 {
                let sumarizer = (value * firstMultipliers[i])
                firstSum += sumarizer
            }
            // step2
            if i <= 12 {
                let sumarizer = (value * secondMultipliers[i])
                secondSum += sumarizer
            }
            //
            if i == 12 {
                firstDigitCheck = value
            }else if i == 13 {
                secondDigitCheck = value
            }
            // digit control
            i = i + 1
        }
        // with firstSum I'll get firstDigit
        if (firstSum % 11 < 2) {
            firstDigit = 0;
        }
        else {
            firstDigit = 11 - (firstSum % 11);
        }
        
        // with secondSum I'll get secondDigit
        if (secondSum % 11 < 2) {
            secondDigit = 0;
        }
        else {
            secondDigit = 11 - (secondSum % 11)
        }
        
        // validate digits
        if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck)) {
            return true;
        }
        
        return false
    }
    
    
    // MARK: - Base64
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    // MARK: - Date String
    func stringDate() -> String? {
        let timestamp = self
        let timestampComponents = timestamp.split(separator: "T")
        let dateComponents = timestampComponents[0].split(separator: "-")
        return dateComponents[2] + "/" + dateComponents[1] + "/" + dateComponents[0]
        
    }
    func stringDateTime() -> String? {
        let timestamp = self
        let timestampComponents = timestamp.split(separator: "T")
        let dateComponents = timestampComponents[0].split(separator: "-")
        let timeComponents = timestampComponents[1].split(separator: ":")
        
        let dateString = dateComponents[2] + "/" + dateComponents[1] + "/" + dateComponents[0]
        let timeString = timeComponents[0] + ":" + timeComponents[1] + "h"
        
        
        return dateString + " " + timeString
        
    }
    func stringParam() -> String? {
        let input = self
        let components = input.split(separator: "/")
        return components[2] + "-" + components[1] + "-" + components[0]
    }
    
    // MARK: - CPF Format
    func cpfFormat() -> String {
        var result = String()
        var i = 1
        var editChar = String()
        for char in self {
            if i == 3 || i == 6 {
                editChar = "."
            }
            if i == 9 {
                editChar = "-"
            }
            result = result + "\(char)" + editChar
            i = i + 1
            editChar = String()
        }
        
        return result
    }
    
    // MARK: - CNPJ Format
    func cnpjFormat() -> String {
        var result = String()
        var i = 1
        var editChar = String()
        for char in self {
            if i == 2 || i == 5 {
                editChar = "."
            }
            if i == 8 {
                editChar = "/"
            }
            if i == 12 {
                editChar = "-"
            }
            result = result + "\(char)" + editChar
            i = i + 1
            editChar = String()
        }
        
        return result
    }
    
    
    
    // MARK: - Telephone Format (land line)
    func telephoneFormat() -> String {
        var result = String()
        var i = 1
        var editChar = String()
        let input = "(" + self
        for char in input {
            if i == 3 {
                editChar = ") "
            }
            if i == 7 {
                editChar = "-"
            }
            result = result + "\(char)" + editChar
            i = i + 1
            editChar = String()
        }
        
        return result
    }
    
    // MARK: - Cellphone Format (mobile)
    func cellphoneFormat() -> String {
        var result = String()
        var i = 1
        var editChar = String()
        let input = "(" + self
        for char in input {
            if i == 3 {
                editChar = ") "
            }
            if i == 8 {
                editChar = "-"
            }
            result = result + "\(char)" + editChar
            i = i + 1
            editChar = String()
        }
        
        return result
    }
    
    // MARK: - Postal Code Format
    func postalCodeFormat() -> String {
        var result = String()
        var i = 1
        var editChar = String()
        for char in self {
            if i == 2 {
                editChar = "."
            }
            if i == 5 {
                editChar = "-"
            }
            result = result + "\(char)" + editChar
            i = i + 1
            editChar = String()
        }
        
        return result
    }
    
    // MARK: - Age
    func age() -> String {
        var ageResult = ""
        
        // current date
        let calendar = Calendar.current
        let currentDate = calendar.dateComponents([.day, .month, .year], from: Date())
        let currentYear : Int = currentDate.year!
        let currentMonthDay : String = String(format: "%02d", currentDate.month!) + String(format: "%02d", currentDate.day!)
        
        // birth date
        let timestamp = self
        let timestampComponents = timestamp.split(separator: "T")
        let dateComponents = timestampComponents[0].split(separator: "-")
        let birthYear : Int = Int(dateComponents[0])!
        let birthMonthDay : String = String(dateComponents[1]) + String(dateComponents[2])
        
        if currentYear > birthYear {
            var age = currentYear - birthYear
            if Int(currentMonthDay)! < Int(birthMonthDay)! {
                age = age - 1
            }
            ageResult = String(age) + " anos"
        }
        
        return ageResult
    }
    
    // MARK: - Current Date Minus N Days
    func currentDate() -> String {
        // current date
        let calendar = Calendar.current
        let currentDate = calendar.dateComponents([.day, .month, .year], from: Date())
        
        let result : String = "\(String(format: "%02d", currentDate.day!))/\(String(format: "%02d", currentDate.month!))/\(String(currentDate.year!))"
        
        return result
    }
}

