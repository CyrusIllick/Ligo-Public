//
//  Contact.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/1/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation

class Contact: NSObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case firstname,lastname, username
    }
    
    enum ExpressionKeys: String {
        case firstname, lastname, username
    }
    
    // MARK: - Properties
    
    @objc var firstname: String
    @objc var lastname: String
    @objc var username: String
    
    
    // MARK: - Initializers
    
    ///Init has to have a username and name
    init(firstname: String,lastname: String, username: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
    }
    
    ///Required for initilizing this class
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstname = try container.decode(String.self, forKey: .firstname)
        lastname = try container.decode(String.self, forKey: .lastname)

        username = try container.decode(String.self, forKey: .username)
    }
    
    // MARK: - Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstname, forKey: .firstname)
        try container.encode(lastname, forKey: .lastname)

        try container.encode(username, forKey: .username)
    }
}
