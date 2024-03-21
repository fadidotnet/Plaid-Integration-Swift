//
//  AccountsViewController.swift
//  Plaid-Integration
//
//  Created by Fahad Hassan on 20/03/2024.
//

import UIKit
import LinkKit

class AccountsViewController: UIViewController {
    
    // MARK: - Initializers -
    private var handler: Handler?
    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func openPlaidView(token: String) {
        var config = LinkTokenConfiguration(token: token) { success in
            // Implement an Api call to send the public token to the server
        }
        config.onExit = { _ in}
        let result = Plaid.create(config)
        switch result {
        case .failure(let error):
            self.showErrorAlert(error: error.localizedDescription)
        case .success(let handler):
            self.handler = handler
        }
        guard let handler = handler else {return}
        DispatchQueue.main.async {
            handler.open(presentUsing: .custom({ [weak self] linkViewController in
                linkViewController.modalPresentationStyle = .overFullScreen
                self?.present(linkViewController, animated: true)
            }))
        }
    }
    
    private func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    // MARK: - Actions -
    @IBAction func addAccountTapped(_ sender: UIButton) {
        self.openPlaidView(token: "Your_Plaid_Token")
    }
}

