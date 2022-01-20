//
//  MainViewController.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 17.01.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var repositoryTextField: UITextField!
    @IBOutlet private weak var repositoryTableView: UITableView!
    @IBOutlet private weak var mainSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var paginationSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var unsuccessFindingTtitle: UILabel!

    var mainViewModel: MainViewModel!
    private var isPaginationAllowed = false

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryTableView.backgroundColor = .systemGray5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        repositoryTextField.becomeFirstResponder()
    }

    //MARK: - Helper Methods

    private func configureUIElements(afterRequest bool: Bool) {
        if bool {
            mainSpinner.stopAnimating()
            if mainViewModel.getQuantityOfRepos() == 0 {
                unsuccessFindingTtitle.text = "Nothing Found"
                repositoryTableView.backgroundColor = .systemGray5
            }
        } else {
            mainSpinner.startAnimating()
            unsuccessFindingTtitle.text = ""
        }
    }

    private func configureRepoTableView() {
        DispatchQueue.main.async {
            self.repositoryTableView.reloadData()
            self.configureUIElements(afterRequest: true)
            self.paginationSpinner.stopAnimating()
        }
    }

    private func configureCheckmark(for cell: UITableViewCell, with item: PresentableRepoModel) {
        if item.isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

extension MainViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.hasText {
            configureUIElements(afterRequest: false)
            mainViewModel.doneButtonPressed(with: textField.text!) {
                self.configureRepoTableView()
            }
        }
        return true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.getQuantityOfRepos()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GitCell", for: indexPath)
        let repo = mainViewModel.getRepository(at: indexPath.row)
        configureCheckmark(for: cell, with: repo)
        cell.textLabel?.text = "\(indexPath.row + 1). \(repo.name))"
        cell.detailTextLabel?.text = "✮\(repo.starCount)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = mainViewModel.getRepository(at: indexPath.row)
        let cell = repositoryTableView.cellForRow(at: indexPath)!
        cell.isSelected = false
        repo.isSelected = true
        configureCheckmark(for: cell, with: repo)
        let url = repo.url
        let webPageController = MainFlowCoordinator().buildRepoWebPageController()
        webPageController.url = url
        navigationController?.pushViewController(webPageController, animated: true)
    }
}

extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let numberOfRepo = mainViewModel.getQuantityOfRepos()
        if position > (repositoryTableView.contentSize.height + 100 - scrollView.frame.size.height), isPaginationAllowed == false, numberOfRepo > 0 {
            paginationSpinner.startAnimating()
            isPaginationAllowed = true
            mainViewModel.performPagination() {
                self.configureRepoTableView()
                self.isPaginationAllowed = false
            }
        }
    }
}
