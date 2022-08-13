//
//  APIManager.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 10.08.2022.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    enum APIError: Error {
        case failedToGetData
    }
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
    createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { baseRequest in
        let task = URLSession.shared.dataTask(with: baseRequest) { data, _, err in
            guard let data = data, err == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(.success(result))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
    func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?country=US"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }

            }
            task.resume()
        }
    }
    
    func getRecommendations(genres: Set<String>, completion: @escaping (Result<String, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    
    
}
