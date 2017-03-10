//
//  CardController.swift
//  SnapImage
//
//  Created by Spencer Curtis on 1/9/17.
//  Copyright © 2017 Spencer Curtis. All rights reserved.
//

import Foundation

class CardController {
    
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    
    static func draw(numberOfCards: Int, completion: @escaping ((_ card: [Card]) -> Void)) {
        
        guard let url = self.baseURL else { fatalError("URL optional is nil") }
        
        let urlParameters = ["count": "\(numberOfCards)"]
        
        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
            
            guard let data = data, let responseDataString = String(data: data, encoding: .utf8) else {
                NSLog("No data returned from network request")
                completion([])
                return
            }
    
            guard let responseDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let cardsArray = responseDictionary["cards"] as? [[String: Any]] else {
                    NSLog("Unable to serialize JSON. \nResponse: \(responseDataString)")
                    return
            }
            
            let cardObjectArray = cardsArray.flatMap({Card(jsonDictionary: $0)})
            
            completion(cardObjectArray)
        }
    }
}
