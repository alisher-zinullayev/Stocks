//
//  DefaultStockRemoteDataSource.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 12.09.2023.
//

import Foundation

protocol StocksRemoteDataSource: AnyObject {
    func fetchStock(ticker: String) async throws -> StockPricesResponse
}

final class DefaultStockRemoteDataSource: StocksRemoteDataSource {
    func fetchStock(ticker: String) async throws -> StockPricesResponse {
        guard let url = URL(string: "\(Constants.baseURL)quote?symbol=\(ticker)&token=\(Constants.API_KEY)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(from: request.url!)
            let decoder = JSONDecoder()
            let stockResponse = try decoder.decode(StockPricesResponse.self, from: data)
            return stockResponse
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
