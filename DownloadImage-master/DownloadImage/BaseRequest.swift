//
//  BaseRequest.swift
//  Examination1
//
//  Created by Nero on 10/4/20.
//  Copyright © 2020 NHK. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseRequest {
    let baseUrl = "https://jsonplaceholder.typicode.com/"
    static let shared = BaseRequest()
    
    func request<T: BaseBO>(path: String,
                                   successCompletion: @escaping ([T]) -> Void,
                                   failCompletion: (() -> Void)? = nil) {
        guard let url = URL(string: "\(baseUrl)\(path)") else {
            failCompletion?()
            return
        }
        URLSession.shared.dataTask(with: url,
                                   completionHandler:
            { (data, response, error) in
                guard let data = data,
                    error == nil,
                    let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                    failCompletion?()
                    return
                }
                let object = jsonArray.map({ Mapper<T>().map(JSON: $0) ?? nil }).filter({ $0 != nil }) as? [T] ?? []
                successCompletion(object)
        }).resume()
    }
    
    func downloadImage(from url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else { return }
            completion(data)
        }).resume()
    }
}
