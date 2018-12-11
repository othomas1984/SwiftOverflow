//
//  Models.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation.NSURL

enum ModelError: Error {
  case noItemsFound
}

#warning("Split each model into it's own file. Makes them easier to find and digest")
struct QuestionSearchResult: Decodable {
  let questions: [Question]
  let hasMore: Bool
  let total: Int
  
  enum CodingKeys: String, CodingKey {
    case items, hasMore, total
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    questions = try values.decode([Question].self, forKey: .items)
    hasMore = try values.decode(Bool.self, forKey: .hasMore)
    total = try values.decode(Int.self, forKey: .total)
  }
}

struct Question: Decodable {
  let id: Int
  let title: String
  let body: String?
  let owner: Owner
  let answerCount: Int
  let answers: [Answer]
  
  enum CodingKeys: String, CodingKey {
    case questionId, title, bodyMarkdown, owner, answerCount, answers
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .questionId)
    title = try values.decode(String.self, forKey: .title)
    body = try values.decodeIfPresent(String.self, forKey: .bodyMarkdown)
    owner = try values.decode(Owner.self, forKey: .owner)
    answerCount = try values.decode(Int.self, forKey: .answerCount)
    answers = try values.decodeIfPresent([Answer].self, forKey: .answers) ?? []
  }
}

struct QuestionDetail: Decodable {
  let id: Int
  let title: String
  let body: String
  let owner: Owner
  let answers: [Answer]
  
  enum CodingKeys: String, CodingKey {
    case questionId, title, bodyMarkdown, owner, answers
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .questionId)
    title = try values.decode(String.self, forKey: .title)
    body = try values.decode(String.self, forKey: .bodyMarkdown)
    owner = try values.decode(Owner.self, forKey: .owner)
    answers = try values.decodeIfPresent([Answer].self, forKey: .answers) ?? []
  }
}

struct QuestionResult: Decodable {
  let questionDetail: QuestionDetail
  
  enum CodingKeys: String, CodingKey {
    case items
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    guard let item = try values.decode([QuestionDetail].self, forKey: .items).first else {
      throw ModelError.noItemsFound
    }
    questionDetail = item
  }
}

struct Answer: Decodable {
  let body: String
  let owner: Owner
  
  enum CodingKeys: String, CodingKey {
    case bodyMarkdown, owner
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    body = try values.decode(String.self, forKey: .bodyMarkdown)
    owner = try values.decode(Owner.self, forKey: .owner)
  }
}

struct Owner: Decodable {
  let name: String
  let imageURL: URL?
  
  enum CodingKeys: String, CodingKey {
    case displayName, profileImage
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .displayName)
    imageURL = try values.decodeIfPresent(URL.self, forKey: .profileImage)
  }
}
