//
//  ViewController.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let network = NetworkService()
    network.getSwiftQuestions { (result, error) in
      if let firstAnsweredQuestion = result?.questions.first(where: { $0.answers > 5 }) {
        network.getAnswers(questionID: firstAnsweredQuestion.id) { (result, error) in
          print(result?.answers.count)
          print(result?.answers.first?.owner.name)
        }
      }
      print(result?.questions.count)
      print(result?.questions.first?.owner.name)
    }
  }
}
