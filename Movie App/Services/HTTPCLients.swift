//
//  HTTPCLients.swift
//  Movie App
//
//  Created by MD Abir Hossain on 5/7/22.
//  Copyright © 2022 Md Abir Hossain. All rights reserved.
//

import Foundation

class HTTPClient {
    
    enum NetworkError: Error {
        case badURL
        case noData
        case decodingError
    }
    
    func getMoviesBy(search: String, completion: @escaping (Result<[Movie]?,NetworkError>) -> Void) {
        
        guard let url = URL(string: "http://www.omdbapi.com/?s=\(search)&apikey=\(Constants.API_KEY)") else {
            return completion(.failure(.badURL))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            guard let moviesResponse = try? JSONDecoder().decode(MovieResponse.self, from: data)
                else {
                    return completion(.failure(.decodingError))
            }
            
            completion(.success(moviesResponse.movies))
            
        }.resume()
    }
}
