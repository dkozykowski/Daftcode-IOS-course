import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var bottomRect: UIView!
    @IBOutlet weak var upperRect: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonNumberLabel: UILabel!
    @IBOutlet weak var pokemonImageImageView: UIImageView!
    let pokemonData = PokemonCore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTapHandler))
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapHandler))
        doubleTap.numberOfTapsRequired = 1
        doubleTap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
    }
    
    func setupView() {
        updateSpinnerState(true)
        pokemonData.nextPokemon(callback: updateView(_:_:))
    }
    
    @objc func onSingleTapHandler() {
        updateSpinnerState(true)
        pokemonData.nextPokemon(callback: updateView(_:_:))
    }
    
    @objc func onDoubleTapHandler() {
        updateSpinnerState(true)
        pokemonData.prevPokemon(callback: updateView(_:_:))
    }
    
    @objc func onSwipeUp() {
        updateSpinnerState(true)
        pokemonData.catchPokemon(callback: updateView(_:_:))
    }
    
    func updateView(_ currentPokemon: Pokemon?, _ pokemonImage: UIImage?) {
        guard let currentPokemon = currentPokemon else { return }
        guard let pokemonImage = pokemonImage else { return }
        nameLabel.text = currentPokemon.name
        pokemonNumberLabel.text = String(currentPokemon.number)
        pokemonImageImageView.image = pokemonImage
        view.backgroundColor = UIColor(hex: currentPokemon.color)
        upperRect.backgroundColor = UIColor(hex: currentPokemon.color).darkenColor()
        bottomRect.backgroundColor = UIColor(hex: currentPokemon.color).darkenColor()
        nameLabel.textColor = UIColor(hex: currentPokemon.color).darkenColor()
        pokemonNumberLabel.textColor = UIColor(hex: currentPokemon.color).darkenColor()
        updateSpinnerState(false)
    }
    
    func updateSpinnerState(_ state: Bool) {
        switch(state) {
        case true: spinner.startAnimating()
        case false: spinner.stopAnimating()
        }
    }
}

