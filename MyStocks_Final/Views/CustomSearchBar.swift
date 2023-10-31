//
//  CustomSearchBar.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 31.10.2023.
//

import UIKit

// default, focus, filled
enum states {
    case original
    case focus
    case filled
}

final class CustomSearchBar: UIView {

    private let searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Find company or ticker"
        return searchBar
    }()
    
    private let firstImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "search")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let secondImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "cancel")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1.0 // Set the border width
        view.layer.borderColor = UIColor.black.cgColor // Set the border color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupUI() {
        
        addSubview(containerView)
        addSubview(backView)
        addSubview(searchBar)
        addSubview(firstImage)
        addSubview(secondImage)
        
        let containerViewConstraints = [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            containerView.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        let backViewConstraints = [
            backView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            backView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
//            backView.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        let firstImageConstraints = [
            firstImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 8),
            firstImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            firstImage.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12),
            
        ]
        let searchBarConstraints = [
            searchBar.leadingAnchor.constraint(equalTo: firstImage.trailingAnchor, constant: 12),
            searchBar.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            searchBar.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12)
        ]
        let secondImageConstraints = [
            secondImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -8),
            secondImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            secondImage.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(backViewConstraints)
        NSLayoutConstraint.activate(firstImageConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
        NSLayoutConstraint.activate(secondImageConstraints)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension CustomSearchBar: UITextFieldDelegate {
    
}
