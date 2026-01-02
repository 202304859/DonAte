//
//  BaseViewController.swift
//  DonAte
//
//  Created for consistent status bar styling across the app
//

import UIKit

/// Base view controller that provides consistent status bar styling throughout the app.
///
/// This class handles the visual integration between the iOS status bar and the app's
/// green theme by extending a background view behind the status bar area.
///
/// ## Usage
/// Inherit from this class instead of UIViewController:
/// ```swift
/// class MyViewController: BaseViewController {
///     override func viewDidLoad() {
///         super.viewDidLoad()
///         statusBarBackgroundColor = UIColor(hex: "b4e7b4")
///     }
/// }
/// ```
///
/// ## Features
/// - Extends background color behind status bar
/// - Respects Safe Area insets
/// - Supports Dynamic Island
/// - Configurable per-screen status bar style
///
class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The background color for the extended status bar area
    /// Set this property to match your screen's theme color
    var statusBarBackgroundColor: UIColor = UIColor(hex: "b4e7b4") {
        didSet {
            statusBarBackgroundView?.backgroundColor = statusBarBackgroundColor
            updateStatusBarStyle()
        }
    }
    
    /// The view that extends behind the status bar
    private var statusBarBackgroundView: UIView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBarBackground()
    }
    
    // MARK: - Status Bar Configuration
    
    /// Override to control status bar appearance
    /// - Returns: The preferred status bar style for this view controller
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Use light content (white icons) for the green background
        return .lightContent
    }
    
    // MARK: - Setup
    
    /// Sets up the background view that extends behind the status bar
    /// This creates a seamless visual transition from status bar to app content
    private func setupStatusBarBackground() {
        // Remove any existing status bar background
        statusBarBackgroundView?.removeFromSuperview()
        
        // Create background view
        let backgroundView = UIView()
        backgroundView.backgroundColor = statusBarBackgroundColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Insert at the back so other content appears on top
        view.insertSubview(backgroundView, at: 0)
        
        // Constrain the background view to extend from the top of the screen
        // down to the top of the safe area (covering the status bar)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        statusBarBackgroundView = backgroundView
    }
    
    /// Updates the status bar appearance style
    private func updateStatusBarStyle() {
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Helper Methods
    
    /// Configures the navigation bar for transparent appearance
    /// Call this in viewWillAppear when you want the navigation bar to blend with your content
    func setupTransparentNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        navigationBar.tintColor = .black // Back button and title color
    }
    
    /// Resets the navigation bar to its default appearance
    /// Call this in viewWillDisappear if other screens need standard navigation bar
    func resetNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = nil
    }
}
