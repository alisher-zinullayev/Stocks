//
//  MainViewLogic.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 20.09.2023.
//

import Foundation

//protocol MainViewLogic: AnyObject {
//    var onDataFetched: (([StockMetaData]) -> Void)?
//    var onStockDataFetched: ((String, StockPricesResponse, _ completion: @escaping () -> Void) -> Void)?
//    var reloadTableView: (() -> Void)?
//
//}

class DefaultMainViewLogic {
    
    private let stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource
    private let stocksRemoteDataSource: DefaultStockRemoteDataSource
    
    var onDataFetched: (([StockMetaData]) -> Void)? // to communicate with main
    var onStockDataFetched: ((String, StockPricesResponse, _ completion: @escaping () -> Void) -> Void)?
    var reloadTableView: (() -> Void)?
    
    init(stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource, stocksRemoteDataSource: DefaultStockRemoteDataSource) {
        self.stocksMetadataLocalDataSource = stocksMetadataLocalDataSource
        self.stocksRemoteDataSource = stocksRemoteDataSource
    }
    
    func fetchStocks() {
        Task {
            do {
                let stocksList = stocksMetadataLocalDataSource.listStocksMetadata()
                onDataFetched?(stocksList)
                for stock in stocksList {
                    let stockResponse = try await stocksRemoteDataSource.fetchStock(ticker: stock.ticker)
                    onStockDataFetched?(stock.ticker, stockResponse) {
                        
                    }
                }
            } catch {
                print("Error fetching stock data: \(error)")
            }
        }
    }
}

