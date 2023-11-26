import UIKit

class CardCollectionCellCollectionViewCell: UICollectionViewCell {
    var characterImageView: UIImageView!
    var nameLabel: UILabel!
    var locationLabel: UILabel!

    var isFlipped = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupTapGesture()

        // UI özelliklerini burada da ayarla
        layer.borderWidth = 4
        layer.borderColor = UIColor(hex: 0x363062).cgColor
        layer.cornerRadius = 10
        characterImageView.layer.cornerRadius = 10
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupTapGesture()

        // UI özelliklerini burada da ayarla
        layer.borderWidth = 4
        layer.borderColor = UIColor(hex: 0x363062).cgColor
        layer.cornerRadius = 10
        characterImageView.layer.cornerRadius = 10
    }

    private func setupViews() {
        characterImageView = UIImageView()
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.clipsToBounds = true
        addSubview(characterImageView)

        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        addSubview(nameLabel)

        locationLabel = UILabel()
        addSubview(locationLabel)
        locationLabel.textAlignment = .center
        // İlk başta kart düz olacak şekilde görüntüleniyor
        updateViewState()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    func configure(with character: Result) {
        nameLabel.text = character.name
        nameLabel.textColor = .cyan
        nameLabel.font = UIFont(name: "GetSchwifty-Regular", size: 19)
        nameLabel.numberOfLines = 2
        
        locationLabel.text = character.location.name
        locationLabel.textColor = .orange
        locationLabel.font = UIFont(name: "GetSchwifty-Regular", size: 16)
        locationLabel.numberOfLines = 2
        
        // statusLabel.text = "Status: \(character.status.rawValue)" // Status label'ını şu an için göstermiyorum

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
    }

    private func updateViewState() {
        nameLabel.isHidden = !isFlipped
        locationLabel.isHidden = !isFlipped
        characterImageView.isHidden = isFlipped
    }

    @objc private func handleTap() {
        isFlipped.toggle()
        UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
            self.updateViewState()
        }, completion: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let labelHeight: CGFloat = 50.0
        let verticalPadding: CGFloat = 8.0
        let horizontalPadding: CGFloat = 16.0 // Sağ ve sol boşluk

        nameLabel.frame = CGRect(x: horizontalPadding, y: bounds.height / 2 - labelHeight - verticalPadding, width: bounds.width - 2 * horizontalPadding, height: labelHeight)
        locationLabel.frame = CGRect(x: horizontalPadding, y: bounds.height / 2 + verticalPadding, width: bounds.width - 2 * horizontalPadding, height: labelHeight)

        characterImageView.frame = bounds
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
