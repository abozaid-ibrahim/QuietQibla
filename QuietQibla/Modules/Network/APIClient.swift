//
//  APIClient.swift
//  ResyPhotos
//
//  Created by abuzeid on 13.01.24.
//

import Combine
import Foundation
protocol APIClient {
    static var baseUrl: String { get }

    func fetchData<T: Decodable>(for endpoint: EndPoint) async throws -> T
}

struct NetworkAPIClient: APIClient {
    static let baseUrl = "https://api.aladhan.com/v1/calendar/"
    // TODO: should be moved to a seperate Decoding class
    private var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func fetchData<T: Decodable>(for endpoint: EndPoint) async throws -> T {
        guard let url = URL(string: "\(Self.baseUrl)\(endpoint.path)") else {
            throw NetworkError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try jsonDecoder.decode(T.self, from: data)
    }
}
