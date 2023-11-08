//
//  SearchResultsCollectionViewCell.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.11.2023.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SearchResultsCollectionViewCell.self)
    
    let containerView: UIView = {
        let view = UIView()
        view.tintColor = .red
        view.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
        view.layer.borderColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1).cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let brand_name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Yandex"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private func setupUI() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(brand_name)
        
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        let brand_nameConstraints = [
            brand_name.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            brand_name.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            brand_name.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            brand_name.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(brand_nameConstraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        brand_name.text = nil
    }
    
    func configure(withText text: String) {
        brand_name.text = text
    }
}
