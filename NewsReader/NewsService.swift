//
//  NewsService.swift
//  NewsReader
//
//  Created by Mahjeed Marrow on 5/6/19.
//  Copyright © 2019 Mahjeed Marrow. All rights reserved.
//

import UIKit

class NewsService {
    var dataTask: URLSessionDataTask?
    var alertDelegate: MasterViewController?
    
    private let urlString = "https://newsapi.org/v2/everything?q="
    //private let apiKey = [INSERT API KEY HERE]
    
    // Mark - Search function
    func search(for searchTerm: String, completion: @escaping ([News]?, Error?) -> ()) {
        
        guard let url = URL(string: urlString + searchTerm) else {
            print("invalid url: \(urlString + searchTerm)")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, error)
                }
                if error != nil {
                    //let errorMessage = "Cannot perform search. Please check your network connection."
                    //self.alertDelegate.showAlert(errorMessage)
                }
                return
            }
            print("Status code: \(response.statusCode)")
            print(String(data: data, encoding: .utf8) ?? "unable to print data")
            
            do {
                let decoder = JSONDecoder()
                let newsResult = try decoder.decode(NewsResult.self, from: data)
                DispatchQueue.main.async { completion(newsResult.articles, nil) }
            } catch (let error) {
                DispatchQueue.main.async { completion(nil, error) }
            }
            if error != nil {
                //let errorMessage = "No search results. Please double-check your query."
                //self.alertDelegate.showAlert(errorMessage)
            }
        }
        task.resume()
    }
}
