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
    private let popular_brands: [String] = ["Apple", "Amazon", "Google", "Tesla", "Microsoft", "First Solar", "Alibaba", "Facebook", "MasterCard"]
    private var searched_brands: [String] = ["Apple", "Amazon", "Google", "Tesla", "Microsoft", "First Solar", "Alibaba", "Facebook", "MasterCard"]
    var isFavoriteSelected: Bool = false
    let defaultStockImageLoad = DefaultStockImageLoad()
    private var logic: DefaultMainViewLogic!
    
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
    
    // Collection View Methods
    private let popularRequestsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 161, height: 24)
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "Popular Requests"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let searchHistoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 226, height: 24)
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "You've searched for this"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let popularRequestsCV: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false
        collection.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        return collection
    }()
    
    private let searchHistoryCV: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false
        collection.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        return collection
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
        setupSecondUI()
        setCVDelegates()
        isMainPage(true)
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell
//        
//        cell!.delegate = self
//        
        let stock: StockMetaData
        if isFavoriteSelected {
            stock = searchfavouriteStocks[indexPath.row]
        } else {
            stock = searchStocksList[indexPath.row]
        }
        
        let temporary_ticker = stock.ticker
        let cardVC = CardViewController(
            nameString: stock.name,
            abbreviationString: stock.ticker,
            isFavouriteBool: stock.isFavorite,
            current_priceString: stockPrices[stock.ticker]?.c ?? Constanst.defaultPrice,
            price_changeString: stockPrices[temporary_ticker]?.d ?? Constanst.defaultPrice,
            percent_changeString: stockPrices[temporary_ticker]?.dp ?? Constanst.defaultPrice
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
            currentPrice: stockPrices[temporary_ticker]?.c ?? Constanst.defaultPrice,
            percentPrice: stockPrices[temporary_ticker]?.dp ?? Constanst.defaultPrice,
            priceChange: stockPrices[temporary_ticker]?.d ?? Constanst.defaultPrice,
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
    
    func switchToSearchResultController() {
        isMainPage(false)
    }
    
    func didChangeSearchText(searchText: String) {
        if searchText.isEmpty {
            searchfavouriteStocks = favouriteStocks
            searchStocksList = stocksList
        } else if searchText == "" {
            switchToSearchResultController()
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
        
        isMainPage(true)
        
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
        
        logic = DefaultMainViewLogic(
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
        
        stocksTableView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(stocksButton.snp.bottom).offset(20)
        }

        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.separatorStyle = .none
    }
    
    private func setupButtons() {
        
        view.addSubview(stocksButton)
        view.addSubview(favoriteButton)
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.height.equalTo(48)
        }
        
        stocksButton.snp.makeConstraints { maker in
            maker.height.equalTo(32)
            maker.width.equalTo(98)
            maker.leading.equalToSuperview().offset(20)
            maker.top.equalTo(searchBar.snp.bottom).offset(20)
        }
        
        favoriteButton.snp.makeConstraints { maker in
            maker.height.equalTo(32)
            maker.leading.equalTo(stocksButton.snp.trailing).offset(20)
            maker.top.equalTo(searchBar.snp.bottom).offset(20)
        }
    }
    
    private func setupSecondUI() {
        view.addSubview(popularRequestsLabel)
        view.addSubview(searchHistoryLabel)
        view.addSubview(popularRequestsCV)
        view.addSubview(searchHistoryCV)
        
        popularRequestsLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(20)
            maker.top.equalTo(searchBar.snp.bottom).offset(32)
        }
        
        popularRequestsCV.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(popularRequestsLabel.snp.bottom).offset(11)
            maker.height.equalTo(110)
        }
        
        searchHistoryLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(20)
            maker.top.equalTo(popularRequestsCV.snp.bottom).offset(28)
        }
        
        searchHistoryCV.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(searchHistoryLabel.snp.bottom).offset(11)
            maker.height.equalTo(110)
        }
    }
    
    private func setCVDelegates() {
        popularRequestsCV.delegate = self
        popularRequestsCV.dataSource = self
        searchHistoryCV.delegate = self
        searchHistoryCV.dataSource = self
    }
    
    private func isMainPage(_ mainPage: Bool) {
        if mainPage {
            searchHistoryCV.isHidden = true
            popularRequestsCV.isHidden = true
            popularRequestsLabel.isHidden = true
            searchHistoryLabel.isHidden = true
            favoriteButton.isHidden = false
            stocksButton.isHidden = false
            stocksTableView.isHidden = false
        } else {
            searchHistoryCV.isHidden = false
            popularRequestsCV.isHidden = false
            popularRequestsLabel.isHidden = false
            searchHistoryLabel.isHidden = false
            favoriteButton.isHidden = true
            stocksButton.isHidden = true
            stocksTableView.isHidden = true
        }
    }
    
}


//MARK: - UICollectionDelegates

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularRequestsCV {
            return popular_brands.count
        } else if collectionView == searchHistoryCV {
            return searched_brands.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath)
                as? SearchResultsCollectionViewCell else { return UICollectionViewCell() }
        if collectionView == popularRequestsCV {
            cell.configure(withText: popular_brands[indexPath.row])
        } else if collectionView == searchHistoryCV {
            cell.configure(withText: searched_brands[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (popular_brands[indexPath.item].size(
                withAttributes:
                    [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width) + 25,
                height: 40
            )
    }
}

enum Constanst {
    static let defaultPrice: Double = 12
}
