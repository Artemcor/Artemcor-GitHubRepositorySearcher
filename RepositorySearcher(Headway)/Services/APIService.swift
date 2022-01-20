//
//  APIServise.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import Foundation

struct APIService {

    func getJSON<T: Decodable>(urlString: String,completion: @escaping (Result<T, APIError>) -> Void) {
        guard
            let url = URL(string: urlString)
        else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let HTTPSResponse = response as? HTTPURLResponse,
                HTTPSResponse.statusCode == 200 else {
                    completion(.failure(.invalidResponseStatus))
                    return
                }
            guard
                error == nil else {
                    completion(.failure(.dataTaskError))
                    return
                }
            guard
                let data = data else {
                    completion(.failure(.corruptData))
                    return
                }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
                print("Error")
            }
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
}
