import Foundation
import UIKit

protocol PokemonRepository {
    func getPokemonByNumber(num: Int, complete: @escaping (Pokemon?) -> Void) -> Void
    func getThumnailByNumber(num: Int, complete: @escaping (UIImage?) -> Void) -> Void
    func getImageByNumber(num: Int, complete: @escaping (UIImage?) -> Void) -> Void
    func catchPokomonByNumber(num: Int, complete: @escaping (Pokemon?) -> Void) -> Void
}

class HttpPokemonRepository : PokemonRepository {
    private let baseUrlString = "https://switter.app.daftmobile.com/api/"
    private let session: URLSession
    private let uuid: String
    
    init(devUUID: String) {
        uuid = devUUID
        session = URLSession(configuration: .ephemeral)
    }
    
    
    
    func getPokemonByNumber(num: Int, complete: @escaping (Pokemon?) -> Void) -> Void {
        session.dataTask(with: getPokemonByumberRequestFactory(number: num)) { data, _, error in
            var pokemon: Pokemon? = nil
            defer {
                DispatchQueue.main.async {
                    complete(pokemon)
                }
            }
            guard error == nil else { print(error!); return }
            guard let data = data else { print("Invalid data"); return }
            pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
        }.resume()
    }
    
    func getImageByNumber(num: Int, complete: @escaping (UIImage?) -> Void) -> Void {
        session.dataTask(with: getPokemonImageByumberRequestFactory(number: num)) { data, _, error in
            var pokemonImage: UIImage? = nil
            defer {
                DispatchQueue.main.async {
                    complete(pokemonImage)
                }
            }
            guard error == nil else { print(error!); return }
            guard let data = data else { print("Invalid data"); return }
            pokemonImage = UIImage(data: data)
        }.resume()
    }
    
    func getThumnailByNumber(num: Int, complete: @escaping (UIImage?) -> Void) -> Void {
        session.dataTask(with: getPokemonThumbnailByumberRequestFactory(number: num)) { data, _, error in
            var pokemonThumbnail: UIImage? = nil
            defer {
                DispatchQueue.main.async {
                    complete(pokemonThumbnail)
                }
            }
            guard error == nil else { print(error!); return }
            guard let data = data else { print("Invalid data"); return }
            pokemonThumbnail = UIImage(data: data)
        }.resume()
    }
    
    func catchPokomonByNumber(num: Int, complete: @escaping (Pokemon?) -> Void) -> Void {
        session.dataTask(with: catchPokemonByumberRequestFactory(number: num)) { data, _, error in
            var pokemon: Pokemon? = nil
            defer {
                DispatchQueue.main.async {
                    complete(pokemon)
                }
            }
            guard error == nil else { print(error!); return }
            guard let data = data else { print("Invalid data"); return }
            pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
        }.resume()
    }
    
    private func getPokemonByumberRequestFactory(number: Int) -> URLRequest {
        let url = URL(string: "\(baseUrlString)/pokemon/\(number)")!
        var request = URLRequest(url: url)
        request.addValue(uuid, forHTTPHeaderField: "x-device-uuid")
        return request
    }
    
    private func getPokemonImageByumberRequestFactory(number: Int) -> URLRequest {
        let url = URL(string: "\(baseUrlString)/pokemon/\(number)/image")!
        var request = URLRequest(url: url)
        request.addValue(uuid, forHTTPHeaderField: "x-device-uuid")
        return request
    }

    private func getPokemonThumbnailByumberRequestFactory(number: Int) -> URLRequest {
        let url = URL(string: "\(baseUrlString)/pokemon/\(number)/thumbnail")!
        var request = URLRequest(url: url)
        request.addValue(uuid, forHTTPHeaderField: "x-device-uuid")
        return request
    }

    private func catchPokemonByumberRequestFactory(number: Int) -> URLRequest {
        let url = URL(string: "\(baseUrlString)/pokemon/\(number)/catch")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(uuid, forHTTPHeaderField: "x-device-uuid")
        return request
    }

}

