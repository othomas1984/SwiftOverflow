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
  let network = NetworkService()
  lazy var viewModel: QuestionListViewModel = {
    return QuestionListViewModel(networkService: network)
  }()
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated);
    super.viewWillDisappear(animated)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    
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
    let question = viewModel.question(forRow: indexPath.row)
    cell.viewModel = QuestionListCellViewModel(question: question, networkService: network)
    return cell
  }
}

extension QuestionListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.isSelected = false
  }
}
