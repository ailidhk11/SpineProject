

//
//  Model.swift
//  SpineProject
//
//  Created by Ailidh Kinney on 22/07/2022.
//
import Foundation
import SwiftUI
import Firebase

struct SpineBook: Identifiable {
    
    // Check capitalisation of variable labels
    var id: String
    var author: String
    var genre: String
    var title: String
    var cover: String
    var blurb: String
    
}
