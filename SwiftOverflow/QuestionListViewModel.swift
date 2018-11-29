//
//  QuestionListViewModel.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

class QuestionListViewModel {
  private let network: NetworkService
  private var questions = [Question]()
  private var questionCount = 0
  
  init(networkService: NetworkService) {
    self.network = networkService
  }
  
  func fetchInitialQuestions(completion: @escaping (Error?) -> Void) {
    network.getSwiftQuestions { (result, error) in
      if let error = error {
        DispatchQueue.main.async {
          completion(error)
        }
        return
      }
      self.questions = result?.questions ?? []
      self.questionCount = result?.total ?? 0
      DispatchQueue.main.async {
        completion(nil)
      }
    }
  }
  
  var numberOfQuestions: Int {
    return questionCount
  }
  
  func question(forRow row: Int) -> Question {
    return questions[row]
  }
}
