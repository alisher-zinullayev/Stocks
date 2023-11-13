//
//  CustomSearchBar.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 31.10.2023.
//

import UIKit

protocol CustomSearchBarDelegate: AnyObject {
    func didChangeSearchText(searchText: String)
    func switchToSearchResultController()
}

final class CustomSearchBar: UIView {
    
    private var stocks: [StockMetaData] = []
    
    weak var delegate: CustomSearchBarDelegate?
    
    let searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Find company or ticker"
        if let placeholder = searchBar.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
                .font: UIFont.systemFont(ofSize: 16.0, weight: .semibold),
                .foregroundColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            ])
            searchBar.attributedPlaceholder = attributedPlaceholder
        }
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
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

enum SearchBarState {
    case normal // search nothing
    case focus // back nothing
    case filled // back cancel
}

extension CustomSearchBar {
    func updateSearchBarImages(forState state: SearchBarState) {
        switch state {
        case .normal:
            firstImage.isHidden = false
            secondImage.isHidden = true
            firstImage.image = UIImage(named: "search")
        case .focus:
            firstImage.isHidden = false
            secondImage.isHidden = true
            firstImage.image = UIImage(named: "back")
        case .filled:
            firstImage.isHidden = false
            secondImage.isHidden = false
            firstImage.image = UIImage(named: "back")
            secondImage.image = UIImage(named: "cancel")
        }
    }
}

extension CustomSearchBar: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text == "" {
                delegate?.switchToSearchResultController()
            } else {
                delegate?.didChangeSearchText(searchText: text)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // osy jakta isHidden bolu kerek
        updateSearchBarImages(forState: .focus)
        searchBar.placeholder = ""
        print("textFieldDidBeginEditing")
        delegate?.switchToSearchResultController()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && textField.text?.count == 1 {
            updateSearchBarImages(forState: .focus)
        } else {
            updateSearchBarImages(forState: .filled)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSearchBarImages(forState: .filled)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension CustomSearchBar {
    
    @objc func firstImageTapped() {
        let img = firstImage.image
        if img == UIImage(named: "search") {
            
        }
        if img == UIImage(named: "back") {
            updateSearchBarImages(forState: .focus)
            searchBar.text = ""
        }
    }
    
    @objc func secondImageTapped() {
        let img = secondImage.image
        if img == UIImage(named: "cancel") {
            updateSearchBarImages(forState: .normal)
            searchBar.text = ""
            searchBar.placeholder = "Find company or ticker"
            if let placeholder = searchBar.placeholder {
                let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
                    .font: UIFont.systemFont(ofSize: 16.0, weight: .semibold),
                    .foregroundColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
                ])
                searchBar.attributedPlaceholder = attributedPlaceholder
            }
            searchBar.resignFirstResponder()
        }
    }
    
    private func setupTapGesture() {
        let tapGestureFirstImage = UITapGestureRecognizer(target: self, action: #selector(firstImageTapped))
        firstImage.isUserInteractionEnabled = true
        firstImage.addGestureRecognizer(tapGestureFirstImage)
        let tapGestureSecondImage = UITapGestureRecognizer(target: self, action: #selector(secondImageTapped))
        secondImage.isUserInteractionEnabled = true
        secondImage.addGestureRecognizer(tapGestureSecondImage)
    }
    
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
        ]
        
        let backViewConstraints = [
            backView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            backView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ]
        
        let firstImageConstraints = [
            firstImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            firstImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            firstImage.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12),
            firstImage.heightAnchor.constraint(equalToConstant: 24),
            firstImage.widthAnchor.constraint(equalToConstant: 24)
            
        ]
        let searchBarConstraints = [
            searchBar.leadingAnchor.constraint(equalTo: firstImage.trailingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            searchBar.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12),
            searchBar.trailingAnchor.constraint(equalTo: secondImage.leadingAnchor, constant: 8)
        ]
        let secondImageConstraints = [
            secondImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            secondImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            secondImage.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12),
            secondImage.heightAnchor.constraint(equalToConstant: 24),
            secondImage.widthAnchor.constraint(equalToConstant: 24)
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(backViewConstraints)
        NSLayoutConstraint.activate(firstImageConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
        NSLayoutConstraint.activate(secondImageConstraints)
        
    }
}
