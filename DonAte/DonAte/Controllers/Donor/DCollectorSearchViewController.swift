//
//  DonorSearchViewController.swift
//  DonAte
//
//  Created by BP-19-114-03 on 14/12/2025.
//

import UIKit
import FirebaseFirestore

class DCollectorSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!   // Connect this to your search field

    // Temporary sample data (to be replaced with Firebase later)
    private let collectors: [(name: String, imageName: String)] = [
        ("Kaaf Humanitarian", "KaafLogo"),
        ("Ba9maa", "Ba9maLogo")
    ]

    // This is what we show after filtering (search)
    private var filteredCollectors: [(name: String, imageName: String)] = []

    // Change this if your segue identifier is different in storyboard
    private let detailsSegueID = "goToCollectorDetails"
    private let detailsSegueID2 = "goToCollectorDetails2"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start with all collectors visible
        filteredCollectors = collectors

        tableView.dataSource = self
        tableView.delegate = self

        // Match the card UI style
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        // Give cells a visible height
        tableView.rowHeight = 120

        // Search bar setup
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "Search collectors"

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

    // This runs the filtering and refreshes the table
    private func applySearch(_ text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        // If empty search, show all
        if query.isEmpty {
            filteredCollectors = collectors
        } else {
            filteredCollectors = collectors.filter { $0.name.lowercased().contains(query) }
        }

        tableView.reloadData()
    }

    // Optional: dismiss keyboard when scrolling
    private func dismissSearchKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension DCollectorSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Show filtered results
        return filteredCollectors.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Dequeue your custom card cell
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SavedCollectorCell",
            for: indexPath
        ) as! SavedCollectorCell

        // Get data for this row
        let item = filteredCollectors[indexPath.row]

        // Load image from Assets (same name as in imageName)
        let img = UIImage(named: item.imageName)

        // Fill the cell UI
        cell.configure(name: item.name, image: img)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect + hide keyboard
        tableView.deselectRow(at: indexPath, animated: true)
        dismissSearchKeyboard()

        let tapped = filteredCollectors[indexPath.row]
        print("Tapped:", tapped.name)

        // If Kaaf was tapped, go to the next screen
        if tapped.name == "Kaaf Humanitarian" {
            performSegue(withIdentifier: detailsSegueID, sender: tapped)
        }
        
        if tapped.name == "Ba9maa" {
            performSegue(withIdentifier: detailsSegueID2, sender: tapped)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissSearchKeyboard()
    }

    
}

extension DCollectorSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter live as user types
        applySearch(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Close keyboard when search pressed
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // If you enable a cancel button, this resets results
        searchBar.text = ""
        applySearch("")
        searchBar.resignFirstResponder()
    }
}
