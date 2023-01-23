//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Berkay YAY on 24.12.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    let firestoreDB = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    var timeLeft : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
    }
    
    func getSnapsFromFirebase(){
        firestoreDB.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        guard let username = document.get("snapOwner") as? String,
                              let imageUrlArray = document.get("imageUrlArray") as? [String],
                              let date = document.get("date") as? Timestamp else {
                            return
                        }
                        
                        if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                             if difference >= 24 {
                                //Delete snapshot from firebase
                                self.firestoreDB.collection("Snap").document(documentId).delete { error in
                                    if error != nil {
                                        self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                    }
                                }
                             } else {
                                 //Timeleft -> SnapVC
                                 let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                 self.snapArray.append(snap)
                             }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func getUserInfo(){
        firestoreDB.collection("UserInfo")
            .whereField("email", isEqualTo: Auth.auth().currentUser!.email)
            .getDocuments { snapshot, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else{
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents{
                            if let username = document.get("username") as? String {
                                UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                                UserSingleton.sharedUserInfo.username = username
                            }
                        }
                    }
                }
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapViewController
            destinationVC.selectedSnap = chosenSnap
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
}
