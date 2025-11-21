//
//  Constants.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

import Foundation

struct Constants {
    static let baseURL = "http://localhost:4567"
    struct Endpoints {
        // Authentication
        static let mobileLogin = "/auth/mobile-login"
        
        // Profile
        static let createFarmer = "/profile/create-farmer"
        static let createWorker = "/profile/create-worker"
        static let profileImages = "/profile/images" // + /:userId
        static let updateProfile = "/profile/update"
        
        // OCR
        static let ocr = "/ocr"
        
        // Posts
        static let postsHome = "/posts/home"
        static let posts = "/posts"
        static let postsSearch = "/posts/search"
        static let jobPosts = "/posts/job-posts"
        static let workSeekingPosts = "/posts/work-seeking-posts"
        static let postsMatch = "/posts/match"
        
        // Reviews (nested under posts)
        // /posts/:id/reviews
        
        // Favorites
        static let favorites = "/favorites"
        
        // Ads
        static let ads = "/ads"
    }
    
    // MARK: - Headers
    static let contentTypeJSON = "application/json"
    static let acceptType = "application/json"
}
