//
//  HttpClient.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import RxSwift

final class NetworkClient {
    typealias Parameters = [String: String]
    var baseURL: URL?
    
    init(baseUrlString: String) {
        self.baseURL = URL(string: baseUrlString)
    }
    
    // MARK: - Generic GET
    func get<T: Decodable>(_ type: T.Type,
                           _ urlString: String,
                           parameters: Parameters = [:],
                           printURL: Bool = false)
        -> Observable<(T?, Error?)> {
            
            print("")
            return Observable.create { [unowned self] observer in
                
                guard let url = URL(string: urlString,
                                    relativeTo: self.baseURL) else {
                    observer.onNext((nil, NetworkError.invalidURL))
                    return Disposables.create()
                }
                guard var urlComponents = URLComponents(string: url.absoluteString) else {
                    observer.onNext((nil, NetworkError.invalidURL))
                    return Disposables.create()
                }
                
                if !parameters.isEmpty {
                    urlComponents.queryItems = parameters.compactMap {
                        URLQueryItem(name: $0.key, value: $0.value)
                    }
                }
                
                let urlRequest = URLRequest(url: urlComponents.url!)
                
//                urlRequest.addValue("application/json",
//                                    forHTTPHeaderField: "Content-Type")
                
                print(urlRequest.url!.absoluteString)
                
                let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    guard let data = data,
                        let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                            if let error = error {
                                observer.onNext((nil, error))
                            } else {
                                observer.onNext((nil, NetworkError.unknown))
                            }
                            return
                    }
                    guard let string = String(data: data, encoding: String.Encoding.isoLatin1) else { return }
                    guard let properData = string.data(using: .utf8, allowLossyConversion: true) else { return }
                    do {
                        let model = try JSONDecoder().decode(type, from: properData)
                        observer.onNext((model, nil))
                    } catch {
                        print(error)
                        observer.onNext((nil, NetworkError.decodingFailed))
                    }
                    
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
    }

    // MARK: - Basic GET Data
    /// This method does not depend on the baseURL property, so it makes sense to use it without instantiating the NetworkClient
    static func getData(_ url: URL, printURL: Bool = false) -> Observable<(Data?, Error?)> {
        return Observable.create { observer in
            
            if printURL {
                print(url.absoluteString)
            }
            
            let session = URLSession(configuration: .ephemeral)
                
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                        if let error = error {
                            observer.onNext((nil, error))
                        } else {
                            observer.onNext((nil, NetworkError.unknown))
                        }
                        return
                }
                
                observer.onNext((data, nil))
            }
            
            task.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
}
