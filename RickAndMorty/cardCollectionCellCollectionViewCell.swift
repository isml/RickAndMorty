//
//  cardCollectionCellCollectionViewCell.swift
//  RickAndMorty
//
//  Created by İsmail Karakaş on 22.11.2023.
//

import UIKit

class CardCollectionCellCollectionViewCell: UICollectionViewCell {
    var characterImageView: UIImageView!
    var nameLabel: UILabel!
    var statusLabel: UILabel!
    
    var isFlipped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupTapGesture()
    }
    
    private func setupViews() {
        characterImageView = UIImageView()
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.clipsToBounds = true
        addSubview(characterImageView)
        
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        
        statusLabel = UILabel()
        statusLabel.textAlignment = .center
        //addSubview(statusLabel)
        // İlk başta kart düz olacak şekilde görüntüleniyor
        updateViewState()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with character: Result) {
        nameLabel.text = character.name
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "GetSchwifty-Regular", size: 19)
        statusLabel.text = "Status: \(character.status.rawValue)"
        
        if let imageURL = URL(string: character.image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.characterImageView.image = image
                    }
                }
            }
        }
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(hex: 0x363062).cgColor
        self.layer.cornerRadius = 10
        self.characterImageView.layer.cornerRadius = 10
    }
    
    private func updateViewState() {
        if isFlipped {
            nameLabel.isHidden = false
            statusLabel.isHidden = false
            characterImageView.isHidden = true
        } else {
            nameLabel.isHidden = true
            statusLabel.isHidden = true
            characterImageView.isHidden = false
        }
    }
    
    @objc private func handleTap() {
        isFlipped.toggle()
        UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
            self.updateViewState()
        }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.frame = bounds
        nameLabel.frame = bounds
        statusLabel.frame = bounds
    }
}
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
