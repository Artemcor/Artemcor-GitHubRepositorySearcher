//
//  PresentableRepoModel.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 19.01.2022.
//

import Foundation

class PresentableRepoModel: Codable {
    let url: URL
    let name: String
    let starCount: Int
    var isSelected: Bool

    init(url: URL, name: String, starCount: Int, isSelected: Bool = false) {
        self.url = url
        self.name = name
        self.starCount = starCount
        self.isSelected = isSelected
    }
}
