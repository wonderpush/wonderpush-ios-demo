//
//  InitWonderPushViewController.swift
//  WonderPushDemo
//
//  Created by Stéphane Jaïs on 15/05/2024.
//  Copyright © 2024 WonderPush. All rights reserved.
//

import UIKit
import WonderPush

@objcMembers class InitWonderPushViewController: UIViewController {
    @IBOutlet weak var clientIdTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clientSecretTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
        self.doneButton.isEnabled = WonderPush.isInitialized()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }


    @IBAction func touchInitializeWonderPush(_ sender: Any) {
        let clientId = self.clientIdTextField.text;
        let secret = self.clientSecretTextField.text;
        if (clientId?.isEmpty ?? true) {
            let alert = UIAlertController(title: nil, message: "Missing clientId", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        }
        if (secret?.isEmpty ?? true) {
            let alert = UIAlertController(title: nil, message: "Missing secret", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        }
        if let defaults = UserDefaults(suiteName: "group.com.wonderpush.demo") {
            defaults.setValue(clientId, forKey: "wp_clientId")
            defaults.setValue(secret, forKey: "wp_secret")
            defaults.synchronize()
        }

        WonderPush.setClientId(clientId!, secret: secret!)
        let alert = UIAlertController(title: nil, message: "You must restart the app in order to use these new values", preferredStyle: .alert)
        let kill = UIAlertAction(title: "Kill app", style: .destructive, handler: {(action) in
            fatalError("Restart app to take settings into account")
        })
        alert.addAction(kill)
        alert.addAction(UIAlertAction(title: "Later", style: .cancel))
        self.present(alert, animated: true)
        self.doneButton.isEnabled = true
    }

    @IBAction func touchDone(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
