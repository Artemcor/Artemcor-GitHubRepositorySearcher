//
//  MainFlowCoordinator.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import UIKit

class MainFlowCoordinator {

    func buildMainViewController() -> UINavigationController {
        let apiService = APIService()
        let persistanceService = PersistanceService()
        let mainModel = MainModel(apiService: apiService, persistanceService: persistanceService)
        let mainViewModel = MainViewModel(mainModel: mainModel)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNavigationViewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationViewController") as! UINavigationController
        let mainViewController = mainNavigationViewController.viewControllers[0] as! MainViewController
        mainViewController.mainViewModel = mainViewModel
        return mainNavigationViewController
    }

    func buildRepoWebPageController() -> WebPageRepoController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webPageController = storyboard.instantiateViewController(withIdentifier: "RepoWebPageController") as! WebPageRepoController
        return webPageController
    }
}


