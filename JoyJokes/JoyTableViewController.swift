//
//  JoyTableViewController.swift
//  JoyJokes
//
//  Created by Milos Jovanovic on 06/06/2019.
//  Copyright © 2019 Milos Jovanovic. All rights reserved.
//

import UIKit
import StoreKit

class JoyTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    
    let productID = "com.milosjovanovic.JoyJokes.PremiumJokes"
    
    var jokesToShow = [
        "Whats the best thing about Switzerland? I don't know,but the flag is a big plus.",
        "Hear about the new restaurant called Karma? There's no menu: You get what you deserve.",
        "How do you dron a hipster? Throw him in the mainstream.",
        "A man tells his doctor \"Doc, help me.I'm addicted to Twitter!\". The doctor replies, \"Sorry, I don't follow you...\"",
        "What did the 0 say to the 8? Nice belt!",
        "What is an astronaut's favorite part on a computer? The space bar.",
        "What's Forest Gump's password? 1Forest1",
        "I told my wife she was drawing her eyebrows too high. She looked at me surprised."
    ]
    
    let premiumJokes = [
        "Why did the hipster burn his mouth? He drank the coffee before it was cool.",
        "Where does Batman go to the bathroom? The batroom.",
        "What breed of dog can jump higher then buildings ? Any dog, because buildings can't jump.",
        "Why aren't koalas actual bears? They don't meed the koalafications.",
        "How do you throw a space party? You planet.",
        "How many times can you subtract 10 from 100? Once.The next time you would be subtracting 10 from 90.",
        "Did you hear about the mathematician who's afraind of negative numbers ? He'll stop at nothing to avoid them.",
        "I'm on a whiskey diet. I've lost three days already."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumJokes()
        }

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return jokesToShow.count
        } else {
        return jokesToShow.count + 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath)
        
        if indexPath.row < jokesToShow.count {
        cell.textLabel?.text = jokesToShow[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Jokes"
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == jokesToShow.count {
            buyPremiumJokes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - In-App Purchase Methods
    
    func buyPremiumJokes() {
        
        if SKPaymentQueue.canMakePayments() {
            //Can make payments
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            print("User can't make payments")
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        //Creating a loop for array of SKPaymentTransaction's because user can purchase multiple times
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                
                //User payment successful
                print("Transaction successful!")
                
                showPremiumJokes()
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .failed {
                
                //User payment failed
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .restored {
                
                showPremiumJokes()
                print("Transaction restored")
                
                navigationItem.setRightBarButton(nil, animated: true)
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumJokes() {
        
        UserDefaults.standard.set(true, forKey: productID)
        jokesToShow.append(contentsOf: premiumJokes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchasedStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchasedStatus {
            print("Previously purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
