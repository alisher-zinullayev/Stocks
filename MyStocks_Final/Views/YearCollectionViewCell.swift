//
//  YearCollectionViewCell.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 06.11.2023.
//

import UIKit

final class YearCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: YearCollectionViewCell.self)
    
    let containerView: UIView = {
        let view = UIView()
        view.tintColor = .red
        view.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
        view.layer.borderColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1).cgColor
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "1Y"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private func setupUI() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(dataLabel)
        
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        let labelConsttaints = [
            dataLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dataLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(labelConsttaints)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                containerView.backgroundColor = .black
                dataLabel.textColor = .white
            } else {
                containerView.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
                dataLabel.textColor = .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataLabel.text = nil
    }
    
    func configure(label: String) {
        dataLabel.text = label
    }
    
}
