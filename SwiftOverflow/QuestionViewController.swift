//
//  QuestionViewController.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
  #warning("Replace the implicit unwrap with an initializer once the segue is replaced by a better architecture")
  var viewModel: QuestionViewModel!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var answerCountLabel: UILabel!
  @IBOutlet weak var authorNameLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetchDetail { error in
      if let error = error {
        #warning("Do something more useful when there's an error")
        self.displayGenericAlert(title: "Network Fetch Error", message: error.localizedDescription)
      }
      self.updateUI()

      self.tableView.reloadData()
    }
  }
  
  private func updateUI() {
    titleLabel.text = viewModel.title
    answerCountLabel.text = viewModel.answers
    authorNameLabel.text = viewModel.authorName
    bodyLabel.text = viewModel.body
    viewModel.authorProfileImageData { (data, error) in
      guard let data = data, error == nil else {
        #warning("Show an image of a failed download")
        return
      }
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        self.profileImageView.image = image
      }
    }
  }
}
