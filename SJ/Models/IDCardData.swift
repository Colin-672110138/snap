//
//  IDCardData.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Models/IDCardData.swift

import Foundation

struct IDCardData: Codable {
    var idCardNumber: String = ""
    var title: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var dateOfBirth: String = "" // รูปแบบ DD/MM/YYYY
    var address: String = ""
    var issueDate: String = ""
    var expiryDate: String = ""
}
