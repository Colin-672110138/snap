//
//  APIResponse.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

import Foundation

// MARK: - Generic API Response
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let error: String?
}

// MARK: - Error Response
struct APIErrorResponse: Codable {
    let statusCode: Int?
    let message: String
    let error: String?
}

// MARK: - Login Response
struct LoginResponse: Codable {
    let token: String
    let profile: LineProfileData
    let dbProfile: DBProfile?
    
    struct LineProfileData: Codable {
        let userId: String
        let displayName: String
        let pictureUrl: String?
        let statusMessage: String?
    }
    
    struct DBProfile: Codable {
        let role: String?
        let idCard: String?
        let firstName: String?
        let lastName: String?
        let dateOfBirth: String?
        let addressFromIdCard: String?
        let address: String?
        let phone: String?
        let profile: ProfileDetails?
        
        struct ProfileDetails: Codable {
            let id: Int?
            let userId: String?
            let farmCount: Int?
            let workCount: Int?
            let squareMeter: Int?
            let NOLT: Int?
        }
    }
}

// MARK: - Profile Response
struct ProfileResponse: Codable {
    let id: Int?
    let userId: String
    let idCard: String
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let addressFromIdCard: String
    let address: String
    let phone: String
    let role: String?
    
    // Farmer specific
    let farmCount: Int?
    let workCount: Int?
    let squareMeter: Int?
    let NOLT: Int?
    
    // Worker specific
    let jobInterest: String?
    let previousExperience: String?
    let description: String?
    
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - Image Response
struct ImageResponse: Codable {
    let id: Int
    let userId: String?
    let imageType: String?
    let imageUrl: String
    let createdAt: String?
}

// MARK: - Post Response (Job Post - สำหรับ Farmer โพสต์จ้างงาน)
struct JobPostResponse: Codable {
    let id: Int
    let userId: String
    let title: String
    let workAmount: Int?
    let startDate: String?
    let contactPhone: String
    let province: String
    let dailyWage: Int
    let benefits: String?
    let averageRating: Double?
    let images: [ImageResponse]?
    let user: UserInfo?
    let reviews: [ReviewResponse]?
    let createdAt: String?
    let updatedAt: String?
    
    struct UserInfo: Codable {
        let id: String
        let firstName: String?
        let lastName: String?
        let phone: String?
    }
}

// MARK: - Work Seeking Post Response (สำหรับ Worker โพสต์รับงาน)
struct WorkSeekingPostResponse: Codable {
    let id: Int
    let userId: String
    let title: String
    let numberOfWorkers: Int
    let availableStartDate: String?
    let contactPhone: String
    let province: String
    let dailyWage: Int
    let averageRating: Double?
    let images: [ImageResponse]?
    let user: UserInfo?
    let reviews: [ReviewResponse]?
    let createdAt: String?
    let updatedAt: String?
    
    struct UserInfo: Codable {
        let id: String
        let firstName: String?
        let lastName: String?
        let phone: String?
    }
}

// MARK: - Review Response
struct ReviewResponse: Codable {
    let id: Int
    let reviewerId: String
    let postId: Int
    let postType: String?
    let rating: Int
    let comment: String?
    let reviewer: ReviewerInfo?
    let createdAt: String?
    let updatedAt: String?
    
    struct ReviewerInfo: Codable {
        let id: String
        let firstName: String?
        let lastName: String?
    }
}

// MARK: - Match Response
struct MatchResponse: Codable {
    let requiredWorkers: Int?
    let matchedPosts: [WorkSeekingPostResponse]
    let totalMatches: Int
}

// MARK: - Favorite Response
struct FavoriteResponse: Codable {
    let id: Int
    let userId: String?
    let postId: Int
    let postType: String
    let post: PostDetail?
    let createdAt: String?
    let updatedAt: String?
    
    struct PostDetail: Codable {
        let id: Int
        let userId: String
        let title: String?
        let workAmount: Int?
        let numberOfWorkers: Int?
        let startDate: String?
        let availableStartDate: String?
        let contactPhone: String?
        let province: String?
        let dailyWage: Int?
        let benefits: String?
        let images: [ImageResponse]?
        let user: UserInfo?
        
        struct UserInfo: Codable {
            let id: String
            let firstName: String?
            let lastName: String?
            let phone: String?
        }
    }
}

// MARK: - Ad Response
struct AdResponse: Codable {
    let id: Int
    let imageUrl: String
    let type: String
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - OCR Response
struct OCRResponse: Codable {
    let filename: String
    let mimetype: String
    let size: Int
    let ocrResult: OCRResult
    
    struct OCRResult: Codable {
        let idCard: String?
        let firstName: String?
        let lastName: String?
        let dateOfBirth: String?
        let address: String?
    }
}

// MARK: - Pagination Response
struct PaginationResponse<T: Codable>: Codable {
    let posts: [T]
    let pagination: PaginationInfo
    
    struct PaginationInfo: Codable {
        let currentPage: Int
        let totalPages: Int
        let totalItems: Int
        let itemsPerPage: Int
    }
}

// MARK: - Helper Extensions
extension LoginResponse.DBProfile {
    func toUserProfile() -> UserProfile {
        var profile = UserProfile()
        profile.lineID = self.profile?.userId ?? ""
        profile.name = "\(self.firstName ?? "") \(self.lastName ?? "")"
        
        // Map role
        if let role = self.role {
            if role == "farmer" {
                profile.role = .employer
            } else if role == "worker" {
                profile.role = .jobSeeker
            }
        }
        
        profile.idCardNumber = self.idCard ?? ""
        profile.currentAddress = self.address ?? ""
        profile.phoneNumber = self.phone ?? ""
        
        // Farmer specific
        if let farmCount = self.profile?.farmCount {
            profile.farmArea = "\(farmCount)"
        }
        if let nolt = self.profile?.NOLT {
            profile.longanTrees = "\(nolt)"
        }
        
        return profile
    }
}
