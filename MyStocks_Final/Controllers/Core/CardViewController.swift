//
//  CardViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 05.11.2023.
//

import UIKit

final class CardViewController: UIViewController {
    
    var nameString: String
    var abbreviationString: String
    var isFavouriteBool: Bool
    var current_priceString: Double
    var price_changeString: Double
    var percent_changeString: Double
    
    private let dates = ["D", "W", "M", "6M", "1Y", "All"]
    
    init(nameString: String, abbreviationString: String, isFavouriteBool: Bool, current_priceString: Double, price_changeString: Double, percent_changeString: Double) {
        self.nameString = nameString
        self.abbreviationString = abbreviationString
        self.isFavouriteBool = isFavouriteBool
        self.current_priceString = current_priceString
        self.price_changeString = price_changeString
        self.percent_changeString = percent_changeString
        name.text = nameString
        abbreviation.text = abbreviationString
        current_price.text = "$\(current_priceString)"
        price_change.text = "$\(price_changeString) (\(percent_changeString)%)"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupCollectionView()
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItems = [customBackButton]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(tapGesture)
    }
    
    private let backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "back")
        imageView.tintColor = UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
        return imageView
    }()
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupCustomBackButton() {
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    private let starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "chart_fav")
        imageView.tintColor = UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "YNDX"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private let abbreviation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "Yandex, LLC"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var chartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Chart", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var summaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Summary", for: .normal)
        button.setTitleColor(UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    lazy var newsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("News", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1), for: .normal)
        return button
    }()
    
    lazy var forecastsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forecasts", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1), for: .normal)
        return button
    }()
    
    lazy var ideasButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ideas", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1), for: .normal)
        return button
    }()
    
    
    private let current_price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "$131.93"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    private let price_change: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "+$0.12 (1,15%)"
        label.textColor = UIColor(red: 0.14, green: 0.7, blue: 0.364, alpha: 1) // or red
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    
    private let stockGraphView: StockGraphView = {
        let view = StockGraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(YearCollectionViewCell.self, forCellWithReuseIdentifier: YearCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private func setupUI() {
        
        view.addSubview(backButton)
        view.addSubview(abbreviation)
        view.addSubview(name)
        view.addSubview(starIcon)
        view.addSubview(chartButton)
        view.addSubview(summaryButton)
        view.addSubview(newsButton)
        view.addSubview(forecastsButton)
        view.addSubview(ideasButton)
        view.addSubview(stockGraphView)
        view.addSubview(current_price)
        view.addSubview(price_change)
        
        let backConstraints = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 62), // 10
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
        ]
        let abbreviationConstraints = [
            abbreviation.topAnchor.constraint(equalTo: view.topAnchor, constant: 52), // 10
            abbreviation.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        let nameConstraints = [
            name.topAnchor.constraint(equalTo: abbreviation.bottomAnchor, constant: 4),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        let starIconConstraints = [
            starIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 62), //10
            starIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            starIcon.heightAnchor.constraint(equalToConstant: 24),
            starIcon.widthAnchor.constraint(equalToConstant: 24),
        ]
        let chartButtonConstraints = [
            chartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 118), // 10
            chartButton.widthAnchor.constraint(equalToConstant: 53),
            chartButton.heightAnchor.constraint(equalToConstant: 24)
        ]
        let summaryButtonConstraints = [
            summaryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120), // 10
            summaryButton.widthAnchor.constraint(equalToConstant: 71),
            summaryButton.heightAnchor.constraint(equalToConstant: 20),
            summaryButton.leadingAnchor.constraint(equalTo: chartButton.trailingAnchor, constant: 20)
        ]
        let newsButtonConstraints = [
            newsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            newsButton.widthAnchor.constraint(equalToConstant: 40),
            newsButton.heightAnchor.constraint(equalToConstant: 20),
            newsButton.leadingAnchor.constraint(equalTo: summaryButton.trailingAnchor, constant: 20)
        ]
        let forecastsButtonConstraints = [
            forecastsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            forecastsButton.widthAnchor.constraint(equalToConstant: 70),
            forecastsButton.heightAnchor.constraint(equalToConstant: 20),
            forecastsButton.leadingAnchor.constraint(equalTo: newsButton.trailingAnchor, constant: 20)
        ]
        let ideasButtonConstraints = [
            ideasButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            ideasButton.widthAnchor.constraint(equalToConstant: 39),
            ideasButton.heightAnchor.constraint(equalToConstant: 20),
            ideasButton.leadingAnchor.constraint(equalTo: forecastsButton.trailingAnchor, constant: 20)
        ]
        let stockGraphViewConstraints = [
            stockGraphView.topAnchor.constraint(equalTo: chartButton.bottomAnchor, constant: 20),
            stockGraphView.heightAnchor.constraint(equalToConstant: 464),
            stockGraphView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        let current_priceConstraints = [
            current_price.topAnchor.constraint(equalTo: chartButton.bottomAnchor, constant: 62),
            current_price.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        let price_changeConstraints = [
            price_change.topAnchor.constraint(equalTo: current_price.bottomAnchor, constant: 8),
            price_change.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(backConstraints)
        NSLayoutConstraint.activate(abbreviationConstraints)
        NSLayoutConstraint.activate(nameConstraints)
        NSLayoutConstraint.activate(starIconConstraints)
        NSLayoutConstraint.activate(chartButtonConstraints)
        NSLayoutConstraint.activate(summaryButtonConstraints)
        NSLayoutConstraint.activate(newsButtonConstraints)
        NSLayoutConstraint.activate(forecastsButtonConstraints)
        NSLayoutConstraint.activate(ideasButtonConstraints)
        NSLayoutConstraint.activate(stockGraphViewConstraints)
        NSLayoutConstraint.activate(current_priceConstraints)
        NSLayoutConstraint.activate(price_changeConstraints)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = UIColor.white
        collectionView.backgroundView = whiteBackgroundView
        collectionView.backgroundColor = .red
        collectionView.topAnchor.constraint(equalTo: stockGraphView.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let lastIndexPath = IndexPath(item: dates.count - 1, section: 0)
        collectionView.selectItem(at: lastIndexPath, animated: false, scrollPosition: .left)
        if let lastCell = collectionView.cellForItem(at: lastIndexPath) as? YearCollectionViewCell {
            lastCell.isSelected = true
        }
    }
}

extension CardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YearCollectionViewCell.identifier, for: indexPath) as? YearCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(label: dates[indexPath.row])
        return cell
    }
}
