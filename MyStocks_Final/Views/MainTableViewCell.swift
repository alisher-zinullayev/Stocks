//
//  MainTableViewCell.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import UIKit

protocol MainTableViewCellDelegate: AnyObject {
    func addToFavourite(model: StockMetaData)
    func removeFromFavourite(model: StockMetaData)
}

final class MainTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: MainTableViewCell.self)
    
    weak var delegate: MainTableViewCellDelegate?
    
    var model: StockMetaData?
    
    @objc func starIconTapped() {
        if starIcon.image == UIImage(named: "favorite") {
            model?.isFavorite = false
            delegate?.removeFromFavourite(model: model!)
            starIcon.image = UIImage(named: "default")
        } else {
            model?.isFavorite = true
            delegate?.addToFavourite(model: model!)
            starIcon.image = UIImage(named: "favorite")
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "yandex_icon")
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "YNDX"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private let starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
        return imageView
    }()
    
    private let current_price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "4 764,6 ₽"
        label.textAlignment = .center
        label.textAlignment = .right
        return label
    }()
    
    private let percent_price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.14, green: 0.7, blue: 0.364, alpha: 1)
        label.text = "+55 ₽ (1,15%)"
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starIconTapped))
        starIcon.isUserInteractionEnabled = true
        starIcon.addGestureRecognizer(tapGesture)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        
        func animateColorChange(from fromColor: CGColor, to toColor: UIColor, duration: TimeInterval = 0.2) {
            if self.containerView.layer.backgroundColor == fromColor {
                if selected {
                    UIView.animate(withDuration: duration) {
                        self.backgroundUIView.backgroundColor = toColor
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        UIView.animate(withDuration: duration) {
                            self.backgroundUIView.backgroundColor = UIColor(cgColor: fromColor)
                        }
                    }
                } else {
                    self.backgroundUIView.backgroundColor = UIColor(cgColor: fromColor)
                }
            }
        }
        
        animateColorChange(from: UIColor.myGrayColor.cgColor, to: UIColor.myDarkGrayColor)
        animateColorChange(from: UIColor.myWhiteColor.cgColor, to: UIColor.myGrayColor)
    }
}

// MARK: - UISetup

extension MainTableViewCell {
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundUIView)
        containerView.addSubview(logo)
        containerView.addSubview(name)
        containerView.addSubview(abbreviation)
        containerView.addSubview(current_price)
        containerView.addSubview(percent_price)
        containerView.addSubview(starIcon)
    }
    
    private func setupUI() {
        
        containerView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.height.greaterThanOrEqualTo(68)
        }
        
        backgroundUIView.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalTo(containerView)
            maker.height.greaterThanOrEqualTo(68)
        }
        
        logo.snp.makeConstraints { maker in
            maker.height.width.equalTo(52)
            maker.leading.top.equalTo(backgroundUIView).offset(8)
            maker.bottom.lessThanOrEqualTo(backgroundUIView.snp.bottom).offset(-8)
        }
        
        name.snp.makeConstraints { maker in
            maker.leading.equalTo(logo.snp.trailing).offset(12)
            maker.top.equalTo(backgroundUIView.snp.top).offset(14)
            maker.bottom.equalTo(backgroundUIView.snp.bottom).offset(-30)
        }
        
        abbreviation.snp.makeConstraints { maker in
            maker.leading.equalTo(logo.snp.trailing).offset(12)
            maker.bottom.equalTo(backgroundUIView.snp.bottom).offset(-14)
            maker.top.equalTo(backgroundUIView.snp.top).offset(38)
        }
        
        starIcon.snp.makeConstraints { maker in
            maker.leading.equalTo(name.snp.trailing).offset(6)
            maker.top.bottom.equalTo(name)
        }
        
        current_price.snp.makeConstraints { maker in
            maker.trailing.equalTo(backgroundUIView.snp.trailing).offset(-17)
            maker.top.equalTo(backgroundUIView.snp.top).offset(14)
            maker.bottom.equalTo(backgroundUIView.snp.bottom).offset(-30)
        }

        percent_price.snp.makeConstraints { maker in
            maker.bottom.trailing.equalTo(backgroundUIView).offset(-12)
            maker.top.equalTo(backgroundUIView.snp.top).offset(38)
        }
    }
    
    
    func configure(with indexPath: Int, companyName: String, companyTicker: String, currentPrice: Double, percentPrice: Double, priceChange: Double, isFavorite: Bool) {
        if indexPath % 2 == 0 {
            containerView.layer.backgroundColor = UIColor.myGrayColor.cgColor
        } else {
            containerView.layer.backgroundColor = UIColor.myWhiteColor.cgColor
        }
        name.text = companyTicker
        abbreviation.text = companyName
        
        current_price.text = String("$\(currentPrice)")
        if priceChange >= 0 {
            percent_price.text = String("+$\(priceChange) (\(percentPrice)%)")
            percent_price.textColor = .systemGreen
        } else {
            let temporary_priceChange = priceChange * -1
            let temporary_percentPrice = String(format: "%.2f", percentPrice)
            percent_price.text = String("-$\(temporary_priceChange)(\(temporary_percentPrice)%)")
            percent_price.textColor = .systemRed
        }
        if isFavorite {
            starIcon.image = UIImage(named: "favorite")
        } else {
            starIcon.image = UIImage(named: "default")
        }
    }
    
}

fileprivate extension UIColor {
    static let myGrayColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
    static let myWhiteColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    static let myDarkGrayColor = UIColor(red: 0.8, green: 0.815, blue: 0.83, alpha: 1)
}
