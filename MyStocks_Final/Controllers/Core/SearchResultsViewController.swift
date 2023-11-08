//
//  ViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.11.2023.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private let popular_brands: [String] = ["Apple", "Amazon", "Google", "Tesla", "Microsoft", "First Solar", "Alibaba", "Facebook", "MasterCard"]
    private var searched_brands: [String] = ["Apple", "Amazon", "Google", "Tesla", "Microsoft", "First Solar", "Alibaba", "Facebook", "MasterCard"]
    
    private let popular_requests_string: UILabel = {
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
    
    private let search_history_string: UILabel = {
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
    
    private lazy var collectionViewPopularRequests: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false
        collection.backgroundColor = .clear
        collection.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        return collection
    }()
    
    private let collectionViewSearchHistory: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        collectionViewPopularRequests.delegate = self
        collectionViewPopularRequests.dataSource = self
        collectionViewSearchHistory.delegate = self
        collectionViewSearchHistory.dataSource = self
    }
    
    private func setupUI() {
        view.addSubview(popular_requests_string)
        view.addSubview(search_history_string)
        view.addSubview(collectionViewPopularRequests)
        view.addSubview(collectionViewSearchHistory)
        
        let popular_requests_stringConstraints = [
            popular_requests_string.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            popular_requests_string.topAnchor.constraint(equalTo: view.topAnchor, constant: 96)
        ]
        let collectionViewPopularRequestsConstraints = [
            collectionViewPopularRequests.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionViewPopularRequests.topAnchor.constraint(equalTo: popular_requests_string.bottomAnchor, constant: 11),
            collectionViewPopularRequests.heightAnchor.constraint(equalToConstant: 500),
            collectionViewPopularRequests.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let search_history_stringConstraints = [
            search_history_string.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            search_history_string.topAnchor.constraint(equalTo: collectionViewPopularRequests.bottomAnchor, constant: 28)
        ]
        let collectionViewSearchHistoryConstraints = [
            collectionViewSearchHistory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionViewSearchHistory.topAnchor.constraint(equalTo: search_history_string.bottomAnchor, constant: 11),
            collectionViewSearchHistory.heightAnchor.constraint(equalToConstant: 110),
            collectionViewSearchHistory.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(popular_requests_stringConstraints)
        NSLayoutConstraint.activate(collectionViewPopularRequestsConstraints)
        NSLayoutConstraint.activate(search_history_stringConstraints)
        NSLayoutConstraint.activate(collectionViewSearchHistoryConstraints)
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewPopularRequests {
            return popular_brands.count
        } else if collectionView == collectionViewSearchHistory {
            return searched_brands.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath)
                as? SearchResultsCollectionViewCell else { return UICollectionViewCell() }
        if collectionView == collectionViewPopularRequests {
            cell.configure(withText: popular_brands[indexPath.row])
        } else if collectionView == collectionViewSearchHistory {
            cell.configure(withText: popular_brands[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize( width: (popular_brands[indexPath.item].size( withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width) + 25,height: 40)
    }
}
