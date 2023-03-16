//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Антон Шалимов on 15.03.2023.
//

import Foundation
import UIKit

class PhotoInfoController {
    
    enum PhotoInfoError: Error, LocalizedError {
        case itemNotFound
        case photoNotFound
    }
    
    func fetchPhotoImage(from url: URL) async throws -> UIImage {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PhotoInfoError.photoNotFound
        }
        
        guard let receivedImage = UIImage(data: data) else {
            throw PhotoInfoError.photoNotFound
        }
        
        return receivedImage
    }
    
    
    func fetchPhotoInfo() async throws -> PhotoInfo {
        // Forming URL request with URLCompontnts
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY"
        ].map { URLQueryItem(name: $0.key, value: $0.value)}
        
        // Using URLSession data method to fetch data
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        // Checking that code == 200 (OK response status), if not: throwing an error
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotFound
        }
        
        // Declaring JSON decoder
        let jsonDecoder = JSONDecoder()
        
        // Decoding JSON to PhotoInfo structure
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        return photoInfo
    }
}
