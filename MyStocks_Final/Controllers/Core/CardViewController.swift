//
//  CardViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 05.11.2023.
//

import UIKit
import DGCharts
import SnapKit

final class CardViewController: UIViewController {
    
    var nameString: String
    var abbreviationString: String
    var isFavouriteBool: Bool
    var current_priceString: Double
    var price_changeString: Double
    var percent_changeString: Double
    
    private let dates = ["D", "W", "M", "6M", "1Y", "All"]
    
    var values: [StockChartValues] = []
    var valuesForChart: [ChartDataEntry] = [
    ]
    
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
        let starIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(starIconTapped))
        starIcon.isUserInteractionEnabled = true
        starIcon.addGestureRecognizer(starIconTapGesture)
        
        lineChartView.delegate = self
        
        
        Task { [weak self] in
            do {
                let currentDateInt = Int(Date().timeIntervalSince1970)
                let values = try await DefaultChartsMetaDataSource().fetchStocksChartData(ticker: abbreviationString, start: "0", end: String(currentDateInt), type: "W")
                self?.values = values
                DispatchQueue.main.async { [weak self] in
                    self?.addData()
                    self?.setData()
                }
            } catch {
                print("Error fetching stock chart data: \(error)")
            }
        }
        
        setData()
    }
    
    
    func addData() {
        valuesForChart.removeAll()
        
        for stockValue in values {
            for cValue in stockValue.c {
                let chartEntry = ChartDataEntry(x: Double(valuesForChart.count), y: cValue)
                valuesForChart.append(chartEntry)
            }
        }
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
    
    lazy var starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "default")
        imageView.tintColor = UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
        return imageView
    }()
    
    @objc func starIconTapped() {
        print("star icon was tapped")
    }
    
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
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.animate(xAxisDuration: 2.0)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
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
    
    func calculateTimestampOffset(days: Int) -> TimeInterval {
        let currentDate = Date()
        let oneDayInSeconds: TimeInterval = 24 * 60 * 60
        let offsetTimestamp = currentDate.timeIntervalSince1970 - Double(days) * oneDayInSeconds
        return offsetTimestamp
    }

    func getTimestampOffset(forDate date: String) -> (Int, String) {
        var resultInt: Int = 0
        var typeStr = "D"

        switch date {
        case "W":
            resultInt = Int(calculateTimestampOffset(days: 7))
        case "M":
            resultInt = Int(calculateTimestampOffset(days: 30))
        case "6M":
            resultInt = Int(calculateTimestampOffset(days: 30 * 6))
        case "1Y":
            resultInt = Int(calculateTimestampOffset(days: 365))
        case "All":
            resultInt = Int(calculateTimestampOffset(days: 365))
            typeStr = "W"
        default:
            break
        }

        return (resultInt, typeStr)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (resultInt, typeStr) = getTimestampOffset(forDate: dates[indexPath.row])

        Task { [weak self] in
            do {
                let currentDate = Date()
                let currentDateInt = Int(currentDate.timeIntervalSince1970)
                let values = try await DefaultChartsMetaDataSource().fetchStocksChartData(ticker: abbreviationString, start: String(resultInt), end: String(currentDateInt), type: typeStr)
                self?.values = values
                DispatchQueue.main.async { [weak self] in
                    self?.addData()
                    self?.setData()
                }
            } catch {
                print("Error fetching stock chart data: \(error)")
            }
        }
    }
}

extension CardViewController: ChartViewDelegate {
    
    func setData() {
        let colors: [CGColor] = [
            UIColor.white.cgColor,
            UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1).cgColor
        ]
        let locations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: locations)

        let set1 = LineChartDataSet(entries: valuesForChart, label: "")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.setColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        set1.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        set1.fillAlpha = 0.2
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.highlightColor = .black
        
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
}

// UI-Setup
extension CardViewController {
    
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
        view.addSubview(lineChartView)
        view.addSubview(current_price)
        view.addSubview(price_change)
        
        backButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(62)
            maker.leading.equalToSuperview().offset(16)
            maker.height.width.equalTo(24)
        }
        
        abbreviation.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(52)
            maker.centerX.equalToSuperview()
        }
        
        name.snp.makeConstraints { maker in
            maker.top.equalTo(abbreviation.snp.bottom).offset(4)
            maker.centerX.equalToSuperview()
        }
        
        starIcon.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(62)
            maker.trailing.equalToSuperview().offset(-16)
            maker.height.width.equalTo(24)
        }
        
        chartButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(20)
            maker.top.equalToSuperview().offset(118)
            maker.width.equalTo(53)
            maker.height.equalTo(24)
        }
        
        summaryButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(120)
            maker.height.equalTo(20)
            maker.width.equalTo(71)
            maker.leading.equalTo(chartButton.snp.trailing).offset(20)
        }
        
        newsButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(120)
            maker.height.equalTo(20)
            maker.width.equalTo(40)
            maker.leading.equalTo(summaryButton.snp.trailing).offset(20)
        }
        
        forecastsButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(120)
            maker.height.equalTo(20)
            maker.width.equalTo(70)
            maker.leading.equalTo(newsButton.snp.trailing).offset(20)
        }
        
        ideasButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(120)
            maker.height.equalTo(20)
            maker.width.equalTo(39)
            maker.leading.equalTo(forecastsButton.snp.trailing).offset(20)
        }
        
        current_price.snp.makeConstraints { maker in
            maker.top.equalTo(chartButton.snp.bottom).offset(62)
            maker.centerX.equalToSuperview()
        }
        
        price_change.snp.makeConstraints { maker in
            maker.top.equalTo(current_price.snp.bottom).offset(8)
            maker.centerX.equalToSuperview()
        }
        
        lineChartView.snp.makeConstraints { maker in
            maker.top.equalTo(price_change.snp.bottom).offset(10)
            maker.height.equalTo(280)
            maker.width.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = UIColor.white
        collectionView.backgroundView = whiteBackgroundView
        collectionView.backgroundColor = .red
        collectionView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 40).isActive = true
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
