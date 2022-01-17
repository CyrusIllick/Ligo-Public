//
//  Contact.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/27/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation

/// Class to store all of the useful information from the databse
class Identity:Equatable {
     //MARK: - Compareable Properties
    
    
    static func == (lhs: Identity, rhs: Identity) -> Bool {
            return lhs.username == rhs.username

    }
    
    
    //MARK: - Propertis
    var username: String
    var firstName:String
    var lastName:String
    var identity: String
    var bio: String?
    var work: String?
    var phone: String?
    var email: String?
    var facebook: String?
    var instagram: String?
    var snapchat: String?
    var website: String?
    var linkedin: String?
    var website2: String?
    var website3: String?
    var github: String?
    var tiktok: String?
    var applemusic: String?
    var spotify: String?
    var youtube: String?
    var twitter: String?
    var venmo: String?
    var website4: String?
    var soundcloud: String?
    var whatsapp: String?
    var isPublic: Bool?
    var grad1: String?
    var grad2: String?
    var isVerified: Bool?
    var profileImage:String?
    var friends:[String]?
    var websites = [String]()
    
    /// Enum to differentiate the different fields in a card
    enum detailType {
        case username,firstName,lastName, identity, bio, work, phone, email, facebook, instagram, snapchat, website, linkedin, website2, website3, github, tiktok, applemusic, spotify, youtube, twitter, venmo, website4, soundcloud, whatsapp, grad1, grad2,profileImage
    }
    
    //MARK: - Initilizer
    /* Initilizes with a name and identity, everthing is set to nil*/
    init(name: String, identity: String?,firstName:String, lastName:String) {
        self.username = name
        self.firstName = firstName
        self.lastName = lastName
        
        if let identity = identity {
            self.identity = identity
        } else {
            self.identity = "Default"
        }
        self.bio = nil

        self.bio = nil
        self.work = nil
        self.phone = nil
        self.email = nil
        self.facebook = nil
        self.instagram = nil
        self.snapchat = nil
        self.website = nil
        self.linkedin = nil
        self.website2 = nil
        self.website3 = nil
        self.github = nil
        self.tiktok = nil
        self.applemusic = nil
        self.spotify = nil
        self.youtube = nil
        self.twitter = nil
        self.venmo = nil
        self.website4 = nil
        self.soundcloud = nil
        self.whatsapp = nil
        self.grad1 = nil
        self.grad2 = nil
        self.isPublic = false
        self.isVerified = false
        
        
    }
    
    //MARK: - Changing Identity
    
    /// use the enum detail type to update a field in an identity
    func updateField(field: detailType, new: String?){
        switch field {
            case detailType.username:
                self.username = new ?? ""
            case detailType.firstName:
                self.firstName = new ?? ""
            case detailType.lastName:
                self.lastName = new ?? ""
            case detailType.identity:
                self.identity = new ?? ""
            case detailType.bio:
                self.bio = new
            case detailType.work:
                self.work = new
            case detailType.phone:
                self.phone = new
            case detailType.email:
                self.email = new
            case detailType.facebook:
                self.facebook = new
            case detailType.instagram:
                self.instagram = new
            case detailType.snapchat:
                self.snapchat = new
            case detailType.website:
                self.website = new
            case detailType.linkedin:
                self.linkedin = new
            case detailType.website2:
                self.website2 = new
            case detailType.website3:
                self.website3 = new
            case detailType.github:
                self.github = new
            case detailType.tiktok:
                self.tiktok = new
            case detailType.applemusic:
                self.applemusic = new
            case detailType.spotify:
                self.spotify = new
            case detailType.youtube:
                self.youtube = new
            case detailType.twitter:
                self.twitter = new
            case detailType.venmo:
                self.venmo = new
            case detailType.website4:
                self.website4 = new
            case detailType.soundcloud:
                self.soundcloud = new
            case detailType.whatsapp:
                self.whatsapp = new
            case detailType.grad1:
                self.grad1 = new
            case detailType.grad2:
                self.grad2 = new
            case detailType.profileImage:
                self.profileImage = new
        }
    }
    
    func updateWebsites(_ sites:[String]){
        self.websites = sites
    }
    
    /// Changes the identity to public or private, this does not alter
    /// the database though, that has to be done seperately
    func setPubPriv(isPub: Bool){
        isPublic = isPub
    }
    
    
    //MARK: - Getting info
    /// Returns if the identity is public or private
    func checkIfPublic() -> Bool{
        return isPublic!
    }
    
    
    
    ///verified code, does not do much yet, but will be helpful in the future
    func setVerified(isVer: Bool){
        isVerified = isVer
    }
    
    
    
    func checkIfVerified() -> Bool{
        return isVerified!
    }
    
    
    

    //MARK: - Debugging functions
    
    /// Prints all of the properties to the console,
    /// this is nice to have when debugging
    func printAllValues(){
        print(username, "'s Card")
        if(isPublic ?? false){
            print("THIS IS A PUBLIC CARD")
        } else {
            print("THIS IS A PRIVATE CARD")
        }
        print("firstName: ", firstName )
        print("lastName: ", lastName )

        print("email: ", email ?? "NONE")
        print("identity: ", identity)
        print("bio: ", bio ?? "NONE")
        print("work: ", work ?? "NONE")
        print("phone: ", phone ?? "NONE")
        print("facebook: ", facebook ?? "NONE")
        print("instagram: ", instagram ?? "NONE")
        print("snapchat: ", snapchat ?? "NONE")
        //TODO: - Make it so this prints out all of the possible values that can be in a card
        
    }
    
    
}


