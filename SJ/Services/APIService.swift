//
//  APIService.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

import Foundation
import Combine
import UIKit
import LineSDK

// MARK: - API Service
class APIService {
    static let shared = APIService()
    
    private let baseURL: String
    private let session: URLSession
    
    // Token storage (ควรใช้ Keychain ใน production)
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    private init() {
        self.baseURL = Constants.baseURL
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Helper: Create Request
    private func createRequest(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) -> URLRequest? {
        guard let url = URL(string: baseURL + endpoint) else {
            print("❌ Invalid URL: \(baseURL + endpoint)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Default headers
        request.setValue(Constants.contentTypeJSON, forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.acceptType, forHTTPHeaderField: "Accept")
        
        // Add authorization token if available
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body for POST/PUT/PATCH
        if let body = body, method != .GET {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                print("❌ Error encoding body: \(error)")
                return nil
            }
        }
        
        return request
    }
    
    // MARK: - Helper: Perform Request
    private func performRequest<T: Codable>(
        request: URLRequest,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        print("🌐 API Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        
        session.dataTask(with: request) { data, response, error in
            // Handle network error
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }
            
            // Handle HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            print("📡 Response Status: \(httpResponse.statusCode)")
            
            // Handle HTTP errors
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = self.parseError(from: data) ?? "HTTP \(httpResponse.statusCode)"
                print("❌ HTTP Error: \(errorMessage)")
                DispatchQueue.main.async {
                    completion(.failure(.httpError(httpResponse.statusCode, errorMessage)))
                }
                return
            }
            
            // Parse response data
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                // Print response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Response data: \(jsonString)")
                }
                
                // Try to parse as APIResponse<T>
                if let apiResponse = try? JSONDecoder().decode(APIResponse<T>.self, from: data) {
                    if apiResponse.success, let responseData = apiResponse.data {
                        DispatchQueue.main.async {
                            completion(.success(responseData))
                        }
                    } else {
                        let errorMsg = apiResponse.error ?? apiResponse.message ?? "Unknown error"
                        DispatchQueue.main.async {
                            completion(.failure(.apiError(errorMsg)))
                        }
                    }
                } else {
                    // Try to parse directly as T
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                }
            } catch {
                print("❌ Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
            }
        }.resume()
    }
    
    // MARK: - Helper: Parse Error
    private func parseError(from data: Data?) -> String? {
        guard let data = data else { return nil }
        if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
            return errorResponse.message
        }
        return nil
    }
    
    // MARK: - Authentication
    
    /// Login with LINE access token
    func mobileLogin(accessToken: String, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "accessToken": accessToken
        ]
        
        guard let request = createRequest(endpoint: Constants.Endpoints.mobileLogin, method: .POST, body: body) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        performRequest(request: request, responseType: LoginResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                // Save JWT token
                self?.accessToken = response.token
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Profile
    
    /// Create Farmer Profile
    func createFarmerProfile(
        userId: String,
        idCard: String,
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        addressFromIdCard: String,
        address: String,
        phone: String,
        farmCount: Int,
        workCount: Int,
        squareMeter: Int,
        NOLT: Int,
        idcardFront: UIImage?,
        idcardBack: UIImage?,
        idcardWithPerson: UIImage?,
        completion: @escaping (Result<ProfileResponse, APIError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(Constants.Endpoints.createFarmer)?userId=\(userId)") else {
            completion(.failure(.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add form fields
        let fields: [String: String] = [
            "idCard": idCard,
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": dateOfBirth,
            "addressFromIdCard": addressFromIdCard,
            "address": address,
            "phone": phone,
            "farmCount": "\(farmCount)",
            "workCount": "\(workCount)",
            "squareMeter": "\(squareMeter)",
            "NOLT": "\(NOLT)"
        ]
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add images if provided
        if let frontImage = idcardFront, let frontData = frontImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"idcardFront\"; filename=\"front.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(frontData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        if let backImage = idcardBack, let backData = backImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"idcardBack\"; filename=\"back.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(backData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        if let personImage = idcardWithPerson, let personData = personImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"idcardWithPerson\"; filename=\"person.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(personData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        performRequest(request: request, responseType: ProfileResponse.self, completion: completion)
    }
    
    /// Create Worker Profile
    func createWorkerProfile(
        userId: String,
        idCard: String,
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        addressFromIdCard: String,
        address: String,
        phone: String,
        jobInterest: String,
        previousExperience: String,
        description: String,
        idcardFront: UIImage?,
        idcardBack: UIImage?,
        idcardWithPerson: UIImage?,
        completion: @escaping (Result<ProfileResponse, APIError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(Constants.Endpoints.createWorker)?userId=\(userId)") else {
            completion(.failure(.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add form fields
        let fields: [String: String] = [
            "idCard": idCard,
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": dateOfBirth,
            "addressFromIdCard": addressFromIdCard,
            "address": address,
            "phone": phone,
            "jobInterest": jobInterest,
            "previousExperience": previousExperience,
            "description": description
        ]
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add images if provided
        if let frontImage = idcardFront, let frontData = frontImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"idcardFront\"; filename=\"front.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(frontData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        if let backImage = idcardBack, let backData = backImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"idcardBack\"; filename=\"back.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(backData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        if let personImage = idcardWithPerson, let personData = personImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"idcardWithPerson\"; filename=\"person.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(personData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        performRequest(request: request, responseType: ProfileResponse.self, completion: completion)
    }
    
    /// Update Profile Address
    func updateProfileAddress(userId: String, address: String, completion: @escaping (Result<[String: Any], APIError>) -> Void) {
        let body: [String: Any] = [
            "address": address
        ]
        
        guard let request = createRequest(endpoint: "\(Constants.Endpoints.updateProfile)?userId=\(userId)", method: .POST, body: body) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError("Failed to decode response")))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(json))
            }
        }.resume()
    }
    
    /// Get Profile Images
    func getProfileImages(userId: String, completion: @escaping (Result<[ImageResponse], APIError>) -> Void) {
        guard let request = createRequest(endpoint: "\(Constants.Endpoints.profileImages)/\(userId)", method: .GET) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        performRequest(request: request, responseType: [ImageResponse].self, completion: completion)
    }
    
    // MARK: - OCR
    
    /// Process ID card with OCR
    func processOCR(image: UIImage, completion: @escaping (Result<OCRResponse, APIError>) -> Void) {
        guard let url = URL(string: baseURL + Constants.Endpoints.ocr) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"idcard.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        performRequest(request: request, responseType: OCRResponse.self, completion: completion)
    }
    
    // MARK: - Posts
    
    /// Get home posts
    func getHomePosts(type: String, completion: @escaping (Result<APIResponse<[String: Any]>, APIError>) -> Void) {
        guard let request = createRequest(endpoint: "\(Constants.Endpoints.postsHome)?type=\(type)", method: .GET) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(APIResponse<[String: Any]>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
            }
        }.resume()
    }
    
    /// Get all posts with pagination
    func getPosts(type: String, page: Int = 1, completion: @escaping (Result<[String: Any], APIError>) -> Void) {
        guard let request = createRequest(endpoint: "\(Constants.Endpoints.posts)?type=\(type)&page=\(page)", method: .GET) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError("Failed to decode")))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(json))
            }
        }.resume()
    }
    
    /// Search posts
    func searchPosts(type: String, query: String, page: Int = 1, completion: @escaping (Result<[String: Any], APIError>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let request = createRequest(endpoint: "\(Constants.Endpoints.postsSearch)?type=\(type)&q=\(encodedQuery)&page=\(page)", method: .GET) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError("Failed to decode")))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(json))
            }
        }.resume()
    }
    
    /// Match posts
    func matchPosts(
        province: String,
        rai: Int? = nil,
        workAmount: Int? = nil,
        squareMeters: Int? = nil,
        longanTrees: Int? = nil,
        completion: @escaping (Result<MatchResponse, APIError>) -> Void
    ) {
        var queryItems: [String] = ["province=\(province.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? province)"]
        
        if let rai = rai {
            queryItems.append("rai=\(rai)")
        }
        if let workAmount = workAmount {
            queryItems.append("workAmount=\(workAmount)")
        }
        if let squareMeters = squareMeters {
            queryItems.append("squareMeters=\(squareMeters)")
        }
        if let longanTrees = longanTrees {
            queryItems.append("longanTrees=\(longanTrees)")
        }
        
        let endpoint = "\(Constants.Endpoints.postsMatch)?\(queryItems.joined(separator: "&"))"
        
        guard let request = createRequest(endpoint: endpoint, method: .GET) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        performRequest(request: request, responseType: MatchResponse.self, completion: completion)
    }
    
    // MARK: - Favorites
    
    /// Add favorite
    func addFavorite(postId: Int, postType: String, completion: @escaping (Result<FavoriteResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "postId": postId,
            "postType": postType
        ]
        
        guard let request = createRequest(endpoint: Constants.Endpoints.favorites, method: .POST, body: body) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        performRequest(request: request, responseType: FavoriteResponse.self, completion: completion)
    }
    
    /// Remove favorite
    func removeFavorite(postId: Int, postType: String, completion: @escaping (Result<[String: Any], APIError>) -> Void) {
        guard let request = createRequest(endpoint: "\(Constants.Endpoints.favorites)/\(postId)?postType=\(postType)", method: .DELETE) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError("Failed to decode")))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(json))
            }
        }.resume()
    }
    
    /// Get favorites
    func getFavorites(completion: @escaping (Result<[FavoriteResponse], APIError>) -> Void) {
        guard let request = createRequest(endpoint: Constants.Endpoints.favorites, method: .GET) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        performRequest(request: request, responseType: [FavoriteResponse].self, completion: completion)
    }
    
    // MARK: - Ads
    
    /// Get ads
    func getAds(type: String? = nil, completion: @escaping (Result<[AdResponse], APIError>) -> Void) {
        var endpoint = Constants.Endpoints.ads
        if let type = type {
            endpoint += "?type=\(type)"
        }
        
        guard let request = createRequest(endpoint: endpoint, method: .GET) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        performRequest(request: request, responseType: [AdResponse].self, completion: completion)
    }
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case networkError(String)
    case invalidRequest
    case invalidResponse
    case httpError(Int, String)
    case noData
    case decodingError(String)
    case apiError(String)
    case unauthorized
    case notImplemented
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let code, let message):
            return "HTTP \(code): \(message)"
        case .noData:
            return "No data received"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .apiError(let message):
            return message
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .notImplemented:
            return "Not implemented yet"
        }
    }
}

// MARK: - LINE API Wrapper (for compatibility with existing code)
class API {
    static func getProfile(completion: @escaping (Result<LineUserProfile, Error>) -> Void) {
        // Get profile from LINE SDK
        guard LoginManager.shared.isAuthorized else {
            completion(.failure(LineLoginError.noAccessToken))
            return
        }
        
        // Use LINE SDK to get profile
        API.getProfile { result in
            switch result {
            case .success(let profile):
                let lineProfile = LineUserProfile(
                    userID: profile.userID ?? "",
                    displayName: profile.displayName ?? "",
                    pictureURL: profile.pictureURL,
                    statusMessage: profile.statusMessage
                )
                completion(.success(lineProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// Extension for LINE SDK - This uses the actual LINE SDK API
extension API {
    private static func getProfile(completion: @escaping (Result<User, Error>) -> Void) {
        // This is the actual LINE SDK call
        API.getProfile { result in
            completion(result)
        }
    }
}
