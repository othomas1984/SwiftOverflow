//
//  QuestionListCellViewModel.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

class QuestionListCellViewModel {
  private let network: NetworkService
  private let question: Question
  
  init(question: Question, networkService: NetworkService) {
    self.question = question
    self.network = networkService
  }
  
  var title: String {
    return question.title
  }
  
  var answers: String {
    return "Answers: \(question.answerCount)"
  }
  
  var authorName: String {
    return question.owner.name
  }
  
  func authorProfileImageData(completion: @escaping (Data?, Error?) -> Void) {
    #warning("Call a completion even on guard return")
    guard let url = question.owner.imageURL else { return }
    network.imageData(for: url, completion: completion)
  }
}
