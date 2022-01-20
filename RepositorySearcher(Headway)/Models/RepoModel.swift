//
//  RepoModel.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import Foundation

struct RepoModel: Decodable {
    var items: [Repository]

    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct Repository: Decodable{
    let url: URL
    let name: String
    let starCount: Int

    enum CodingKeys: String, CodingKey {
        case url = "html_url"
        case name
        case starCount = "stargazers_count"
    }
}

extension Repository {
    func toPresentableRepoModel() -> PresentableRepoModel {
        return PresentableRepoModel(url: url, name: name, starCount: starCount)
    }
}







