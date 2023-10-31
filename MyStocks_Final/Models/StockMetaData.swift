//
//  StockMetaData.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import Foundation

class StockMetaData: Codable {
    let name: String
    let logo: String //URL?
    let ticker: String
    var isFavorite: Bool

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.ticker = try container.decode(String.self, forKey: .ticker)
        self.logo = try container.decode(String.self, forKey: .logo)
//        let logoString = try container.decode(String.self, forKey: .logo)
//        self.logo = URL(string: logoString)
        self.isFavorite = false
    }

    static func == (lhs: StockMetaData, rhs: StockMetaData) -> Bool {
        return lhs.ticker == rhs.ticker
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, logo, ticker
    }
}
