//
//  StockPricesResponse.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 08.09.2023.
//

import UIKit

struct StockPricesResponse: Codable {
    let c: Double? // current price
    let dp: Double? // percent change
    let d: Double? // change
}

enum CodingKeys: String, CodingKey {
    case currentPrice = "c"
    case changePercent = "dp"
    case change = "d"
}
