//
//  ContentView.swift
//  Spine
//
//  Created by Ailidh Kinney on 20/07/2022.

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI


struct MainView: View {
    
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        
        if model.isUserLoggedIn == false {
            content
        } else {
            TabView {
                homepage()
                    .tabItem {
                        Label("Home", systemImage: "house")
                        Text("Home")
                    }
                
                allBooks()
                    .tabItem {
                        Label("Search", systemImage: ("magnifyingglass.circle.fill"))
                    }
                
                profile()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                
                
            }
            
            
            
        }
        
        
    }
    
    
    
    
    
    var content: some View {
        
        NavigationView {
            
            ZStack {
                
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    VStack {
                        Text("Spine.")
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 100))
                            .underline()
                            .padding(.vertical, -5.0)
                            .foregroundColor(Color.white)
                        
                        Image("Books spine out ")
                            .resizable()
                            .frame(width: 600, height: 200)
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                            .padding()
                        
                    }
                    
                    TextField("Email", text: $model.email)
                        .frame(width:165, height:20)
                        .font(.custom("Baskerville", size: 20))
                        .padding(.vertical, -5.0)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                    
                    Rectangle()
                        .frame(width:165, height:1)
                        .foregroundColor(.white)
                    
                    SecureField("Password", text: $model.password)
                        .frame(width:165, height:20)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 20))
                        .padding(.vertical, -5.0)
                    
                    Rectangle()
                        .frame(width:165, height:1)
                        .foregroundColor(.white)
                    
                    Button {
                        model.login(email: model.email, password: model.password)
                    } label: {
                        Text("Log In")
                            .frame(minWidth: 0, maxWidth: 300)
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                            .padding(.vertical, -1.0)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        
                    }
                    
                    NavigationLink(destination: register()) {
                        Text("Register for an account here.")
                            .font(.custom("Baskerville", size: 30))
                            .padding(.vertical, -5.0)
                            .foregroundColor(Color("EerieBlack"))
                        
                    }
                    
                    Spacer()
                }
            }
            .accentColor(Color(.label))
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        model.isUserLoggedIn.toggle()
                    }
                }
            }
            
        }
        
    }
    
    
    
    
    
    struct homepage: View {
        
        @ObservedObject var model = ViewModel()
        
        @State var showRemovedAlert = false
        
        @State var showPromotedAlert = false
        
        @State var progressDouble = 0.0
        
        @State var isEditing = false
        
        init() {
            model.fetchCR()
            model.fetchTBR()
        }
        
        var body: some View {
            
            NavigationView {
                
                ZStack {
                    
                    Color("Sage")
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Spine.")
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 60))
                            .padding()
                            .foregroundColor(.white)
                        
                        ScrollView{
                            
                            VStack {
                                
                                Spacer()
                                
                                Text("Currently Reading")
                                    .font(.custom("KAGE_DEMO_FONT-Black", size: 30))
                                    .underline()
                                    .padding(.vertical, -5.0)
                                    .foregroundColor(Color("EerieBlack"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        
                                    
                                    if model.currentlyReading.isEmpty {
                                        Text("Add a book and start tracking!")
                                            .padding()
                                            .font(.custom("Baskerville", size: 20))
                                        
                                    }
                                    else if model.currentlyReading.count == 1 {
                                        ForEach(model.currentlyReading) { book in
                                            HStack{
                                                
                                                Spacer()
                                                
                                                WebImage(url: URL(string: book.cover))
                                                    .resizable()
                                                    .frame(width: 180, height: 220)
                                                
                                                Spacer()
                                                
                                                VStack {
                                                    
                                                    Text(book.title)
                                                        .font(.custom("KAGE_DEMO_FONT-Black",
                                                                      size: 30))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity,
                                                               alignment: .leading)
                                                    
                                                    Text(book.author)
                                                        .font(.custom("Baskerville", size: 25))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity,
                                                               alignment: .leading)
                                                    
                                                    VStack {
                                                        
                                                        VStack {
                                                            Slider (
                                                                value: ($progressDouble),
                                                                in: 0...100,
                                                                step: 1.0,
                                                                onEditingChanged: {editing in
                                                                    isEditing = editing
                                                                }
                                                            )
                                                            //Check colum length
                                                            Text("\(round(progressDouble*10)/10.0)% completed")
                                                        }
                                                        
                                                        Divider()
                                                        
                                                        Button {
                                                            model.removeFromCR(bookToRemove: book)
                                                            showRemovedAlert = true
                                                        } label: {
                                                            Text("Mark as Completed")
                                                                .underline()
                                                        }
                                                        .alert(isPresented: $showRemovedAlert) {
                                                            Alert (
                                                                title: Text("Successfully removed!")
                                                            )
                                                        }
                                                    }
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                
                                else  {
                                    
                                    ForEach(model.currentlyReading) { book in
                                        ScrollView(.horizontal) {
                                            HStack {
                                                
                                                Spacer()
                                                
                                                WebImage(url: URL(string: book.cover))
                                                    .resizable()
                                                    .frame(width: 180, height: 220)
                                                
                                                
                                                Spacer()
                                                
                                                VStack {
                                                    
                                                    Text(book.title)
                                                        .lineLimit(2)
                                                        .font(.custom("KAGE_DEMO_FONT-Black",
                                                                      size: 30))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity,
                                                               alignment: .leading)
                                                    
                                                    Text(book.author)
                                                        .font(.custom("Baskerville", size: 25))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity,
                                                               alignment: .leading)
                                                    
                                                    VStack {
                                                        
                                                        VStack {
                                                            Slider (
                                                                value: ($progressDouble),
                                                                in: 0...100,
                                                                step: 1.0,
                                                                onEditingChanged: {editing in
                                                                    isEditing = editing
                                                                }
                                                            )
                                                            //Check colum length
                                                            Text("\(round(progressDouble*10)/10.0)% completed")
                                                                .font(.custom("Baskerville", size:15))
                                                        }
                                                        
                                                        Divider()
                                                        
                                                        Button {
                                                            model.removeFromCR(bookToRemove: book)
                                                            showRemovedAlert = true
                                                        } label: {
                                                            Text("Mark as Completed")
                                                                .underline()
                                                                .font(.custom("Baskerville", size:15))
                                                        }
                                                        .alert(isPresented: $showRemovedAlert) {
                                                            Alert (
                                                                title: Text("Successfully removed!")
                                                            )
                                                        }
                                                    }
                                                }
                                                Spacer()
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Text("To Be Read")
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 30))
                                .underline()
                                .padding(.vertical, -5.0)
                                .foregroundColor(Color("EerieBlack"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal) {
                                
                                HStack {
                                    
                                    if model.toBeRead.isEmpty {
                                        Text("Add some books you want to read next!")
                                            .font(.custom("Baskerville", size: 20))
                                            .padding()
                                    } else {
                                        
                                        ForEach(model.toBeRead) { book in
                                            
                                            HStack {
                                                Spacer()
                                                
                                               
                                                WebImage(url: URL(string: book.cover))
                                                    .resizable()
                                                    .frame(width: 180, height: 220)
                                                
                                                VStack {
                                                    
                                                    Text(book.title)
                                                        .font(.custom("KAGE_DEMO_FONT-Black", size: 30))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Text(book.author)
                                                        .font(.custom("Baskerville", size: 25))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    VStack {
                                                        
                                                        Button {
                                                            showPromotedAlert = true
                                                            // model.promoteToCR()
                                                        } label: {
                                                            Text("Move to Currently Reading")
                                                                .underline()
                                                                .font(.custom("Baskerville", size:15))
                                                        }
                                                        .alert(isPresented: $showPromotedAlert) {
                                                            Alert (
                                                                title: Text("Moved to your Currently Reading shelf!")
                                                            )
                                                        }
                                                        
                                                        Divider ()
                                                        
                                                        Button {
                                                            model.removeFromTBR(bookToRemove: book)
                                                            showRemovedAlert = true
                                                        } label: {
                                                            Text("Remove")
                                                                .underline()
                                                                .font(.custom("Baskerville", size:15))
                                                        }
                                                        .alert(isPresented: $showRemovedAlert) {
                                                            Alert (
                                                                title: Text("Successfully removed!")
                                                            )
                                                        }
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
            }
        }

        
    }
    
    
    struct register: View {
        
        @EnvironmentObject var model: ViewModel
        
        @State  var newEmail = ""
        
        @State var newPassword = ""
        
        @State var confirmPassword = ""
        
        @State  var dob = Date()
        
        @State var showRegisteredAlert = true
        
        
        var body: some View {
            
            ZStack {
                
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("Enter your details")
                        .font(.custom("KAGE_DEMO_FONT-Black", size: 55))
                        .padding(.vertical, -3.0)
                        .foregroundColor(Color("EerieBlack"))
                        .padding()
                    
                    TextField("Name", text: $model.name)
                        .padding(.leading, 10.0)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 30))
                    
                    Rectangle()
                        .frame(width:400, height:1)
                        .foregroundColor(Color("Ebony"))
                    
                    HStack {
                        
                        Text("Date of Birth")
                            .foregroundColor(.white)
                            .font(.custom("Baskerville", size: 30))
                            .padding(.leading, 10.0)
                        
                        DatePicker (
                            "",
                            selection: $dob,
                            displayedComponents: [.date]
                        ).accentColor(.black)
                            .padding()
                        
                    }
                    
                    TextField("Email address", text: $newEmail)
                        .foregroundColor(.white)
                        .padding(.leading, 10.0)
                        .font(.custom("Baskerville", size: 30))
                        .autocapitalization(.none)
                    
                    Rectangle()
                        .frame(width:400, height:1)
                        .foregroundColor(Color("ArmyGreen"))
                    
                    VStack {
                        
                        SecureField("Password", text: $newPassword)
                            .foregroundColor(.white)
                            .padding(.leading, 10.0)
                            .font(.custom("Baskerville", size: 30))
                            .autocapitalization(.none)
                        
                        Rectangle()
                            .frame(width:400, height:1)
                            .foregroundColor(Color("ArmyGreen"))
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .foregroundColor(.white)
                            .padding(.leading, 10.0)
                            .font(.custom("Baskerville", size: 30))
                            .autocapitalization(.none)
                        
                        Rectangle()
                            .frame(width:400, height:1)
                            .foregroundColor(Color("ArmyGreen"))
                        
                        Spacer()
                        
                        Button {
                            showRegisteredAlert = true
                            model.registerUser(email: newEmail, password: newPassword)
                        } label: {
                            Text("Register")
                                .foregroundColor(Color("EerieBlack"))
                                .underline()
                                .bold()
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 60))
                                .padding()
                        }
                        .alert(isPresented: $showRegisteredAlert) {
                            Alert (
                                title: Text("Successfully registered!")
                            )
                        }
                        
                        Text(model.userAccountStatusMessage)
                            .foregroundColor(.white)
                            .padding([.leading, .trailing])
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                //Check what addStateDidChangeListener means?
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        model.isUserLoggedIn.toggle()
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    struct allBooks: View {
        
        @ObservedObject var model = ViewModel()
        
        @State var showNewBookForm = false
        
        @State var showSearchPage = false
        
        @State var addedToCR = false
        
        @State var addedToTBR = false
        
        init() {
            
            UITableView.appearance().separatorStyle = .none
            
            UITableViewCell.appearance().backgroundColor = .clear
            
            UITableView.appearance().backgroundColor = .clear
            
        }
        
        var body: some View {
            
            NavigationView {
                
                ZStack {
                    
                    Color("Sage")
                        .ignoresSafeArea(.all)
                    
                    VStack {
                        
                        VStack {
                            
                            Text("Find a book")
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                                .foregroundColor(.white)
                            
                            Button {
                                showNewBookForm.toggle()
                            } label: {
                                Image(systemName: "plus")
                                Text("Add a book")
                            }
                            .sheet(isPresented: $showNewBookForm){
                                addNewBook()
                            }
                            
                            
                            Button {
                                showSearchPage.toggle()
                            } label: {
                                Text("Search")
                                Image(systemName: "magnifyingglass.circle.fill")
                            }
                            .sheet(isPresented: $showSearchPage) {
                                searchForBook()
                            }
                        }
                        
                        ScrollView {
                            
                            VStack {
                                
                                ForEach(model.list) { book in
                                    
                                    VStack {
                                        
                                        HStack {
                                            
                                            VStack {
                                                Text(book.title)
                                                    .font(.custom("KAGE_DEMO_FONT-Black", size:30))
                                                    .foregroundColor(Color("EerieBlack"))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text(book.author)
                                                    .font(.custom("Baskerville", size:20))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                
                                                HStack {
                                                    Button (action: {
                                                        addedToCR = true
                                                        model.handleAddToCurrentlyReading(author: book.author, title: book.title, genre: book.genre, cover: book.cover, blurb: book.blurb, id: book.id)
                                                        
                                                    }, label: {
                                                        Image(systemName: "plus")
                                                            .foregroundColor(Color("ArmyGreen"))
                                                        Text("Currently Reading")
                                                            .foregroundColor(Color("ArmyGreen"))
                                                            .font(.custom("Baskerville", size: 15))
                                                            .underline()
                                                    })
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .buttonStyle(BorderlessButtonStyle())
                                                    .alert(isPresented: $addedToCR) {
                                                        Alert (
                                                            title: Text("Successfully added to your Currently Reading!")
                                                        )
                                                    }
                                                    
                                                    Button (action: {
                                                        addedToTBR = true
                                                        model.handleAddToToBeRead(author: book.author, title: book.title, genre: book.genre, cover: book.cover, blurb: book.blurb, id: book.id)
                                                        
                                                    }, label: {
                                                        Image(systemName: "plus")
                                                            .foregroundColor(Color("ArmyGreen"))
                                                        Text("To be read")
                                                            .foregroundColor(Color("ArmyGreen"))
                                                            .font(.custom("Baskerville", size: 15))
                                                            .underline()
                                                    })
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .buttonStyle(BorderlessButtonStyle())
                                                    .alert(isPresented: $addedToTBR) {
                                                        Alert (
                                                            title: Text("Successfully add to your To Be Read!")
                                                        )
                                                    }
                                                    
                                                    
                                                }
                                            }
                                           
                                            WebImage(url: URL(string: book.cover))
                                                .resizable()
                                                .frame(width: 80, height: 100)
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                .background(Color("Sage"))
                                
                            }
                            .padding()
                            
                            
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
    
    struct addNewBook: View {
        
        @ObservedObject var model = ViewModel()
        
        @State private var bookAddedAlert = false
        
        var body: some View {
            
            ZStack{
                
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("Add a book to our collection")
                    
                    TextField("Title", text: $model.newTitle)
                    
                    TextField("Author", text: $model.newAuthor)
                    
                    TextField("Genre", text: $model.newGenre)
                    
                    TextField("Cover Image (as URL)", text:$model.newCover)
                    
                    Button {
                        bookAddedAlert = true
                        model.addBook(author: model.newAuthor, title: model.newTitle, genre: model.newGenre, cover: model.newCover, blurb: model.newBlurb)
                    } label: {
                        Text("Add book")
                    }
                    .alert(isPresented: $bookAddedAlert) {
                        Alert(
                            title: Text("Book added!"))
                    }
                }
            }
            
        }
    }
    
    struct searchForBook: View {
        
        @ObservedObject var model = ViewModel()
        
        @State var searchTextTitle = ""
        
        @State var searchTextAuthor = ""
        
        @State var addedToCR = false
        
        @State var addedToTBR = false
        
        var body: some View {
            
            ZStack {
                
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    VStack {
                        
                        Spacer()
                        
                        Text("Search for a book by title")
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 30))
                            .foregroundColor(.white)
                        
                        TextField("Search by title", text:$searchTextTitle)
                            .font(.custom("Baskerville", size: 20))
                            .foregroundColor(.white)
                        
                        Button {
                            model.searchedByTitleResults = []
                            model.fetchSearchedByTitle(with: searchTextTitle)
                        } label: {
                            Text("Search")
                                .foregroundColor(Color("ArmyGreen"))
                                .font(.custom("Baskerville", size: 20))
                                .underline()
                        }
                        
                        if model.searchedByTitleResults.count > 0 {
                            Button {
                                model.searchedByTitleResults = []
                            } label: {
                                Text("Clear search")
                            }
                        }
                        
                        ForEach(model.searchedByTitleResults) { book in
                            VStack {
                                HStack {
                                    VStack {
                                        Text(book.title)
                                            .font(.custom("KAGE_DEMO_FONT-BLACK", size: 30))
                                            .foregroundColor(Color("EerieBlack"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text(book.author)
                                            .font(.custom("Baskerville", size: 20))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack {
                                            Button (action: {
                                                addedToCR = true
                                                model.handleAddToCurrentlyReading(author: book.author,  title: book.title, genre: book.genre, cover: book.cover, blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                Text("Currently Reading")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                    .font(.custom("Baskerville", size: 15))
                                                    .underline()
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .alert(isPresented: $addedToCR) {
                                                Alert (
                                                    title: Text("Successfully added to your Currently Reading!")
                                                )
                                            }
                                            
                                            Button (action: {
                                                addedToTBR = true
                                                model.handleAddToToBeRead(author: book.author, title: book.title, genre: book.genre, cover: book.cover, blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                Text("To be read")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                    .font(.custom("Baskerville", size: 15))
                                                    .underline()
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .alert(isPresented: $addedToTBR) {
                                                Alert (
                                                    title: Text("Successfully add to your To Be Read!")
                                                )
                                            }
                                            
                                            
                                        }
                                    }
                                    WebImage(url: URL(string: book.cover))
                                        .resizable()
                                        .frame(width:80, height: 100)
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        Spacer()
                        
                        Text("Search for a book by author")
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 30))
                            .foregroundColor(.white)
                        
                        TextField("Search by author", text:$searchTextAuthor)
                            .font(.custom("Baskerville", size: 20))
                            .foregroundColor(.white)
                        
                        Button {
                            model.searchedByAuthorResults = []
                            model.fetchSearchedByAuthor(with: searchTextAuthor)
                        } label: {
                            Text("Search")
                                .foregroundColor(Color("ArmyGreen"))
                                .font(.custom("Baskerville", size: 20))
                                .underline()
                        }
                        
                        if model.searchedByAuthorResults.count > 0 {
                            Button {
                                model.searchedByAuthorResults = []
                            } label: {
                                Text("Clear search")
                            }
                        }
                        
                        Spacer()
                        
                        ForEach(model.searchedByAuthorResults) { book in
                            VStack {
                                HStack {
                                    VStack {
                                        Text(book.title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.custom("KAGE_DEMO_FONT-BLACK", size: 30))
                                            .foregroundColor(Color("EerieBlack"))
                                        
                                        Text(book.author)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.custom("Baskerville", size: 20))
                                            .foregroundColor(.white)
                                        
                                        HStack {
                                            Button (action: {
                                                addedToCR = true
                                                model.handleAddToCurrentlyReading(author: book.author,  title: book.title, genre: book.genre, cover: book.cover, blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                Text("Currently Reading")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                    .font(.custom("Baskerville", size: 15))
                                                    .underline()
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .alert(isPresented: $addedToCR) {
                                                Alert (
                                                    title: Text("Successfully added to your Currently Reading!")
                                                )
                                            }
                                            
                                            Button (action: {
                                                addedToTBR = true
                                                model.handleAddToToBeRead(author: book.author, title: book.title, genre: book.genre, cover: book.cover, blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                Text("To be read")
                                                    .foregroundColor(Color("ArmyGreen"))
                                                    .font(.custom("Baskerville", size: 15))
                                                    .underline()
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .alert(isPresented: $addedToTBR) {
                                                Alert (
                                                    title: Text("Successfully add to your To Be Read!")
                                                )
                                            }
                                            
                                            
                                        }
                                    }
                                    WebImage(url: URL(string: book.cover))
                                        .resizable()
                                        .frame(width: 80, height: 100)
                                    
                                }
                            }
                        }
                        
                        
                    }
                }
                .padding()
            }
        }
    }
    
    struct profile: View {
        
        @EnvironmentObject var model: ViewModel
        
        var body: some View {
            
            ZStack {
                
                Color("Sage")
                    .ignoresSafeArea(.all)
                
                VStack {
                    
                    NavigationLink (destination: Text("Personal info"), label: {
                        Text("Personal Info")
                    })
                    
                    Button {
                        
                        model.signOut()
                        
                    } label: {
                        Text("Sign out")
                    }
                    
                }
                
            }
            
        }
        
        
        
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
        }
    }
    
    
    struct homepage_Previews: PreviewProvider {
        static var previews: some View {
            homepage()
        }
    }
    
    struct register_Previews: PreviewProvider {
        static var previews: some View {
            register()
        }
    }
    
    struct search_Previews: PreviewProvider {
        static var previews: some View {
            allBooks()
        }
    }
}

