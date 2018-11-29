//
//  QuestionListViewController.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

class QuestionListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  #warning("Update this to use dependency injection from a coordinator or other architecture")
  let viewModel = QuestionListViewModel(networkService: NetworkService())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    viewModel.fetchInitialQuestions { error in
      if let error = error {
        #warning("Do something more useful when there's an error")
        self.displayGenericAlert(title: "Network Fetch Error", message: error.localizedDescription)
      }
      self.tableView.reloadData()
    }
  }
}

extension QuestionListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfQuestions
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionListCell", for: indexPath) as? QuestionListTableViewCell else { return UITableViewCell() }
    
    cell.titleLabel.text = viewModel.question(forRow: indexPath.row).title
    return cell
  }
}
