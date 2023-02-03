//
//  String.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    //    func substring(from: Int) -> String {
    //        return self.substring(from: from, to: nil)
    //    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
    
    func convertTo12Hour() -> String {
        if let time = Int(self.split(separator: ":")[0]), time > 12 {
            if time == 24 {
                return "00:00 AM"
            } else {
                return String(format: "%02d", time - 12) + ":" + self.split(separator: ":")[1] + " PM"
            }
        } else {
            return self + " AM"
        }
    }
    
    func nsRange(fromRange range: Range<Index>) -> NSRange {
        let from = range.lowerBound
        let to = range.upperBound
        
        let location = self.distance(from: startIndex, to: from)
        let length = self.distance(from: from, to: to)
        
        return NSRange(location: location, length: length)
    }
    
    var validatePhone: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var phoneNumber: String {
        if self[0] == "0" {
            let n = self.count
            return self[1..<n]
        } else {
            return self
        }
    }
    
    var validateEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var validatePassword: Bool {
        if self.count >= 6 {
            return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
        } else {
            return false
        }
    }
    
    var validateName: Bool {
        if !self.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    var dictionary: NSDictionary? {
        if !self.isEmpty {
            if let data = self.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
        } else {
            return nil
        }
        
    }
    
    func formattedPhoneNumber() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX-XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func greaterThanCurrentTime() -> Bool {
        let hour = Int(self.split(separator: ":")[0])!
        let minute = Int(self.split(separator: ":")[1])!
        
        if hour == Date().hour {
            return minute >= Date().minute
        } else if hour > Date().hour {
            return true
        } else {
            return false
        }
    }
    
    func getFormatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: self)
        let customDateFormatter = DateFormatter()
        
        let dateName = customDateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date!) - 1]
        
        let formater = DateFormatter()
        formater.locale = Locale.current
        formater.setLocalizedDateFormatFromTemplate("MMM dd, yyyy")
        
        return dateName + ", " + formater.string(from: date!)
    }
    
    func html() -> NSMutableAttributedString {
        let data = self.data(using: String.Encoding.unicode)!
        let attrStr = try? NSAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        // let newFont = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize:  UIFont.systemFontSize))
        
        let newFont = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 17))
        
        let mattrStr = NSMutableAttributedString(attributedString: attrStr!)
        mattrStr.beginEditing()
        mattrStr.enumerateAttribute(.font, in: NSRange(location: 0, length: mattrStr.length), options: .longestEffectiveRangeNotRequired) { (value, range, _) in
            if let oFont = value as? UIFont, let newFontDescriptor = oFont.fontDescriptor.withFamily(newFont.familyName).withSymbolicTraits(oFont.fontDescriptor.symbolicTraits) {
                let nFont = UIFont(descriptor: newFontDescriptor, size: newFont.pointSize)
                mattrStr.removeAttribute(.font, range: range)
                mattrStr.addAttribute(.font, value: nFont, range: range)
            }
        }
        mattrStr.endEditing()
        return mattrStr
    }
    
    func getMessageDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "h:mm a"
        
        let date: Date? = dateFormatterGet.date(from: self)
        return dateFormatterPrint.string(from: date!)
    }
}
