import UIKit

class ViewController: UIViewController {

    private var characters: [Result] = []
    private var currentPage = 2
    private var isLoading = false

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CardCollectionCellCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        return cv
    }()

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "rickAndMortyBackground") // Arkaplan olarak kullanılacak görüntüyü ekleyin
        imageView.contentMode = .scaleAspectFill // Görüntüyü doldurma modunu ayarlayın
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupCollectionView()
        fetchCharacterData()
    }

    func setupBackground() {
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear // UICollectionView'ın arkaplanını temizleyin
    }

    func fetchCharacterData() {
        guard !isLoading else { return }

        isLoading = true
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(currentPage)") else {
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching character data: \(error?.localizedDescription ?? "Unknown error")")
                self?.isLoading = false
                return
            }

            do {
                let decoder = JSONDecoder()
                
                let characterData = try decoder.decode(Character.self, from: data)
                self?.characters += characterData.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.isLoading = false
                    self?.currentPage += 1
                }
            } catch {
                print("Error decoding character data: \(error.localizedDescription)")
                if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                    
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        self?.isLoading = false
                        self?.currentPage += 1
                    }
                }
                self?.isLoading = false
            }
        }.resume()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CardCollectionCellCollectionViewCell

        let character = characters[indexPath.item]
        cell.configure(with: character)

        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 8
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = characters.count - 1
        if indexPath.row == lastElement {
            fetchCharacterData()
        }
    }
}
