//
//  ViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import UIKit

let stockPricesManager = StockPricesManager()

final class MainViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    private var stocksList: [StockMetaData] = []
    private var favouriteStocks: [StockMetaData] = []
    private var searchStocksList: [StockMetaData] = []
    private var searchfavouriteStocks: [StockMetaData] = []
    private var stockPrices: [String : StockPricesResponse] = [ : ]
    var isFavoriteSelected: Bool = false
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
        stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        stocksButton.setTitleColor(.black, for: .normal)
        favoriteButton.setTitleColor(.gray, for: .normal)
        isFavoriteSelected = false
        stocksTableView.reloadData()
    }
    
    @objc func favoriteButtonTapped() {
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
        searchBar.delegate = self
        logicFunctions()
        setupButtons()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: - UITableViewFunctions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavoriteSelected {
            return searchfavouriteStocks.count
        } else {
            return searchStocksList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock: StockMetaData
        if isFavoriteSelected {
            stock = favouriteStocks[indexPath.row]
        } else {
            stock = stocksList[indexPath.row]
        }
        
        let temporary_ticker = stock.ticker
        let cardVC = CardViewController(
            nameString: stock.name,
            abbreviationString: stock.ticker,
            isFavouriteBool: stock.isFavorite,
            current_priceString: stockPrices[stock.ticker]?.c ?? 12,
            price_changeString: stockPrices[temporary_ticker]?.d ?? 12,
            percent_changeString: stockPrices[temporary_ticker]?.dp ?? 12
        )
        navigationController?.pushViewController(cardVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        let stock: StockMetaData
        
        if isFavoriteSelected {
            stock = searchfavouriteStocks[indexPath.row]
        } else {
            stock = searchStocksList[indexPath.row]
        }
        
        let imageURL = stock.logo
        let temporary_ticker = stock.ticker
        cell.model = stock

        cell.configure(
            with: indexPath.row,
            companyName: stock.name,
            companyTicker: stock.ticker,
            currentPrice: stockPrices[temporary_ticker]?.c ?? 12,
            percentPrice: stockPrices[temporary_ticker]?.dp ?? 12,
            priceChange: stockPrices[temporary_ticker]?.d ?? 12,
            isFavorite: defaults.bool(forKey: stock.ticker)
        )

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
        return cell
    }
    
}

//MARK: - CustomSearchBarDelegate
extension MainViewController: CustomSearchBarDelegate {
    
    func didChangeSearchText(searchText: String) {
        if searchText.isEmpty {
            searchfavouriteStocks = favouriteStocks
            searchStocksList = stocksList
        } else {
            searchfavouriteStocks = favouriteStocks
            searchfavouriteStocks = favouriteStocks.filter({ stock in
                return stock.name.contains(searchText) || stock.ticker.contains(searchText)
            })
            searchStocksList = stocksList
            searchStocksList = stocksList.filter({ stock in
                return stock.name.contains(searchText) || stock.ticker.contains(searchText)
            })
        }
        stocksTableView.reloadData()
    }
}

//MARK: - MainTableViewCellDelegate Methods
extension MainViewController: MainTableViewCellDelegate {
    func removeFromFavourite(model: StockMetaData) {
        defaults.removeObject(forKey: model.ticker)
        if let index = favouriteStocks.firstIndex(where: { $0 == model }) {
            favouriteStocks.remove(at: index)
        }
        stocksTableView.reloadData()
    }
    
    func addToFavourite(model: StockMetaData) {
        defaults.set(true, forKey: model.ticker)
        favouriteStocks.append(model)
    }
}


//MARK: - MainViewLogic
extension MainViewController {
    private func logicFunctions() {
        
        logic = MainViewLogic(
            stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource(),
            stocksRemoteDataSource: DefaultStockRemoteDataSource()
        )
        
        logic.onDataFetched = { [weak self] stocksList in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stocksList = stocksList
                self.searchStocksList = stocksList
                self.favouriteStocks = (self.stocksList.filter {
                    self.defaults.bool(forKey: $0.ticker) == true
                })
                
                self.stocksTableView.reloadData()
            }
        }
        
        logic.onStockDataFetched = { [weak self] ticker, stockResponse, completion in
            guard let self = self else {return}
            stockPricesManager.saveStockPrices(ticker: ticker, stockResponse: stockResponse) {
                if stockPricesManager.getStockPrices(ticker: ticker) != nil {
                    self.stockPrices[ticker] = stockResponse
                    DispatchQueue.main.async {
                        self.stocksTableView.reloadData()
                    }
                } else { print("err") }
            }
        }
        
        logic.fetchStocks()
    }
}


//MARK: - UISetup
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
        
        let searchBarConstraints = [
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        let stocksButtonConstraints = [
            stocksButton.heightAnchor.constraint(equalToConstant: 32),
            stocksButton.widthAnchor.constraint(equalToConstant: 98),
            stocksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20) // 20 or 28
        ]
        let favoriteButtonConstraints = [
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            favoriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor, constant: 20),
            favoriteButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20) // 20 or 28
        ]
        
        NSLayoutConstraint.activate(stocksButtonConstraints)
        NSLayoutConstraint.activate(favoriteButtonConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
        
    }
}
