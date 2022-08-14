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

/// The ViewModel class for Spine.
class ViewModel: ObservableObject {
    
    /// A list of all the books available on Spine.
    @Published var list = [SpineBook]()
    
    /// The current User's Currently Reading shelf.
    @Published var currentlyReading = [SpineBook]()
    
    /// The current User's To Be Read shelf.
    @Published var toBeRead = [SpineBook]()
    
    /// The email of a User logging in to Spine.
    @Published var email = ""
    
    /// The password of a User logging in to Spine.
    @Published var password = ""
    
    /// A boolean to check if a User is logged in or not.
    @Published var isUserLoggedIn = false
    
    /// An error message if incorrect credentials are given for login or register.
    @Published var userAccountStatusMessage = ""
    
    /// The name of a new User for a new account created.
    @Published var name = ""
    
    /// A booolean to show if a book is on the User's Currently Reading shelf.
    @Published var isCurRead = false
    
    /// A boolean to show if a book is on the User's To Be Read shelf.
    @Published var isTbr = false
    
    /// The author of a new  book being added to Spine by a User.
    @Published var newAuthor = ""
    
    /// The title of a new  book being added to Spine by a User.
    @Published var newTitle = ""
    
    /// The genre of a new  book being added to Spine by a User.
    @Published var newGenre = ""
    
    /// The cover of a new  book being added to Spine by a User.
    @Published var newCover = ""
    
    /// The blurb of a new  book being added to Spine by a User.
    @Published var newBlurb = ""
    
    /// A connection to my Firestore database.
    @State private var db = Firestore.firestore()
    
    /// A list of results that match a title search parameter given by a User.
    @Published var searchedByTitleResults = [SpineBook]()
    
    /// A list of results that match an author search parameter given by a User.
    @Published var searchedByAuthorResults = [SpineBook]()
    
    /// Initialise the main list of Spine books.
    init() {
        
        getBooks()
        
    }
    
    /// Add the selected book to the User's Currently Reading shelf.
    ///
    /// -Parameters:
    ///     - author: The author of the book the User is adding to their Currently Reading shelf.
    ///     - title: The title of the book the User is adding to their Currently Reading shelf.
    ///     - genre: The genre of the book the User is adding to their Currently Reading shelf.
    ///     - cover: The cover of the book the User is adding to their Currently Reading shelf.
    ///     - blurb: The blurb of the book the User is adding to their Currently Reading shelf.
    ///     - id: The docuemnt ID of this book in Firestore.
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
    
    /// Add the selected book to the User's To Be Read shelf.
    ///
    /// -Parameters:
    ///     - author: The author of the book the User is adding to their To Be Read shelf.
    ///     - title: The title of the book the User is adding to their To Be Read shelf.
    ///     - genre: The genre of the book the User is adding to their To Be Read shelf.
    ///     - cover: The cover of the book the User is adding to their To Be Read shelf.
    ///     - blurb: The blurb of the book the User is adding to their To Be Read  shelf.
    ///     - id: The docuemnt ID of this book in Firestore.
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
                               "cover" : cover,
                              ]) {error in
            if error != nil {
                
                print(error!.localizedDescription)
                
            }
        }
    }
    
    /**
     List out all the books available in the SpineBooks collection.
     
     - Returns: A  list of each book in the SpineBooks collection.
     */
    func getBooks() {
        
        let ref = db.collection("SpineBooks")
        
        ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let doc = change.document
                    self.list.append(.init(id: doc.documentID,
                                                       author: doc["author"] as? String ?? "",
                                                       genre: doc["genre"] as? String ?? "",
                                                       title: doc["title"] as? String ?? "",
                                                       cover: doc["cover"] as? String ?? "",
                                                       blurb: doc["blurb"] as? String ?? ""))
                    
                }
            })
        }
        
    }
    
    /**
     List out all the books available in the User's Currently Reading collection.
     
     - Returns: A  list of each book in the User's Currently Reading collection, if there are any.
     */
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
    
    /** Search the SpineBooks collection for a book by the book's title.
     
     - Parameters:
     - searchTitle: The title the User wishes to search for.
     
     - Returns: The book that was searched for if it is included in the
     collection, or a note that it is not available.
     */
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
    
    /** Search the SpineBooks collection for a book by the book's author..
     
     - Parameters:
     - searchAuthor: The title the User wishes to search for.
     
     - Returns: The book that was searched for if it is included in the
     collection, or a note that it is not available.
     */
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
    
    /**
     List out all the books available in the User's To Be Read collection.
     
     - Returns: A  list of each book in the User's To Be Read collection, if there are any.
     */
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
    
    /// Add a book to the Spine book collection.
    ///
    /// Parameters:
    ///     - author: The author of the book the User is adding
    ///     - title: The title of the book the User is adding.
    ///     - genre: The genre of the book the User is adding.
    ///     - cover: The cover of the book the User is adding.
    ///     - blurb: The blurb of the book the User is adding.
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
    
    /// Regsiter a new User on Spine.
    ///
    /// Parameters:
    ///     - email: The email of the User that is registering.
    ///     - password: The password of the User that is registering.
    func registerUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Incorrect information")
                self.userAccountStatusMessage = "Failed to create user, please check details."
            } else {
                
                self.isUserLoggedIn = true
                self.createUserAccount()
                
            }
        }
    }
    
    /// Login to Spine with a User's registered credentials.
    /// Parameters:
    ///     - email: The email associated with the User's account.
    ///     - password: The password associated with the User's account.
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
    
    /// Create a User document in the Users collections database.
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
    
    /// Remove a book from a User's To Be Read shelf.
    ///
    /// Parameters:
    ///     - bookToRemove: The book that the User wants to remove from their To Be Read shelf.
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
    
    /// Remove a book from a User's Currenttly Reading shelf.
    ///
    /// Parameters:
    ///     - bookToRemove: The book that the User wants to remove from their Currently Reading shelf.
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
    
    /// Delete's the User's Spine account and assoicated data.
    func deleteAccount() {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.isUserLoggedIn.toggle()
                print("success")
            }
        }
    }
    
    /// Sign out the User from their Spine account.
    func signOut() {
        
        isUserLoggedIn.toggle()
        do {
            
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
            print("error signing out: %@", signOutError)
        }
    }
    
    
}
