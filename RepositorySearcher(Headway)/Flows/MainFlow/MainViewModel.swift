//
//  MainViewModel.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import Foundation

class MainViewModel {

    private let mainModel: MainModel

    func doneButtonPressed(with text: String, completion: @escaping () -> Void) {
        mainModel.getRepository(with: text) { completion() }
    }

    func performPagination(completion: @escaping () -> Void) {
        mainModel.getAdditionalRepository() {
            completion()
        }
    }

    func getRepository(at index: Int) -> PresentableRepoModel {
        return mainModel.repositories[index]
    }

    func getQuantityOfRepos() -> Int {
        return mainModel.repositories.count
    }

    // MARK: - Initialization

    init(mainModel: MainModel) {
        self.mainModel = mainModel
    }
}
