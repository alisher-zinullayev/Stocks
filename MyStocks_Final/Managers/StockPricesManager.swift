//
//  StockPricesManager.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 19.09.2023.
//

import Foundation

final class StockPricesManager {
    private var stockPrices: [String: StockPricesResponse] = [:]

    func saveStockPrices(ticker: String, stockResponse: StockPricesResponse, completion: @escaping () -> Void) {
        stockPrices[ticker] = stockResponse
        completion()
    }
    
    func getStockPrices(ticker: String) -> StockPricesResponse? {
        let stockPrice = stockPrices[ticker]
        return stockPrice
    }
}
