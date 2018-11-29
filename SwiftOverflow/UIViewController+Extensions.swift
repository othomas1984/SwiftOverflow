//
//  UIViewController+Extensions.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

extension UIViewController {
  func displayGenericAlert(title: String?, message: String?) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    present(ac, animated: true)
  }
}
