//
//  NetworkingManager.swift
//  CryptoTrackerTutorial
//
//  Created by Фёдор Ткаченко on 17.11.21.
//

import Foundation
import Combine

class NetworkingManager {
  enum NetworkingError: LocalizedError {
    case badUrlResponse(url: URL), unknown, badCoreDataResponse(error: Error), badResponse(error: Error)
    
    var errorDescription: String? {
      switch self {
      case .badUrlResponse(url: let url):
        return "[🔥] Bad response from url: \(url)"
      case .badCoreDataResponse(error: let error):
        return "[⚡️] Error loading core data: \(error)"
      case .badResponse(error: let error):
        return "[⚡️] Error loading data: \(error)"
      case .unknown:
        return "[⚠️] Unknown error occured"
      }
    }
  }
  
  static func download(url: URL, onError: ( () -> Void)? = nil) -> AnyPublisher<Data, Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
//      .subscribe(on: DispatchQueue.global(qos: .default)) goes to background thread automatically
      .tryMap({ try self.handleUrlResponse(output: $0, url: url, onError: onError) })
//      .receive(on: DispatchQueue.main) switch to main thread after decoding to not overwhelm
      .retry(3)
      .eraseToAnyPublisher()
  }
  
  static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output, url: URL, onError: ( () -> Void)? = nil) throws -> Data {
    guard let response = output.response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
            if let onError = onError {
              onError()
            }

            throw NetworkingError.badUrlResponse(url: url)
          }
    
    return output.data
  }
  
  static func receiveCompletion(completion: (Subscribers.Completion<Error>)) -> Void {
    switch completion {
    case .finished:
      break
    case .failure(let error):
      print(error.localizedDescription)
      break
    }
  }
}
