//
//  MainModel.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import Foundation

class MainModel {

    var paginationModel: RepoPaginationModel
    var repositories:[PresentableRepoModel]
    private let apiService: APIService
    private let persistanceService: PersistanceService

    func getRepository(with nameOfRepository: String, comletion: @escaping () -> Void) {
        let pageNumber = countPagination(for: nameOfRepository)

        apiService.getJSON(urlString: URL.searchRepoURLString + "q=\(nameOfRepository)" + URL.sortString + URL.pageString + String(pageNumber)) { [self] (result: Result<RepoModel, APIError>) -> Void in
            switch result {
            case .success(let repos):
                if pageNumber == 1 && !repositories.isEmpty {
                    repositories = []
                    repositories.append(contentsOf: repos.items.map { $0.toPresentableRepoModel() })
                } else {
                    repositories.append(contentsOf: repos.items.map { $0.toPresentableRepoModel() })
                }
                comletion()
            case .failure(let error):
                print(error.localizedDescription)
                paginationModel.counter -= 1
                comletion()
            }
        }
    }

    private func countPagination(for repoName: String) -> Int {
        var pageNumber: Int
        if paginationModel.name == "" {
            paginationModel.name = repoName
            pageNumber = 1
        } else if paginationModel.name == repoName {
            paginationModel.counter += 1
            pageNumber = paginationModel.counter
        } else {
            paginationModel.name = repoName
            repositories = []
            paginationModel.counter = 1
            pageNumber = 1
        }
        return pageNumber
    }

    func getAdditionalRepository(comletion: @escaping () -> Void) {
        getRepository(with: paginationModel.name, comletion: comletion)
    }

    func listenSaveNotifications() {NotificationCenter.default.addObserver(forName: dataSaveNotification, object: nil, queue: OperationQueue.main ) { _ in
        self.persistanceService.saveRepositories(repos: self.repositories)
        self.persistanceService.saveRepoPaginationModel(repo: self.paginationModel)
        }
    }

    //MARK: - Initialization

    init(apiService: APIService, persistanceService: PersistanceService) {
        self.apiService = apiService
        self.persistanceService = persistanceService
        if let repos = persistanceService.loadRepositories() {
            repositories = repos
        } else {
            repositories = []
        }
        if let repo = persistanceService.loadRepoPaginationModel() {
            paginationModel = repo
        } else {
            paginationModel = RepoPaginationModel()
        }
        listenSaveNotifications()
    }
}
