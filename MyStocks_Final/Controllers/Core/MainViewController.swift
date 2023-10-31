//
//  ViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import UIKit

let stockPricesManager = StockPricesManager()

final class MainViewController: UIViewController {
    
    var isFavoriteSelected: Bool = false
    
    private var stocksList: [StockMetaData] = [] // variable for saving name, logo, ticker
    private var favouriteStocks: [StockMetaData] = []
    private var stockPrices: [String : StockPricesResponse] = [ : ] // variable for saving stock prices by ticker
    let defaultStockImageLoad = DefaultStockImageLoad()
    private var logic: MainViewLogic!
    
    private let searchBar: CustomSearchBar = {
        let view = CustomSearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stocksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()
    
    lazy var stocksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(stocksButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func stocksButtonTapped() {
        print("stocks button tapped")
        stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        stocksButton.setTitleColor(.black, for: .normal)
        favoriteButton.setTitleColor(.gray, for: .normal)
        isFavoriteSelected = false
        stocksTableView.reloadData()
    }
    
    @objc func favoriteButtonTapped() {
        print("favorite button tapped")
        stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        stocksButton.setTitleColor(.gray, for: .normal)
        favoriteButton.setTitleColor(.black, for: .normal)
        isFavoriteSelected = true
        stocksTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        logicFunctions()
        setupButtons()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    private func logicFunctions() {
        
        logic = MainViewLogic(
            stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource(),
            stocksRemoteDataSource: DefaultStockRemoteDataSource()
        )
        
        logic.onDataFetched = { [weak self] stocksList in
            DispatchQueue.main.async {
                self?.stocksList = stocksList
                self?.stocksTableView.reloadData()
            }
        }
        
        logic.onStockDataFetched = { [weak self] ticker, stockResponse, completion in
            stockPricesManager.saveStockPrices(ticker: ticker, stockResponse: stockResponse) {
                if let stockPrice = stockPricesManager.getStockPrices(ticker: ticker) {
                    self!.stockPrices[ticker] = stockResponse
                    DispatchQueue.main.async {
                        self?.stocksTableView.reloadData()
                    }
                } else {
                    print("Stock data for \(ticker) not found in stockPrices")
                }
            }
        }
        
        logic.fetchStocks()
    }
}

//
// check whether we are in favourite or in stocks
//

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavoriteSelected {
            return favouriteStocks.count
        } else {
            return stocksList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        if isFavoriteSelected {
            if favouriteStocks.isEmpty || indexPath.row >= favouriteStocks.count {
                cell.configure(with: indexPath.row, companyName: "loading", companyTicker: "loading", currentPrice: 123, percentPrice: 123, priceChange: 123)
            } else {
                let imageURL = favouriteStocks[indexPath.row].logo
                let temporary_ticker = favouriteStocks[indexPath.row].ticker
                cell.model = favouriteStocks[indexPath.row]
                
                cell.configure(with: indexPath.row, companyName: favouriteStocks[indexPath.row].name, companyTicker: favouriteStocks[indexPath.row].ticker, currentPrice: stockPrices[temporary_ticker]?.c ?? 12, percentPrice: stockPrices[temporary_ticker]?.dp ?? 12, priceChange: stockPrices[temporary_ticker]?.d ?? 12)
                
                Task {
                    do {
                        if let image = try await defaultStockImageLoad.fetchImage(urlString: imageURL) {
                            DispatchQueue.main.async {
                                cell.logo.image = image
                            }
                        }
                    } catch {
                        print("Error fetching image: \(error)")
                    }
                }
            }
        } else {
            if stocksList.isEmpty || indexPath.row >= stocksList.count {
                cell.configure(with: indexPath.row, companyName: "loading", companyTicker: "loading", currentPrice: 123, percentPrice: 123, priceChange: 123)
            } else {
            
                let imageURL = stocksList[indexPath.row].logo
                let temporary_ticker = stocksList[indexPath.row].ticker
                
                cell.configure(with: indexPath.row, companyName: stocksList[indexPath.row].name, companyTicker: stocksList[indexPath.row].ticker, currentPrice: stockPrices[temporary_ticker]?.c ?? 12, percentPrice: stockPrices[temporary_ticker]?.dp ?? 12, priceChange: stockPrices[temporary_ticker]?.d ?? 12)
                cell.model = stocksList[indexPath.row]
                
                Task {
                    do {
                        if let image = try await defaultStockImageLoad.fetchImage(urlString: imageURL) {
                            DispatchQueue.main.async {
                                cell.logo.image = image
                            }
                        }
                    } catch {
                        print("Error fetching image: \(error)")
                    }
                }
            }
        }
        return cell
    }
}

extension MainViewController: MainTableViewCellDelegate {
    func removeFromFavourite(model: StockMetaData) {
        if let index = favouriteStocks.firstIndex(where: { $0 == model }) {
            favouriteStocks.remove(at: index)
        }
        stocksTableView.reloadData()
    }
    
    func addToFavourite(model: StockMetaData) {
        favouriteStocks.append(model)
    }
}


extension MainViewController {
    
    private func setupTableView() {
        view.addSubview(stocksTableView)
        
        let stocksTableViewConstraints = [
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stocksTableView.topAnchor.constraint(equalTo: stocksButton.bottomAnchor, constant: 20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(stocksTableViewConstraints)
        
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.separatorStyle = .none
    }
    
    private func setupButtons() {
        
        view.addSubview(stocksButton)
        view.addSubview(favoriteButton)
        view.addSubview(searchBar)
        // 16, 40, 16
        let searchBarConstraints = [
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor), //, constant: 16
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor), //, constant: -16
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            searchBar.heightAnchor.constraint(equalToConstant: 48) //48),
        ]
        let stocksButtonConstraints = [
            stocksButton.heightAnchor.constraint(equalToConstant: 32),
            stocksButton.widthAnchor.constraint(equalToConstant: 98),
            stocksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20) // 20 or 28
        ]
        let favoriteButtonConstraints = [
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
//            favoriteButton.widthAnchor.constraint(equalToConstant: 98),
            favoriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor, constant: 20),
            favoriteButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20) // 20 or 28
        ]
        
        NSLayoutConstraint.activate(stocksButtonConstraints)
        NSLayoutConstraint.activate(favoriteButtonConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
        
    }
}
