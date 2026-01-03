//
//  DonorAddressViewController.swift
//  DonAte
//
//  Created by Guest 1 on 01/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

// MARK: - Model
struct DonorAddress {
    let addressId: String
    let addressName: String
    let addressPhone: String
    let blockNo: String
    let houseNo: String
    let roadNo: String
    let townCity: String

    // UI-ready details string
    var detailsText: String {
        "\(houseNo), \(blockNo), \(roadNo), \(townCity),\n+\(addressPhone)"
    }

    // Parse Firestore dictionary safely
    static func from(_ dict: [String: Any]) -> DonorAddress {
        // Convert Int/Double/String to String
        func toString(_ value: Any?) -> String {
            if let s = value as? String { return s }
            if let i = value as? Int { return String(i) }
            if let d = value as? Double { return String(Int(d)) }
            return ""
        }

        return DonorAddress(
            addressId: toString(dict["addressId"]),
            addressName: toString(dict["addressName"]),
            addressPhone: toString(dict["addressPhone"]),
            blockNo: toString(dict["blockNo"]),
            houseNo: toString(dict["houseNo"]),
            roadNo: toString(dict["roadNo"]),
            townCity: toString(dict["townCity"])
        )
    }
}

// MARK: - ViewController
class DonorAddressViewController: UIViewController {
    
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "DonorProfile", bundle: nil)

            let vc = storyboard.instantiateViewController(
                withIdentifier: "DAddAddressViewController"
            ) as! DAddAddressViewController

            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!

    private let db = Firestore.firestore()
    private var addresses: [DonorAddress] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        navBar.configure(style: .backWithTitle(title: "Saved Addresses"))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
           
        }

        // Table setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        // Fetch addresses from Firestore
        fetchAddressesFromFirebase()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        //to be refreshed
        fetchAddressesFromFirebase()
    }

    private func fetchAddressesFromFirebase() {
        // Get current user id
        guard let uid = Auth.auth().currentUser?.uid else {
            addresses = []
            tableView.reloadData()
            return
        }

        // Read: Users/{uid}
        db.collection("Users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if error != nil {
                self.addresses = []
                DispatchQueue.main.async { self.tableView.reloadData() }
                return
            }

            guard let data = snapshot?.data() else {
                self.addresses = []
                DispatchQueue.main.async { self.tableView.reloadData() }
                return
            }

            // Parse the 'address' array
            let rawAddresses = data["address"] as? [[String: Any]] ?? []
            self.addresses = rawAddresses.map { DonorAddress.from($0) }

            // Reload UI on main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView
extension DonorAddressViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "AddressCardCell",
            for: indexPath
        ) as! AddressCardCell

        let item = addresses[indexPath.row]
        cell.configure(title: item.addressName, details: item.detailsText)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selected = addresses[indexPath.row]

        // IMPORTANT: load from DonorProfile storyboard
        let storyboard = UIStoryboard(name: "DonorProfile", bundle: nil)

        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "DEditAddressViewController"
        ) as? DEditAddressViewController else {
            assertionFailure("DEditAddressViewController not found in DonorProfile storyboard")
            return
        }

        vc.addressToEdit = selected
        navigationController?.pushViewController(vc, animated: true)
    }


}
