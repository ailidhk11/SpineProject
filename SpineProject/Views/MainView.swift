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
    
    @State var showRegistrationForm = false
    
    var body: some View {
        
        if model.isUserLoggedIn == false {
            
            Content
            
        } else {
            
            TabView {
                Homepage()
                    .tabItem {
                        Label("Home", systemImage: "house")
                        Text("Home")
                    }
                
                AllBooks()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass.circle.fill")
                        Text("Search")
                    }
                
                Profile()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                
                
            }
            
            
            
        }
        
        
    }
    
    
    
    
    
    var Content: some View {
        
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
                    
                    Button  {
                        self.showRegistrationForm.toggle()
                    } label: {
                        Text("Register for an account here.")
                            .font(.custom("Baskerville", size: 30))
                            .padding(.vertical, -5.0)
                            .foregroundColor(Color("EerieBlack"))
                        
                    }
                    .sheet(isPresented: $showRegistrationForm) {
                        Register()
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
    
    
    struct Homepage: View {
        
        @ObservedObject var model = ViewModel()
        
        @State var showRemovedAlert = false
        
        @State var showPromotedAlert = false
        
        @State var isEditing = false
        
        @State var showFilledBlock = false
        
        @State var showFilledBlock2 = false
        
        @State var showFilledBlock3 = false
        
        @State var showFilledBlock4 = false
        
        @State var showFinishedAlert = false
        
        
        init() {
            
            model.fetchCR()
            model.getBooks()
            model.fetchTBR()
            
        }
        
        var body: some View {
            
            
            ZStack {
                
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("Spine.")
                        .underline()
                        .font(.custom("KAGE_DEMO_FONT-Black", size: 80))
                        .padding(.vertical, -5.0)
                        .foregroundColor(.white)
                    
                    ScrollView{
                        
                        VStack {
                            
                            Text("Currently Reading")
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 40))
                                .underline()
                                .padding(.vertical, -5.0)
                                .foregroundColor(Color("EerieBlack"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            if model.currentlyReading.isEmpty {
                                
                                Text("Add a book and start tracking!")
                                    .padding()
                                    .font(.custom("Baskerville", size: 20))
                                
                            } else  {
                                
                                ScrollView(.horizontal) {

                                    HStack{
                                        
                                        Spacer()
                                        
                                        WebImage(url: URL(string: model.currentlyReading[0].cover))
                                            .resizable()
                                            .frame(width: 180, height: 220)
                                            .padding()
                                            .shadow(color: .gray, radius: 6, x: 1.0, y: 1.0)
                                        
                                        Spacer()
                                        
                                        VStack {
                                            
                                            Text(model.currentlyReading[0].title)
                                                .font(.custom("KAGE_DEMO_FONT-Black",
                                                              size: 30))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity,
                                                       alignment: .leading)
                                            
                                            Text("By \(model.currentlyReading[0].author)")
                                                .font(.custom("Baskerville", size: 25))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity,
                                                       alignment: .leading)
                                            
                                            Rectangle()
                                                .frame(width: 200, height: 1)
                                            
                                            VStack {
                                                
                                                VStack {
                                                    
                                                    Text("Progress")
                                                        .font(.custom("Baskerville", size: 25))
                                                        .foregroundColor(.white)
                                                    
                                                    
                                                    HStack {
                                                        
                                                        Button {
                                                            showFilledBlock.toggle()
                                                        } label: {
                                                            
                                                            if showFilledBlock == true {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName:
                                                                            "rectangle.fill")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    Text("25%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(
                                                                            Color("EerieBlack"))
                                                                }
                                                                
                                                            } else {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName: "rectangle")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    
                                                                    Text("25%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(.white)
                                                                }
                                                                
                                                            }
                                                        }
                                                        
                                                        
                                                        Button {
                                                            showFilledBlock = true
                                                            showFilledBlock2.toggle()
                                                        } label: {
                                                            
                                                            if showFilledBlock2 == true {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName:
                                                                            "rectangle.fill")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    Text("50%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(
                                                                            Color("EerieBlack"))
                                                                    
                                                                }
                                                                
                                                            } else {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName: "rectangle")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    Text("50%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(.white)
                                                                }
                                                            }
                                                        }
                                                        
                                                        
                                                        Button {
                                                            showFilledBlock = true
                                                            showFilledBlock2 = true
                                                            showFilledBlock3.toggle()
                                                        } label: {
                                                            if showFilledBlock3 == true {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName:
                                                                            "rectangle.fill")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    Text("75%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(
                                                                            Color("EerieBlack"))
                                                                }
                                                                
                                                            } else {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName: "rectangle")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    Text("75%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(.white)
                                                                    
                                                                }
                                                            }
                                                        }
                                                        
                                                        
                                                        Button {
                                                            showFilledBlock = true
                                                            showFilledBlock2 = true
                                                            showFilledBlock3 = true
                                                            showFilledBlock4.toggle()
                                                        } label: {
                                                            
                                                            if showFilledBlock4 == true {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName:
                                                                            "rectangle.fill")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    Text("100%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(
                                                                            Color("EerieBlack"))
                                                                    
                                                                }
                                                                
                                                            } else {
                                                                
                                                                ZStack {
                                                                    
                                                                    Image(systemName: "rectangle")
                                                                        .foregroundColor(.white)
                                                                        .padding(.horizontal, -5.0)
                                                                        .font(.system(size: 30))
                                                                    
                                                                    Text("100%")
                                                                        .font(.custom(
                                                                            "Baskerville",
                                                                            size: 15))
                                                                        .foregroundColor(.white)
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                                Rectangle()
                                                    .frame(width: 200, height: 1)
                                                
                                                Button {
                                                    model.removeFromCR(bookToRemove:
                                                                        model.currentlyReading[0])
                                                    self.showFilledBlock = false
                                                    self.showFilledBlock2 = false
                                                    self.showFilledBlock3 = false
                                                    self.showFilledBlock4 = false
                                                    showFinishedAlert = true
                                                } label: {
                                                    Text("Finished")
                                                        .underline()
                                                        .font(.custom("Baskerville", size: 25))
                                                        .foregroundColor(.white)
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size:20))
                                                }
                                                .alert(isPresented: $showFinishedAlert) {
                                                    Alert (
                                                        title: Text("Time for the next one!")
                                                    )
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        Spacer()
                        
                        Rectangle()
                            .frame(width:350, height: 1)
                            .foregroundColor(Color("ArmyGreen"))
                        
                        Spacer()
                        
                        Text("To Be Read")
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 40))
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
                                        
                                        VStack {
                                            
                                            Spacer()
                                            
                                            WebImage(url: URL(string: book.cover))
                                                .resizable()
                                                .frame(width: 120, height: 180)
                                            
                                            
                                            Text(book.title)
                                                .font(.custom("KAGE_DEMO_FONT-Black", size: 25))
                                                .foregroundColor(.white)
                                            
                                            Text(book.author)
                                                .font(.custom("Baskerville", size: 20))
                                                .foregroundColor(.white)
                                            
                                            HStack {
                                                
                                                Button {
                                                    showPromotedAlert = true
                                                    model.removeFromTBR(bookToRemove: book)
                                                    model.handleAddToCurrentlyReading(
                                                        author: book.author, title: book.title,
                                                        genre: book.genre, cover: book.cover,
                                                        blurb: book.blurb, id: book.id)
                                                    self.showFilledBlock = false
                                                    self.showFilledBlock2 = false
                                                    self.showFilledBlock3 = false
                                                    self.showFilledBlock4 = false
                                                    
                                                } label: {
                                                    Image(systemName: "arrow.up.heart.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 20))
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
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 20))
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
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            
            
        }
        
        
    }
    
    
    
    struct Register: View {
        
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
                        
                        Text("Password must be at least 6 characters in length.")
                            .foregroundColor(.white)
                            .font(.custom("Baskerville", size: 20))
                            .padding(.leading, 10.0)
                        
                        Spacer()
                        
                        Button {
                            model.registerUser(email: newEmail, password: newPassword)
                        } label: {
                            Text("Register")
                                .foregroundColor(Color("EerieBlack"))
                                .underline()
                                .bold()
                                .font(.custom("KAGE_DEMO_FONT-Black", size: 60))
                                .padding()
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
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        
                        model.isUserLoggedIn.toggle()
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    struct AllBooks: View {
        
        @ObservedObject var model = ViewModel()
        
        @State var showNewBookForm = false
        
        @State var showSearchPage = false
        
        @State var addedToCR = false
        
        @State var addedToTBR = false
        
        
        var body: some View {
            
            ZStack {
                
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    VStack {
                        
                        Text("Find a book")
                            .underline()
                            .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                            .foregroundColor(.white)
                            .padding(.vertical, -5.0)
                        
                        HStack {
                            
                            Button {
                                showNewBookForm.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(Color("ArmyGreen"))
                                Text("Add a book")
                                    .foregroundColor(Color("ArmyGreen"))
                                    .font(.custom("Baskerville", size: 20))
                            }
                            .sheet(isPresented: $showNewBookForm){
                                AddNewBook()
                            }
                            
                            Rectangle()
                                .frame(width: 1, height: 40)
                                .foregroundColor(Color("ArmyGreen"))
                            
                            Button {
                                showSearchPage.toggle()
                            } label: {
                                Text("Search for a book")
                                    .foregroundColor(Color("ArmyGreen"))
                                    .font(.custom("Baskerville", size: 20))
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .foregroundColor(Color("ArmyGreen"))
                            }
                            .sheet(isPresented: $showSearchPage) {
                                SearchForBook()
                            }
                        }
                    }
                    
                    
                        
                        VStack {
                            ScrollView {
                            
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
                                                    model.handleAddToCurrentlyReading(
                                                        author: book.author, title: book.title,
                                                        genre: book.genre, cover: book.cover,
                                                        blurb: book.blurb, id: book.id)
                                                    
                                                }, label: {
                                                    ZStack{
                                                        
                                                        Image(systemName: "capsule.fill")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 30))
                                                            .padding(.horizontal, 10.0)
                                                        HStack{
                                                            
                                                    Image(systemName: "plus")
                                                        .foregroundColor(Color("Sage"))
                                                        .font(.system(size: 10))
                                                        .padding(.horizontal, -11.0)
                                                    Text("CR")
                                                        .foregroundColor(Color("Sage"))
                                                        .padding(.horizontal, -10.0)
                                                        .font(.custom("Baskerville", size: 15))
                                                    }
                                                        
                                                }
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
                                                    model.handleAddToToBeRead(
                                                        author: book.author, title: book.title,
                                                        genre: book.genre, cover: book.cover,
                                                        blurb: book.blurb, id: book.id)
                                                    
                                                }, label: {
                                                    ZStack{
                                                        
                                                        Image(systemName: "suit.heart.fill")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 35))
                                                            .padding(.horizontal, 30.0)
                                                        HStack{
                                                            
                                                    Image(systemName: "plus")
                                                        .foregroundColor(Color("Sage"))
                                                        .font(.system(size: 10))
                                                        .padding(.horizontal, -11.0)
                                                    Text("TBR")
                                                        .foregroundColor(Color("Sage"))
                                                        .padding(.horizontal, -10.0)
                                                        .font(.custom("Baskerville", size: 10))
                                                    }
                                                        
                                                }
    
                                                })
                                                .offset(x: -180.0, y: 0)
                                                .buttonStyle(BorderlessButtonStyle())
                                                .alert(isPresented: $addedToTBR) {
                                                    Alert (
                                                        title: Text("Successfully add to your To Be Read!")
                                                    )
                                                }
                                                
                                                Spacer()
                                                
                                                
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        WebImage(url: URL(string: book.cover))
                                            .resizable()
                                            .frame(width: 80, height: 100)
                                        
                                        
                                        
                                    }
                                    
                                    Rectangle()
                                        .frame(width: 400, height: 1)
                                        .foregroundColor((Color("ArmyGreen")))
                                    
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
    
    struct AddNewBook: View {
        
        @ObservedObject var model = ViewModel()
        
        @State private var bookAddedAlert = false
        
        var body: some View {
            
            ZStack{
                
                Color("Sage")
                    .ignoresSafeArea()
                
                VStack {
                    
                    Spacer ()
                    
                    Text("Add a book to Spine")
                        .underline()
                        .font(.custom("KAGE_DEMO_FONT-Black", size: 40))
                        .foregroundColor(.white)
                        .padding(.vertical, -5.0)

                    TextField("Title", text: $model.newTitle)
                        .padding(.leading, 10.0)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 20))
                    
                    TextField("Author", text: $model.newAuthor)
                        .padding(.leading, 10.0)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 20))
                    
                    TextField("Genre", text: $model.newGenre)
                        .padding(.leading, 10.0)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 20))
                    
                    TextField("Cover Image (as URL)", text:$model.newCover)
                        .padding(.leading, 10.0)
                        .foregroundColor(.white)
                        .font(.custom("Baskerville", size: 20))
                    
                    
                    Button {
                        bookAddedAlert = true
                        model.addBook(author: model.newAuthor, title: model.newTitle,
                                      genre: model.newGenre, cover: model.newCover,
                                      blurb: model.newBlurb)
                        model.newTitle = ""
                        model.newAuthor = ""
                        model.newCover = ""
                        model.newGenre = ""
                    } label: {
                        Text("Add book")
                            .underline()
                            .padding(.leading, 10.0)
                            .foregroundColor(.white)
                            .font(.custom("Baskerville", size: 40))
                    }
                    .alert(isPresented: $bookAddedAlert) {
                        Alert(
                            title: Text("Book added!"))
                    }
                    
                    Spacer()
                    
                }
                .padding()
            }
            
        }
    }
    
    struct SearchForBook: View {
        
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
                    
                    ScrollView {
                    
                    Spacer()
                    
                    Text("Search")
                        .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                        .foregroundColor(.white)
                        .underline()
                    
                    
                    VStack {
                        
                        Spacer()
                        
                        Text("Search for a book by title")
                            .font(.custom("Baskerville", size: 30))
                            .foregroundColor(Color("EerieBlack"))
                        
                        TextField("Search by title", text:$searchTextTitle)
                            .font(.custom("Baskerville", size: 25))
                            .foregroundColor(.white)
                        
                        Button {
                            model.searchedByTitleResults = []
                            model.fetchSearchedByTitle(with: searchTextTitle)
                        } label: {
                            Text("Search")
                                .foregroundColor(Color("ArmyGreen"))
                                .font(.custom("Baskerville", size: 30))
                                .underline()
                        }
                        
                        Spacer()
                        
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
                                                model.handleAddToCurrentlyReading(
                                                    author: book.author,  title: book.title,
                                                    genre: book.genre, cover: book.cover,
                                                    blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                
                                                ZStack{
                                                    
                                                    Image(systemName: "capsule.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 30))
                                                        .padding(.horizontal, 10.0)
                                                    HStack{
                                                        
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("Sage"))
                                                    .font(.system(size: 10))
                                                    .padding(.horizontal, -11.0)
                                                Text("CR")
                                                    .foregroundColor(Color("Sage"))
                                                    .padding(.horizontal, -10.0)
                                                    .font(.custom("Baskerville", size: 15))
                                                }
                                                    
                                            }
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
                                                model.handleAddToToBeRead(
                                                    author: book.author, title: book.title,
                                                    genre: book.genre, cover: book.cover,
                                                    blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                ZStack{
                                                    
                                                    Image(systemName: "capsule.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 30))
                                                        .padding(.horizontal, 10.0)
                                                    HStack{
                                                        
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("Sage"))
                                                    .font(.system(size: 10))
                                                    .padding(.horizontal, -11.0)
                                                Text("TBR")
                                                    .foregroundColor(Color("Sage"))
                                                    .padding(.horizontal, -10.0)
                                                    .font(.custom("Baskerville", size: 15))
                                                }
                                                    
                                            }
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
                        
                        if model.searchedByTitleResults.count > 0 {
                            
                            Button {
                                model.searchedByTitleResults = []
                                searchTextTitle = ""
                            } label: {
                                Text("Clear search")
                                    .foregroundColor(Color("EerieBlack"))
                                    .font(.custom("Baskerville", size: 20))
                                    .underline()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(Color("EerieBlack"))
                        .frame(width: 400, height: 1)
                    
                    Spacer ()
                    
                    VStack {
                        
                        Spacer()
                        
                        Text("Search for a book by author")
                            .font(.custom("Baskerville", size: 30))
                            .foregroundColor(Color("EerieBlack"))
                        
                        TextField("Search by author", text:$searchTextAuthor)
                            .font(.custom("Baskerville", size: 25))
                            .foregroundColor(.white)
                        
                        Button {
                            model.searchedByAuthorResults = []
                            model.fetchSearchedByAuthor(with: searchTextAuthor)
                        } label: {
                            Text("Search")
                                .foregroundColor(Color("ArmyGreen"))
                                .font(.custom("Baskerville", size: 30))
                                .underline()
                        }
                        
                        Spacer()
                        
                        
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
                                                model.handleAddToCurrentlyReading(
                                                    author: book.author,  title: book.title,
                                                    genre: book.genre, cover: book.cover,
                                                    blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                ZStack{
                                                    
                                                    Image(systemName: "capsule.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 30))
                                                        .padding(.horizontal, 10.0)
                                                    HStack{
                                                        
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("Sage"))
                                                    .font(.system(size: 10))
                                                    .padding(.horizontal, -11.0)
                                                Text("CR")
                                                    .foregroundColor(Color("Sage"))
                                                    .padding(.horizontal, -10.0)
                                                    .font(.custom("Baskerville", size: 15))
                                                }
                                                    
                                            }
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .alert(isPresented: $addedToCR) {
                                                Alert (
                                                    title: Text("Successfully added to your Currently Reading!")
                                                )
                                            }
                                            
                                            Divider()
                                            
                                            Button (action: {
                                                addedToTBR = true
                                                model.handleAddToToBeRead(
                                                    author: book.author, title: book.title,
                                                    genre: book.genre, cover: book.cover,
                                                    blurb: book.blurb, id: book.id)
                                                
                                            }, label: {
                                                ZStack{
                                                    
                                                    Image(systemName: "capsule.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 30))
                                                        .padding(.horizontal, 10.0)
                                                    HStack{
                                                        
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color("Sage"))
                                                    .font(.system(size: 10))
                                                    .padding(.horizontal, -11.0)
                                                Text("TBR")
                                                    .foregroundColor(Color("Sage"))
                                                    .padding(.horizontal, -10.0)
                                                    .font(.custom("Baskerville", size: 15))
                                                }
                                                    
                                            }
                                            })
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .alert(isPresented: $addedToTBR) {
                                                Alert (
                                                    title: Text("Successfully add to your To Be Read!")
                                                )
                                            }
                                           
                                            Spacer()
                                            
                                        }
                                    }
                                    
                                    WebImage(url: URL(string: book.cover))
                                        .resizable()
                                        .frame(width: 80, height: 100)
                                    
                                }
                            }
                        }
                        
                        if model.searchedByAuthorResults.count > 0 {
                            
                            Button {
                                model.searchedByAuthorResults = []
                                searchTextAuthor = ""
                            } label: {
                                Text("Clear search")
                                    .foregroundColor(Color("EerieBlack"))
                                    .font(.custom("Baskerville", size: 20))
                                    .underline()
                            }
                        }
                        
                    }
                }
                }
                .padding()
            }
        }
    }
    
    struct Profile: View {
        
        @EnvironmentObject var model: ViewModel
        
        var body: some View {
            
            ZStack {
                
                Color("Sage")
                    .ignoresSafeArea(.all)
                
                ScrollView {
                VStack {
                    
                    Spacer()
                    
                    Text("Ready to go?")
                        .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                        .underline()
                        .foregroundColor(Color.white)

                    Button {
                        
                        model.signOut()
                        
                    } label: {
                        Text("Sign out here")
                            .underline()
                            .font(.custom("Baskerville", size: 30))
                            .foregroundColor(Color("EerieBlack"))
                    }

                    Divider()
                    
                    Text("Ready to go, for good?")
                        .font(.custom("KAGE_DEMO_FONT-Black", size: 50))
                        .underline()
                        .foregroundColor(Color.white)

                    Button {
                        
                        model.deleteAccount()
                        
                    } label: {
                        Text("Delete your account")
                            .underline()
                            .font(.custom("Baskerville", size: 30))
                            .foregroundColor(Color("EerieBlack"))
                    }
                    
 

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
            Homepage()
        }
    }
    
    struct register_Previews: PreviewProvider {
        static var previews: some View {
            Register()
        }
    }
    
    struct search_Previews: PreviewProvider {
        static var previews: some View {
            AllBooks()
        }
    }
}
