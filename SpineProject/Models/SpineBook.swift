

//
//  Model.swift
//  SpineProject
//
//  Created by Ailidh Kinney on 22/07/2022.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

/// The SpineBooks struct 
struct SpineBook: Identifiable, Codable {
    

    var id: String
    var author: String
    var genre: String
    var title: String
    var cover: String
    var blurb: String
    
}
