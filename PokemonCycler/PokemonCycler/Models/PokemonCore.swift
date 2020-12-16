import Foundation
import UIKit

class PokemonCore {
    var currentPokemonNumber = 0
    let repository: PokemonRepository = HttpPokemonRepository(devUUID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown-device")
    
    func nextPokemon(callback: @escaping (Pokemon?, UIImage?) -> Void) -> Void {
        loadPokemon(next: currentPokemonNumber + 1, callback: callback)
    }
    
    func prevPokemon(callback: @escaping (Pokemon?, UIImage?) -> Void) -> Void {
        guard currentPokemonNumber > 1 else {
            callback(nil, nil)
            return
        }
        loadPokemon(next: currentPokemonNumber - 1, callback: callback)
    }
    
    func catchPokemon(callback: @escaping (Pokemon?, UIImage?) -> Void) -> Void {
        repository.catchPokomonByNumber(num: currentPokemonNumber) {
            [weak self] pokemon in
            
            guard let pokemon = pokemon else {
                callback(nil, nil)
                return
            }
            guard let self = self else {
                callback(nil, nil)
                return
            }
            if self.detrmineIfCaught(pokemon: pokemon) {
                self.repository.getImageByNumber(num: self.currentPokemonNumber) {
                    image in
                    callback(pokemon, image)
                }
            } else {
                self.repository.getThumnailByNumber(num: self.currentPokemonNumber) {
                    image in
                    callback(pokemon, image)
                }
            }
        }
    }
    
    private func loadPokemon(next: Int ,callback: @escaping (Pokemon?, UIImage?) -> Void) {
        repository.getPokemonByNumber(num: next) {
            [weak self] pokemon in
            
            guard let pokemon = pokemon else {
                callback(nil, nil)
                return
            }
            guard let self = self else {
                callback(nil, nil)
                return
            }
            self.currentPokemonNumber = next
            if self.detrmineIfCaught(pokemon: pokemon) {
                self.repository.getImageByNumber(num: next) {
                    image in
                    callback(pokemon, image)
                }
            } else {
                self.repository.getThumnailByNumber(num: next) {
                    image in
                    callback(pokemon, image)
                }
            }
        }
    }
    
    private func detrmineIfCaught(pokemon: Pokemon) -> Bool {
        return pokemon.name == "Unknown"
    }
}
