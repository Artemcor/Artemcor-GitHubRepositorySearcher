//
//  Extensions.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import Foundation

let dataSaveNotification = Notification.Name(rawValue: "DataSaveNotification")

extension URL {
    static let searchRepoURLString: String = "https://api.github.com/search/repositories?"
    static let sortString: String = "&sort=stars&order=desc"
    static let pageString: String = "&page="
}
