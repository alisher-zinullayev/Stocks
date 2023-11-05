//
//  CardViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 05.11.2023.
//

import UIKit

final class CardViewController: UIViewController {
    
    private let backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "back")
        imageView.tintColor = UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
        return imageView
    }()
    
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var summaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Summary", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var newsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("News", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var forecastsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forecasts", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var ideasButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ideas", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
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
        
        let backConstraints = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 52),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
        ]
        let abbreviationConstraints = [
            abbreviation.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4),
            abbreviation.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        let nameConstraints = [
            name.topAnchor.constraint(equalTo: view.topAnchor, constant: 42),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        let starIconConstraints = [
            starIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 52),
            starIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            starIcon.heightAnchor.constraint(equalToConstant: 24),
            starIcon.widthAnchor.constraint(equalToConstant: 24),
        ]
        let chartButtonConstraints = [
            chartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            chartButton.widthAnchor.constraint(equalToConstant: 53),
            chartButton.heightAnchor.constraint(equalToConstant: 24)
        ]
        let summaryButtonConstraints = [
            summaryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            summaryButton.widthAnchor.constraint(equalToConstant: 71),
            summaryButton.heightAnchor.constraint(equalToConstant: 20),
            summaryButton.leadingAnchor.constraint(equalTo: chartButton.trailingAnchor, constant: 20)
        ]
        let newsButtonConstraints = [
            newsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            newsButton.widthAnchor.constraint(equalToConstant: 40),
            newsButton.heightAnchor.constraint(equalToConstant: 20),
            newsButton.leadingAnchor.constraint(equalTo: summaryButton.trailingAnchor, constant: 20)
        ]
        let forecastsButtonConstraints = [
            forecastsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            forecastsButton.widthAnchor.constraint(equalToConstant: 70),
            forecastsButton.heightAnchor.constraint(equalToConstant: 20),
            forecastsButton.leadingAnchor.constraint(equalTo: newsButton.trailingAnchor, constant: 20)
        ]
        let ideasButtonConstraints = [
            ideasButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            ideasButton.widthAnchor.constraint(equalToConstant: 39),
            ideasButton.heightAnchor.constraint(equalToConstant: 20),
            ideasButton.leadingAnchor.constraint(equalTo: forecastsButton.trailingAnchor, constant: 20)
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
    }
    
    func configure(nameString: String, abbreviationString: String, isFavoriteBool: Bool) {
        name.text = nameString
        abbreviation.text = abbreviationString
        if isFavoriteBool {
            starIcon.image = UIImage(named: "favorite")
        } else {
            starIcon.image = UIImage(named: "default")
        }
    }
}
