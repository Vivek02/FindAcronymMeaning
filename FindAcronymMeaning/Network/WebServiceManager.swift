//
//  WebManager.swift
//  FindAcronymMeaning
//
//  Created by TCS on 11/07/23.
//

import Foundation

class WebServiceManager {
    
    static let shared = WebServiceManager();
    
    enum ServerErrors: Error {
        
        case invalidResponse
        case invalidStatusCode(Int)
    }
    
    enum HttpMethod: String {
        case get
        case post
        case delete
        case patch
        var method: String { rawValue.uppercased() }
    }
    
    func webServiceRequest<T: Decodable>(resourceName: String = "Products", fromURL url: URL, httpMethod: HttpMethod = .get, completion: @escaping (Result<T?, Error>) -> Void) {
        
        let completionOnMain: (Result<T?, Error>) -> Void = { result in
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        //as per TCS policy we can't use external URL so we parse Mock data
        let isMock = false
        if(isMock) {
            do {
                // creating a path from the main bundle and getting data object from the path
                guard let bundlePath = Bundle.main.path(forResource: resourceName, ofType: "json"),
                      let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
                    completionOnMain(.failure(ServerErrors.invalidResponse))
                    return
                }
                // Decoding the Product type from JSON data using JSONDecoder() class.
                let product = try JSONDecoder().decode(T.self, from: jsonData)
                completionOnMain(.success(product))
                
            } catch {
                completionOnMain(.failure(error))
            }
        } else {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.method
            
            let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    completionOnMain(.failure(error))
                    return
                }
                
                guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(ServerErrors.invalidResponse)) }
                
                if !(200..<300).contains(urlResponse.statusCode) {
                    return completionOnMain(.failure(ServerErrors.invalidStatusCode(urlResponse.statusCode)))
                    
                }
                guard let data = data else { return }
                
                do {
                    let product = try JSONDecoder().decode(T.self, from: data)
                    completionOnMain(.success(product))
                    
                } catch {
                    completionOnMain(.failure(error))
                }
            }
            urlSession.resume()
        }
    }
    
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(
            .useCredential,
            URLCredential(trust: challenge.protectionSpace.serverTrust!)
        )
        
    }
}
