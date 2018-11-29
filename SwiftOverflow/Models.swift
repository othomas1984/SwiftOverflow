//
//  Models.swift
//  SwiftOverflow
//
//  Created by Owen Thomas on 11/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation.NSURL

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
  let body: String
  let owner: Owner
  let answers: Int
  
  enum CodingKeys: String, CodingKey {
    case questionId, title, bodyMarkdown, owner, answerCount
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .questionId)
    title = try values.decode(String.self, forKey: .title)
    body = try values.decode(String.self, forKey: .bodyMarkdown)
    owner = try values.decode(Owner.self, forKey: .owner)
    answers = try values.decode(Int.self, forKey: .answerCount)
  }
}

struct AnswerSearchResult: Decodable {
  let answers: [Answer]
  let hasMore: Bool
  let total: Int
  
  enum CodingKeys: String, CodingKey {
    case items, hasMore, total
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    answers = try values.decode([Answer].self, forKey: .items)
    hasMore = try values.decode(Bool.self, forKey: .hasMore)
    total = try values.decode(Int.self, forKey: .total)
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
  let imageURL: URL
  
  enum CodingKeys: String, CodingKey {
    case displayName, profileImage
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .displayName)
    imageURL = try values.decode(URL.self, forKey: .profileImage)
  }
}
