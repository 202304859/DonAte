//
//  DDonorSearchViewController.swift
//  DonAte
//
//  Created by Guest 1 on 03/01/2026.
//

import UIKit

final class DDonorSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    struct Donor {
        let username: String
        let firstName: String
        let lastName: String
        let points: Int
        let avatarName: String
    }

    // Sample donors (no Firebase)
    private let donors: [Donor] = [
        Donor(username: "Chef_01",  firstName: "Manny", lastName: "Smith",   points: 10, avatarName: "ChefLogo"),
        Donor(username: "Aysha_02", firstName: "Aysha", lastName: "Ali",     points: 22, avatarName: "AyshaLogo"),
        Donor(username: "Girl_03",  firstName: "Sara",  lastName: "Hassan",  points: 5,  avatarName: "GirlLogo"),
        Donor(username: "Boy_04",   firstName: "Omar",  lastName: "Khalid",  points: 18, avatarName: "BoyLogo")
    ]

    private var filteredDonors: [Donor] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        filteredDonors = donors

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 120

        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "Search users"

        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])

        navBar.configure(style: .titleOnly(title: "Search"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func applySearch(_ text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if query.isEmpty {
            filteredDonors = donors
        } else {
            filteredDonors = donors.filter { donor in
                donor.username.lowercased().contains(query)
                || donor.firstName.lowercased().contains(query)
                || donor.lastName.lowercased().contains(query)
            }
        }

        tableView.reloadData()
    }

    private func dismissSearchKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension DDonorSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDonors.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SavedCollectorCell",
            for: indexPath
        ) as! SavedCollectorCell

        let item = filteredDonors[indexPath.row]
        let img = UIImage(named: item.avatarName)

        // Row shows username + image
        cell.configure(name: item.username, image: img)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismissSearchKeyboard()

        let selected = filteredDonors[indexPath.row]

        // Push donor details screen
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewDonorPageViewController") as! ViewDonorPageViewController
        vc.usernameText = selected.username
        vc.firstNameText = selected.firstName
        vc.lastNameText = selected.lastName
        vc.pointsValue = selected.points
        vc.avatarName = selected.avatarName
        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissSearchKeyboard()
    }
}

extension DDonorSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySearch(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        applySearch("")
        searchBar.resignFirstResponder()
    }
}
