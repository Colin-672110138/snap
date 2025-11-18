//
//  JobSeekerProfile.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Models/JobSeekerProfile.swift

import Foundation

struct JobSeekerProfile: Codable {
    var interestedPosition: String = "" // ตำแหน่งที่สนใจ (เช่น เก็บ/คัดแยก/ขนส่ง)
    var hasExperience: Bool = false
    var experienceDescription: String = "" // อธิบายประสบการณ์
}
