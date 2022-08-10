//
//  ViewModel.swift
//  Spine
//
//  Created by Ailidh Kinney on 22/07/2022.
//
import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import SDWebImageSwiftUI


class ViewModel: ObservableObject {
    
    @Published var list = [SpineBook]()
    
    @Published var currentlyReading = [SpineBook]()
    
    @Published var toBeRead = [SpineBook]()
    
    @Published var email = ""
    
    @Published var password = ""
    
    @Published var isUserLoggedIn = false
    
    @Published var userAccountStatusMessage = ""
    
    @Published var name = ""
    
    @Published var isCurRead = false
    
    @Published var isTbr = false
    
    @Published var newAuthor = ""
    
    @Published var newTitle = ""
    
    @Published var newGenre = ""
    
    @Published var newCover = ""
    
    @Published var newBlurb = ""
    
    @State private var db = Firestore.firestore()
    
    @Published var searchedByTitleResults = [SpineBook]()
    
    @Published var searchedByAuthorResults = [SpineBook]()
    
    
    init() {
        
        getBooks()
        
    }
    
    func handleAddToCurrentlyReading(author: String,
                                     title: String,
                                     genre: String,
                                     cover: String,
                                     blurb: String,
                                     id: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(uid).collection("CurrentlyReading")
        
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
        }
        
        ref.addDocument(data: ["author": author,
                               "title" : title,
                               "genre" : genre,
                               "blurb" : blurb,
                               "cover" : cover]) {error in
            if error != nil {
                print(error!.localizedDescription)
                
            }
        }
    }
    
    
    func handleAddToToBeRead(author: String,
                             title: String,
                             genre: String,
                             cover: String,
                             blurb: String,
                             id: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(uid).collection("ToBeRead")
        
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
        }
        
        ref.addDocument(data: ["author": author,
                               "title" : title,
                               "genre" : genre,
                               "blurb" : blurb,
                               "cover" : cover, // check this
                              ]) {error in
            if error != nil {
                
                print(error!.localizedDescription)
                
            }
        }
    }
    
    
    func getBooks () {
        
        let ref = db.collection("SpineBooks")
        
        ref.getDocuments {snapshot, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                
                DispatchQueue.main.async {
                    self.list = snapshot.documents.map { d in
                        
                        return SpineBook(id: d.documentID,
                                         author: d["author"] as? String ?? "",
                                         genre: d["genre"] as? String ?? "",
                                         title: d["title"] as? String ?? "",
                                         cover: d["cover"] as? String ?? "",
                                         blurb: d["blurb"] as? String ?? "")
                    }
                }
            }
            
        }
    }
    
    func fetchCR() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(uid).collection("CurrentlyReading")
        
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let doc = change.document
                    self.currentlyReading.append(.init(id: doc.documentID,
                                                       author: doc["author"] as? String ?? "",
                                                       genre: doc["genre"] as? String ?? "",
                                                       title: doc["title"] as? String ?? "",
                                                       cover: doc["cover"] as? String ?? "",
                                                       blurb: doc["blurb"] as? String ?? ""))
                    
                }
            })
        }
        
    }
    
    func fetchSearchedByTitle(with searchTitle: String) {
        
        
        let ref = db.collection("SpineBooks")
        
        ref.whereField("title", isEqualTo: searchTitle).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let doc = change.document
                    self.searchedByTitleResults.append(.init(id: doc.documentID,
                                                             author: doc["author"] as? String ?? "",
                                                             genre: doc["genre"] as? String ?? "",
                                                             title: doc["title"] as? String ?? "",
                                                             cover: doc["cover"] as? String ?? "",
                                                             blurb: doc["blurb"] as? String ?? ""))
                    
                }
            })
        }
        
    }
    
    func fetchSearchedByAuthor(with searchAuthor: String) {
        
        
        let ref = db.collection("SpineBooks")
        
        ref.whereField("author", isEqualTo: searchAuthor).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let doc = change.document
                    self.searchedByAuthorResults.append(.init(id: doc.documentID,
                                                              author: doc["author"] as? String ?? "",
                                                              genre: doc["genre"] as? String ?? "",
                                                              title: doc["title"] as? String ?? "",
                                                              cover: doc["cover"] as? String ?? "",
                                                              blurb: doc["blurb"] as? String ?? ""))
                    
                }
            })
        }
        
    }
    
    func fetchTBR() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(uid).collection("ToBeRead")
        
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let doc = change.document
                    self.toBeRead.append(.init(id: doc.documentID,
                                               author: doc["author"] as? String ?? "",
                                               genre: doc["genre"] as? String ?? "",
                                               title: doc["title"] as? String ?? "",
                                               cover: doc["cover"] as? String ?? "",
                                               blurb: doc["blurb"] as? String ?? ""))
                    
                }
                
            })
        }
        
        
    }
    
    func addBook(author: String, title: String, genre: String, cover: String, blurb: String) {
        
        let ref = db.collection("SpineBooks")
        
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
        }
        
        ref.addDocument(data: ["author": author, "title": title, "cover": cover, "genre": genre, "blurb": blurb]) {
            error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func registerUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Incorrect info")
                self.userAccountStatusMessage = "Failed to create user"
            } else {
                
                self.isUserLoggedIn = true
                self.createUserAccount()
                
            }
        }
    }
    
    func login(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.isUserLoggedIn = false
                print(error!.localizedDescription)
                self.userAccountStatusMessage = "Incorrect email or password, please try again."
            } else {
                
                self.isUserLoggedIn = true
                
            }
            
        }
    }
    
    func createUserAccount() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let userInfo = ["UserID" : uid, "Email": email, "Name": name]
        
        Firestore.firestore().collection("Users").document(uid).setData(userInfo) { error in
            if let error = error {
                print(error)
                return
            }
            else {
                
                print("Success")
                
            }
        }
    }
    
    func removeFromTBR(bookToRemove: SpineBook) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(uid).collection("ToBeRead")
        
        ref.document(bookToRemove.id).delete() { error in
            if error == nil {
                
                DispatchQueue.main.async {
                    self.toBeRead.removeAll() { book in
                        return book.id == bookToRemove.id
                    }
                }
            }
        }
        
        
        
    }
    
    func removeFromCR(bookToRemove: SpineBook) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(uid).collection("CurrentlyReading")
        
        ref.document(bookToRemove.id).delete() { error in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    self.currentlyReading.removeAll() { book in
                        return book.id == bookToRemove.id
                    }
                }
            }
        }
        
        
        
    }
    
    
    func signOut() {
        
        isUserLoggedIn.toggle()
        do {
            
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
            print("error signing out: %@", signOutError)
        }
    }
}
