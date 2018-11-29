//
//  NetworkService.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

class NetworkService {
  lazy var session: URLSession = {
    return URLSession(configuration: .default)
  }()
  enum NetworkError: Error {
    case urlError
    case httpError(_ statusCode: Int)
    case noData
    case requestError(_ error: Error)
    case parseError
    case improperResponseType
  }
  
  func getSwiftQuestions(page: Int? = nil, completion: @escaping (QuestionSearchResult?, Error?) -> Void) {
    var parameters = [
      "order": "desc",
      "sort": "activity",
      "intitle": "swift",
      "site": "stackoverflow",
      "pagesize": "100",
      "filter": "!.FjuenCLawfW1_a5wPDDiyLK-SNgx",
      ]
    if let page = page.map(String.init(describing: )) {
      parameters["page"] = page
    }
    let request: URLRequest
    do {
      request = try buildRequest(fromURL: "https://api.stackexchange.com/2.2/search", parameters: parameters)
    } catch {
      completion(nil, error)
      return
    }
    session.dataTask(with: request) { (data, response, error) in
      do {
        completion(try self.processResponse(data: data, response: response, error: error), nil)
      } catch {
        completion(nil, error)
      }
    }.resume()
  }
  
  func getQuestion(questionID: Int, page: Int? = nil, completion: @escaping (QuestionResult?, Error?) -> Void) {
    #warning("This filter includes answers with questions, but may have a page limit. Further research necessary.")
    var parameters = [
      "order": "desc",
      "sort": "activity",
      "site": "stackoverflow",
      "pagesize": "30",
      "filter": "!WXieGjYn8(v0Anl1u3hXPheHO(Uh43bKan7QW2Y",
      ]
    if let page = page.map(String.init(describing: )) {
      parameters["page"] = page
    }
    let request: URLRequest
    do {
      request = try buildRequest(fromURL: "https://api.stackexchange.com/2.2/questions/\(questionID)", parameters: parameters)
    } catch {
      completion(nil, error)
      return
    }
    session.dataTask(with: request) { (data, response, error) in
      do {
        completion(try self.processResponse(data: data, response: response, error: error), nil)
      } catch {
        completion(nil, error)
      }
    }.resume()
  }
  
  func imageData(for url: URL, completion: @escaping (Data?, Error?) -> Void) {
    let request = URLRequest(url: url)
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(nil, error)
        return
      }
      guard let data = data else { completion(nil, NetworkError.noData); return }
      completion(data, nil)
    }.resume()
  }
  
  private func buildRequest(fromURL url: String, parameters: [String: String]?) throws -> URLRequest {
    guard var urlComponents = URLComponents(string: url) else {
      throw NetworkError.urlError
    }
    urlComponents.queryItems = parameters?.map(URLQueryItem.init(name:value:))
    guard let url = urlComponents.url else {
      throw NetworkError.urlError
    }
    return URLRequest(url: url)
  }
  
  private func processResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) throws -> T {
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.improperResponseType }
    guard statusCode >= 200, statusCode < 300 else { throw NetworkError.httpError(statusCode) }
    guard let data = data else { throw NetworkError.noData }
    if let error = error { throw NetworkError.requestError(error) }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      print(error.localizedDescription)
      throw NetworkError.parseError
    }
  }
}
