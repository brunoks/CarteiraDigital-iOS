//
//  Brunofire.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 19/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import Foundation

struct BrunoFire {
    
    enum HTTPmethod: String {
        case post
        case get
    }
    
    static func requestPayment(_ urlstring: String, method: HTTPmethod = .get, parameters: [String:Any] = [:], headers: [String:String] = [:], completed: @escaping (_ erro: Error?,_ success: Data?) ->()) {
        
        let url = URL(string: urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        debugPrint("URL:", urlstring)
        debugPrint("PARAMETROS:", parameters)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if headers.count > 0 {
            request.allHTTPHeaderFields = headers
        }
        
        if parameters.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                completed(error, nil)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completed(error, nil)
                return
            }
            guard let data = data else {
                completed(error, nil)
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                debugPrint(json)
            }
            completed(nil,data)
        }
        task.resume()
    }
    
    static func requestPayment<T: Decodable>(_ urlstring: String, method: HTTPmethod = .get, parameters: [String:Any] = [:], headers: [String:String] = [:], completed: @escaping (_ erro: Error?,_ success: T?) ->()) {
        
        let url = URL(string: urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        debugPrint("URL:", urlstring)
        debugPrint("PARAMETROS:", parameters)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if headers.count > 0 {
            request.allHTTPHeaderFields = headers
        }
        
        if parameters.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                completed(error, nil)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completed(error, nil)
                return
            }
            guard let data = data else {
                completed(error, nil)
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                debugPrint(json)
            }
            
            let feed = try? JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completed(nil, feed)
            }
        }
        task.resume()
    }
    
    static func request<I: Decodable>(_ urlstring: String, method: HTTPmethod = .get, parameters: [String:Any] = [:], headers: [String:String] = [:], completed: @escaping (_ erro: Error?,_ success: Array<I>?) ->()) {
        
        let url = URL(string: urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        debugPrint("URL:", urlstring)
        debugPrint("PARAMETROS:", parameters)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if headers.count > 0 {
            request.allHTTPHeaderFields = headers
        }
        
        if parameters.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                completed(error, nil)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let erro = error {
                completed(erro, nil)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                debugPrint(json)
                let feed = try JSONDecoder().decode(Array<I>.self, from: data)
                DispatchQueue.main.async {
                    completed(nil, feed)
                }
            } catch let error {
                completed(error, nil)
            }
        }
        task.resume()
    }
    
    static func request<I: Decodable>(_ urlstring: String, method: HTTPmethod = .get, parameters: [String:Any] = [:], headers: [String:String] = [:], completed: @escaping (_ erro: Error?,_ success: I?) ->()) {
        
        let url = URL(string: urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        debugPrint("URL:", urlstring)
        debugPrint("PARAMETROS:", parameters)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if headers.count > 0 {
            request.allHTTPHeaderFields = headers
        }
        
        if parameters.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                completed(error, nil)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let erro = error {
                completed(erro, nil)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                debugPrint(json)
                let feed = try JSONDecoder().decode(I.self, from: data)
                DispatchQueue.main.async {
                    completed(nil, feed)
                }
            } catch let error {
                completed(error, nil)
            }
        }
        task.resume()
    }
}
