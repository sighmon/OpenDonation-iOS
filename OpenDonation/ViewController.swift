//
//  ViewController.swift
//  OpenDonation
//
//  Created by Simon Loffler on 20/10/18.
//  Copyright © 2018 Simon Loffler. All rights reserved.
//

import UIKit
import SquarePointOfSaleSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace with your app's URL scheme.
        let callbackURL = URL(string: "opendonation://callback")!
        
        // Your client ID is the same as your Square Application ID.
        // Note: You only need to set your client ID once, before creating your first request.
        SCCAPIRequest.setClientID(API.Square.API_CLIENT_ID)
        
        do {
            // Specify the amount of money to charge.
            let money = try SCCMoney(amountCents: 100, currencyCode: "AUD")
            
            // Create the request.
            let apiRequest =
                try SCCAPIRequest(
                    callbackURL: callbackURL,
                    amount: money,
                    userInfoString: nil,
                    locationID: nil,
                    notes: "Coffee",
                    customerID: nil,
                    supportedTenderTypes: .all,
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

