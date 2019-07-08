//
//  Validation.swift
//  EstimationAutomation
//
//  Created by codeslinger on 6/19/19.
//  Copyright © 2019 SpokaneAutomationCompany. All rights reserved.
//

import Foundation



//validatedFirstname, validatedLastname, validatedEmail, validatedPhone, validatedAddress, validatedState, validatedZip
class Validation {
    static func isFirstNameValid(_ value: String) -> Bool {
        if value == ""{
            return false
        }
        return true
    }
    static func isLastNameValid(_ value: String) -> Bool {
        if value == ""{
            return false
        }
        return true
    }
    static func isPhoneValid(_ value: String) -> Bool {
        do {
            if try NSRegularExpression(pattern: "^\\D?(\\d{3})\\D?\\D?(\\d{3})\\D?(\\d{4})$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                return false
            }
        }
        catch {
            return false
        }
        return true
    }
    static func isStateValid(_ value: String) -> Bool {
        do {
            if try NSRegularExpression(pattern: "^((AL)|(AK)|(AS)|(AZ)|(AR)|(CA)|(CO)|(CT)|(DE)|(DC)|(FM)|(FL)|(GA)|(GU)|(HI)|(ID)|(IL)|(IN)|(IA)|(KS)|(KY)|(LA)|(ME)|(MH)|(MD)|(MA)|(MI)|(MN)|(MS)|(MO)|(MT)|(NE)|(NV)|(NH)|(NJ)|(NM)|(NY)|(NC)|(ND)|(MP)|(OH)|(OK)|(OR)|(PW)|(PA)|(PR)|(RI)|(SC)|(SD)|(TN)|(TX)|(UT)|(VT)|(VI)|(VA)|(WA)|(WV)|(WI)|(WY))$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                return false
            }
        }
        catch {
            return false
        }
        return true
    }
    static func isZipValid(_ value: String) -> Bool {
        do {
            if try NSRegularExpression(pattern: "^\\d{5}$|^\\d{5}-\\d{4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                return false
            }
        }
        catch {
            return false
        }
        return true
    }
    static func isEmailValid(_ value: String) -> Bool {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                return false
            }
        } catch {
            return false
        }
        return true
    }
    static func isDouble(_ value: String) -> Bool {
        do {
            if try NSRegularExpression(pattern: "^\\d*\\.?\\d*$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                return false
            }
        } catch {
            return false
        }
        return true
    }
}
