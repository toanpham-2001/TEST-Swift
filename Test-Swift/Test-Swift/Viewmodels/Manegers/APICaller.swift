//
//  APICaller.swift
//  Test-Swift
//
//  Created by Pham Van Toan on 21/04/2024.
//

import Foundation


struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedTogetData
}
enum NetworkError: Error {
    case invalidURL
    case failedRequest
}

class APICaller {
    static let shared = APICaller()
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidURL))
                }
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.failedRequest))
                    }
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(results.results))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}






