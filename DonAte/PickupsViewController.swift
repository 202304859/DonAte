import UIKit

class PickupsViewController: BaseViewController {
    
    // MARK: - UI Elements
    private var statusBarView: UIView!
    private var calendarView: CalendarView!
    private var selectedDateLabel: UILabel!
    private var tableView: UITableView!
    
    // MARK: - Properties
    private var allDonations: [Donation] = []
    private var filteredDonations: [Donation] = []
    private let dataManager = DataManager.shared
    private var selectedDate: Date?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        setupTableView()
        loadPickups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPickups()
    }
    
    // MARK: - Create UI
    private func createUI() {
        view.backgroundColor = UIColor(hex: "F2F2F2")
        
        // Status Bar Background
        // Large Green Header
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "b4e7b4")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Pick ups"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Calendar View
        calendarView = CalendarView()
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        // Selected Date Label
        selectedDateLabel = UILabel()
        selectedDateLabel.text = "All Upcoming Pickups"
        selectedDateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedDateLabel)
        
        // Clear Filter Button
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Show All", for: .normal)
        clearButton.setTitleColor(.donateGreen, for: .normal)
        clearButton.titleLabel?.font = .systemFont(ofSize: 14)
        clearButton.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
        
        // Table View
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Status bar view
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            calendarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 320),
            
            selectedDateLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            selectedDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            clearButton.centerYAnchor.constraint(equalTo: selectedDateLabel.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: selectedDateLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DonationCell.self, forCellReuseIdentifier: "DonationCell")
    }
    
    private func loadPickups() {
        allDonations = dataManager.getAcceptedDonations()
        
        // Set pickup dates on calendar
        let pickupDates = allDonations.compactMap { donation -> Date? in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.date(from: donation.date)
        }
        calendarView.setPickupDates(pickupDates)
        
        filterDonations()
    }
    
    private func filterDonations() {
        if let selectedDate = selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            let selectedDateString = formatter.string(from: selectedDate)
            
            filteredDonations = allDonations.filter { $0.date == selectedDateString }
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "EEEE, MMM d"
            selectedDateLabel.text = "Pickups for \(displayFormatter.string(from: selectedDate))"
        } else {
            filteredDonations = allDonations
            selectedDateLabel.text = "All Upcoming Pickups"
        }
        
        tableView.reloadData()
    }
    
    @objc private func clearFilter() {
        selectedDate = nil
        filterDonations()
    }
}

// MARK: - CalendarViewDelegate
extension PickupsViewController: CalendarViewDelegate {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date) {
        selectedDate = date
        filterDonations()
    }
}

// MARK: - UITableViewDataSource
extension PickupsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredDonations.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = selectedDate != nil ? "No pickups scheduled for this date" : "No pickups scheduled"
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = .center
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
        return filteredDonations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath) as! DonationCell
        cell.configure(with: filteredDonations[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PickupsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DonationDetailViewController()
        vc.donation = filteredDonations[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
