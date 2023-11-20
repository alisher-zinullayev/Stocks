//
//  DefaultChartsMetaDataSource.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 14.11.2023.
//

import Foundation

protocol StocksChartsMetaDataSource {
    func fetchStocksChartData(ticker: String, start: String, end: String, type: String) async throws -> [StockChartValues]
}

final class DefaultChartsMetaDataSource: StocksChartsMetaDataSource {
    func fetchStocksChartData(ticker: String, start: String, end: String, type: String) async throws -> [StockChartValues] {
        guard let url = URL(string: "https://finnhub.io/api/v1/stock/candle?symbol=\(ticker)&resolution=\(type)&from=\(start)&to=\(end)&token=cii2as9r01quio6uh8lgcii2as9r01quio6uh8m0") else {
            print("from url")
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let values = try JSONDecoder().decode(StockChartValues.self, from: data)
            return [values]
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
