//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Berkay YAY on 24.12.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func signInButtonClicked(_ sender: Any) {
        if passwordLabel.text != "" && emailLabel.text != "" {
                
            Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordLabel.text!) { auth, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.showAlert(title: "Error", message: "Username/Password/Email not found")
        }
        
        
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if usernameLabel.text != "" && passwordLabel.text != "" && emailLabel.text != "" {
            
            Auth.auth().createUser(withEmail: emailLabel.text!, password: passwordLabel.text!) { auth, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else{
                    
                    let firestore = Firestore.firestore()
                    
                    let userDictionary = ["email" : self.emailLabel.text!, "username" : self.usernameLabel.text!] as [String : Any]
                    
                    firestore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.showAlert(title: "Error", message: "Username/Password/Email not found")
        }
    }
    
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

