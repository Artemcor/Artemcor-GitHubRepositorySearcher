//
//  PersistanceServise.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import Foundation

struct PersistanceService {

    private func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func dataFilePathForRepos() -> URL {
        return documentDirectory().appendingPathComponent("Repositories.plist")
    }

    private func dataFilePathForPaginationModel() -> URL {
        return documentDirectory().appendingPathComponent("PaginationModel.plist")
    }

    func saveRepositories(repos: [PresentableRepoModel]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(repos)
            try data.write(to: dataFilePathForRepos(), options: .atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }

    func loadRepositories() -> [PresentableRepoModel]? {
        let path = dataFilePathForRepos()

        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                let repos = try decoder.decode([PresentableRepoModel].self, from: data)
                return repos
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
        return nil
    }

    func saveRepoPaginationModel(repo: RepoPaginationModel) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(repo)
            try data.write(to: dataFilePathForPaginationModel(), options: .atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }

    func loadRepoPaginationModel() -> RepoPaginationModel? {
        let path = dataFilePathForPaginationModel()

        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                let repos = try decoder.decode(RepoPaginationModel.self, from: data)
                return repos
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
