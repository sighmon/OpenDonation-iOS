//
//  ViewController.swift
//  OpenDonation
//
//  Created by Simon Loffler on 20/10/18.
//  Copyright © 2018 Simon Loffler. All rights reserved.
//

import UIKit
import SquarePointOfSaleSDK

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Variables
    private var donationValue: Int = 5
    private var minimumDonationValue = 5
    private var maximumDonationValue = 99
    private var terminalDescription = NSLocalizedString("Open Donation app 1", comment: "Identifies this donation app")
    private var donationAmountArray = [Int]()
    
    // MARK: Properties
    @IBOutlet weak var donationPicker: UIPickerView!
    
    // MARK: Actions
    @IBAction func donateButton(_ sender: Any) {
        // Make a transaction in cents
        makeTransaction(amount: donationValue * 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Your client ID is the same as your Square Application ID.
        // Note: You only need to set your client ID once, before creating your first request.
        SCCAPIRequest.setClientID(API.Square.API_CLIENT_ID)
        
        // Setup Picker View
        donationPicker.delegate = self
        donationPicker.dataSource = self
        donationAmountArray = Array(minimumDonationValue...maximumDonationValue)

    }
    
    // MARK: UIPickerView
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Set the donationValue to the pickerView int
        donationValue = donationAmountArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return donationAmountArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "$\(donationAmountArray[row])"
    }

    func makeTransaction(amount: Int) {
        do {
            // URL scheme callback
            let callbackURL = URL(string: "opendonation://callback")!
            
            // Specify the amount of money to charge.
            let money = try SCCMoney(amountCents: amount, currencyCode: "AUD")
            
            // Create the request.
            let apiRequest =
                try SCCAPIRequest(
                    callbackURL: callbackURL,
                    amount: money,
                    userInfoString: nil,
                    locationID: nil,
                    notes: NSLocalizedString("Donation from \(terminalDescription)", comment: "Transaction request description"),
                    customerID: nil,
                    supportedTenderTypes: .card,
                    clearsDefaultFees: false,
                    returnAutomaticallyAfterPayment: false
            )
            
            // Open Point of Sale to complete the payment.
            try SCCAPIConnection.perform(apiRequest)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// MARK: UIView with rounded corners
@IBDesignable
class DesignableView: UIView {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

