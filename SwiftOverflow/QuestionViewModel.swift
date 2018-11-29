//
//  QuestionViewModel.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

class QuestionViewModel {
  private let network: NetworkService
  private let question: Question
  private var detail: QuestionDetail?
  
  init(question: Question, networkService: NetworkService) {
    self.question = question
    network = networkService
  }
  
  func fetchDetail(completion: @escaping (Error?) -> Void) {
    network.getQuestion(questionID: question.id) { (result, error) in
      if let error = error {
        DispatchQueue.main.async {
          completion(error)
        }
        return
      }
      self.detail = result?.questionDetail
      DispatchQueue.main.async {
        completion(nil)
      }
    }
  }
  
  var title: String {
    return detail?.title ?? question.title
  }
  
  var answers: String {
    return "Answers: \(detail?.answers.count ?? question.answerCount)"
  }
  
  var authorName: String {
    return detail?.owner.name ?? question.owner.name
  }
  
  var body: String? {
    return detail?.body
  }
  
  func authorProfileImageData(completion: @escaping (Data?, Error?) -> Void) {
    network.imageData(for: detail?.owner.imageURL ?? question.owner.imageURL, completion: completion)
  }

}
