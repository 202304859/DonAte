import UIKit

// MARK: - CalendarView Delegate
protocol CalendarViewDelegate: AnyObject {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date)
}

// MARK: - CalendarView
class CalendarView: UIView {
    
    // MARK: - UI Components
    private let headerStackView = UIStackView()
    private let prevButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let monthLabel = UILabel()
    private let daysStackView = UIStackView()
    private let calendarGridStackView = UIStackView()
    
    // MARK: - Properties
    weak var delegate: CalendarViewDelegate?
    private var currentDate = Date()
    private var selectedDate: Date?
    private var pickupDates: [Date] = []
    private let calendar = Calendar.current
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var dayButtons: [UIButton] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.donateGreen.cgColor
        
        setupHeader()
        setupWeekdaysHeader()
        setupCalendarGrid()
        updateCalendar()
    }
    
    private func setupHeader() {
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fill
        headerStackView.alignment = .center
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerStackView)
        
        // Previous Button
        prevButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        prevButton.tintColor = .donateGreen
        prevButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        
        // Month Label
        monthLabel.font = .boldSystemFont(ofSize: 18)
        monthLabel.textAlignment = .center
        
        // Next Button
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.tintColor = .donateGreen
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        headerStackView.addArrangedSubview(prevButton)
        headerStackView.addArrangedSubview(monthLabel)
        headerStackView.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerStackView.heightAnchor.constraint(equalToConstant: 30),
            
            prevButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupWeekdaysHeader() {
        daysStackView.axis = .horizontal
        daysStackView.distribution = .fillEqually
        daysStackView.spacing = 0
        daysStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.textColor = .gray
            label.textAlignment = .center
            daysStackView.addArrangedSubview(label)
        }
        
        addSubview(daysStackView)
        
        NSLayoutConstraint.activate([
            daysStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            daysStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            daysStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            daysStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupCalendarGrid() {
        calendarGridStackView.axis = .vertical
        calendarGridStackView.distribution = .fillEqually
        calendarGridStackView.spacing = 4
        calendarGridStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create 6 weeks (rows)
        for _ in 0..<6 {
            let weekStackView = UIStackView()
            weekStackView.axis = .horizontal
            weekStackView.distribution = .fillEqually
            weekStackView.spacing = 4
            
            // Create 7 days (columns)
            for _ in 0..<7 {
                let dayButton = UIButton(type: .system)
                dayButton.titleLabel?.font = .systemFont(ofSize: 14)
                dayButton.layer.cornerRadius = 4
                dayButton.addTarget(self, action: #selector(dayTapped(_:)), for: .touchUpInside)
                dayButtons.append(dayButton)
                weekStackView.addArrangedSubview(dayButton)
            }
            
            calendarGridStackView.addArrangedSubview(weekStackView)
        }
        
        addSubview(calendarGridStackView)
        
        NSLayoutConstraint.activate([
            calendarGridStackView.topAnchor.constraint(equalTo: daysStackView.bottomAnchor, constant: 8),
            calendarGridStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            calendarGridStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            calendarGridStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Calendar Logic
    private func updateCalendar() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: currentDate)
        
        // Get first day of month
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components) else { return }
        
        // Get weekday of first day (0 = Sunday)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        // Get number of days in month
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return }
        let numberOfDays = range.count
        
        // Get today's date for comparison
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
        
        // Update buttons
        for (index, button) in dayButtons.enumerated() {
            let dayNumber = index - firstWeekday + 1
            
            if dayNumber > 0 && dayNumber <= numberOfDays {
                button.setTitle("\(dayNumber)", for: .normal)
                button.isHidden = false
                button.tag = dayNumber
                
                // Check if this is today
                let isToday = todayComponents.year == currentComponents.year &&
                              todayComponents.month == currentComponents.month &&
                              todayComponents.day == dayNumber
                
                // Check if this date has a pickup
                let hasPickup = isPickupDate(day: dayNumber)
                
                // Check if selected
                let isSelected = isSelectedDate(day: dayNumber)
                
                // Style button
                if isSelected {
                    button.backgroundColor = .donateGreen
                    button.setTitleColor(.white, for: .normal)
                } else if hasPickup {
                    button.backgroundColor = UIColor.donateGreen.withAlphaComponent(0.3)
                    button.setTitleColor(.donateGreen, for: .normal)
                } else if isToday {
                    button.backgroundColor = UIColor.donateGreen.withAlphaComponent(0.1)
                    button.setTitleColor(.donateGreen, for: .normal)
                } else {
                    button.backgroundColor = .clear
                    button.setTitleColor(.black, for: .normal)
                }
            } else {
                button.setTitle("", for: .normal)
                button.isHidden = true
                button.tag = 0
            }
        }
    }
    
    private func isPickupDate(day: Int) -> Bool {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        var dateComponents = components
        dateComponents.day = day
        
        guard let date = calendar.date(from: dateComponents) else { return false }
        
        return pickupDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    private func isSelectedDate(day: Int) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        var dateComponents = components
        dateComponents.day = day
        
        guard let date = calendar.date(from: dateComponents) else { return false }
        
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }
    
    // MARK: - Public Methods
    func setPickupDates(_ dates: [Date]) {
        pickupDates = dates
        updateCalendar()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        currentDate = date
        updateCalendar()
    }
    
    // MARK: - Actions
    @objc private func previousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) else { return }
        currentDate = newDate
        updateCalendar()
    }
    
    @objc private func nextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: currentDate) else { return }
        currentDate = newDate
        updateCalendar()
    }
    
    @objc private func dayTapped(_ sender: UIButton) {
        guard sender.tag > 0 else { return }
        
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        var dateComponents = components
        dateComponents.day = sender.tag
        
        guard let date = calendar.date(from: dateComponents) else { return }
        
        selectedDate = date
        updateCalendar()
        delegate?.calendarView(self, didSelectDate: date)
    }
}
