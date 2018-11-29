//
//  QuestionListTableViewCell.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

class QuestionListTableViewCell: UITableViewCell {
  var viewModel: QuestionListCellViewModel? {
    didSet {
      guard let viewModel = viewModel else {
        profileImageView.image = nil
        return
      }
      titleLabel.text = viewModel.title
      answerCountLabel.text = viewModel.answers
      authorNameLabel.text = viewModel.authorName
      #warning("Add a cache in here, this will redownload the image each time depending on the server's cache settings")
      viewModel.authorProfileImageData { (data, error) in
        guard let data = data, error == nil else {
          #warning("Show an image of a failed download")
          return
        }
        let image = UIImage(data: data)
        DispatchQueue.main.async {
          #warning("check to make sure the cell hasn't been reused since the network request was initiated, otherwise there may be a race")
          self.profileImageView.image = image
        }
      }
    }
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var answerCountLabel: UILabel!
  @IBOutlet weak var authorNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImageView.layer.cornerRadius = 4
    profileImageView.layer.masksToBounds = true
  }
  
  override func prepareForReuse() {
    viewModel = nil
  }
}
