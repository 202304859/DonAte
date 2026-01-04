//
//  DSavedCollectorsViewController.swift
//  DonAte
//
//  Created by Guest 1 on 02/01/2026.
//

import UIKit

class DSavedCollectorsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // 🔹 Simple static data (as it was before favorites)
    private let collectors: [(name: String, imageName: String)] = [
        ("Kaaf Humanitarian", "KaafLogo"),
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 120

        // --- Custom Navigation Bar ---
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])

        navBar.configure(style: .backWithTitle(title: "Saved Collectors"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Table View
extension DSavedCollectorsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectors.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SavedCollectorCell",
            for: indexPath
        ) as! SavedCollectorCell

        let item = collectors[indexPath.row]
        let img = UIImage(named: item.imageName)

        cell.configure(name: item.name, image: img)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selected = collectors[indexPath.row]
        print("Tapped saved collector:", selected.name)

        // 1) Load the storyboard that contains the detail screens
        let donorSearchSB = UIStoryboard(name: "DonorSearch", bundle: nil)

        // 2) Navigate depending on which collector was tapped
        if selected.name == "Kaaf Humanitarian" {
            
            let vc = donorSearchSB.instantiateViewController(withIdentifier: "ViewCollectorPageViewController")
            navigationController?.pushViewController(vc, animated: true)

        }
        }
    }


