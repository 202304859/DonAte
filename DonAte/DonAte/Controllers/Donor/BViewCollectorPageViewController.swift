//
//  BViewCollectorPageViewController.swift
//  DonAte
//
//  Created by Guest 1 on 04/01/2026.
//

import UIKit

// MARK: - Model
struct Collector: Codable, Equatable {
    let name: String
    let imageName: String

    static func == (lhs: Collector, rhs: Collector) -> Bool {
        return lhs.name == rhs.name
    }
}

final class SavedCollectorsStore {

    static let shared = SavedCollectorsStore()
    static let didChangeNotification = Notification.Name("SavedCollectorsStoreDidChange")

    private let key = "saved_collectors_key"

    private init() {}

    // Get all saved collectors
    func getAll() -> [Collector] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Collector].self, from: data)
        } catch {
            print("SavedCollectorsStore decode error:", error)
            return []
        }
    }

    // Check if a collector is already saved
    func isSaved(_ collector: Collector) -> Bool {
        return getAll().contains(collector)
    }

    // Toggle save / unsave
    func toggle(_ collector: Collector) -> Bool {
        var list = getAll()

        if let index = list.firstIndex(of: collector) {
            list.remove(at: index)
            save(list)
            return false
        } else {
            list.append(collector)
            save(list)
            return true
        }
    }

    // REMOVE a collector explicitly (used by Saved screen)
    func remove(_ collector: Collector) {
        var list = getAll()
        list.removeAll { $0 == collector }
        save(list)
    }

    // Save + notify listeners
    private func save(_ list: [Collector]) {
        do {
            let data = try JSONEncoder().encode(list)
            UserDefaults.standard.set(data, forKey: key)

            NotificationCenter.default.post(
                name: SavedCollectorsStore.didChangeNotification,
                object: nil
            )
        } catch {
            print("SavedCollectorsStore encode error:", error)
        }
    }
}


// MARK: - View Controller
class BViewCollectorPageViewController: UIViewController {

    // Set these before pushing this screen
    var collectorName: String = "Ba9maa"
    var collectorImageName: String = "Ba9maLogo"

    private let navBar = CustomNavigationBar()

    private let favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false

        // default state (we update in viewWillAppear)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)

        // Use your Assets color set name: "color 3"
        btn.tintColor = UIColor(named: "color 3") ?? .systemRed

        // Bigger tap area
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        // Make sure it can receive touches
        btn.isUserInteractionEnabled = true

        return btn
    }()

    private var currentCollector: Collector {
        Collector(name: collectorName, imageName: collectorImageName)
    }

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
        
        navBar.configure(style: .backWithTitle(title: ""))
        navBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            
        }
        
        
        // --- Heart button BELOW nav bar ---
        view.addSubview(favoriteButton)
    
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 12),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)

        // ✅ IMPORTANT: if storyboard views cover the whole screen, bring these on top
        view.bringSubviewToFront(navBar)
        view.bringSubviewToFront(favoriteButton)

        // Extra safety: put them above everything visually
        navBar.layer.zPosition = 999
        favoriteButton.layer.zPosition = 1000
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
   
        // Update heart state
        updateFavoriteIcon()
    }

    @objc private func didTapFavorite() {
        // Debug print so you can confirm tap is working
        print("Heart tapped for:", collectorName)

        let isNowSaved = SavedCollectorsStore.shared.toggle(currentCollector)
        setFavoriteIcon(saved: isNowSaved)
    }

    private func updateFavoriteIcon() {
        let saved = SavedCollectorsStore.shared.isSaved(currentCollector)
        setFavoriteIcon(saved: saved)
    }

    private func setFavoriteIcon(saved: Bool) {
        let imageName = saved ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = UIColor(named: "color 3") ?? .systemRed
    }
}
