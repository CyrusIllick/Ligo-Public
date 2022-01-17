//
//  Analytics.swift
//
//  Created by Cyrus Illick on 7/18/20
//  Editied by Jordan Shand on 8/2/20
//

import Foundation
import Mixpanel

// MARK: - Properties
class Analytics {
    /// Mixpanel project API token
    private static let mixpanelToken = "a59eed789500d1dae0c3e9d1964e4c6c"
    /// Main Mixpanel instance
    private static let mixpanel = Mixpanel.mainInstance()
}

// MARK: - Structs/Enums
extension Analytics {
    /// Events being tracked
    enum Event: String {
        
        /// Home
        case searchButtonPressed = "Search Button Pressed"  /// check
        case cardTapped = "Card Tapped" /// check
        case cardShared = "Card Shared" /// check
        case copyLinkPressed = "Copy Link Pressed" ///check
        case newContact = "New Contact" /// moved test for beta
        case openSidebar = "Opened Sidebar" ///check
        
        /// Search
        case exhangeCard = "Exchanged Card" /// check
        
        /// Sidebar
        case viewedOnWeb = "Viewed On Web" ///check
        case viewQR = "View QR" ///check
        case signOut = "Sign Out"
        
        /// Edit card
        case openEditCard = "Open Edit Card" ///check
        case saveCard = "Saved Card"  /// check
        case updateProfilePicture = "Updated Profile Picture" /// moved test next beta
        case updateCardColors = "Updated Card Colors" /// check
        
        /// About me
        case updateUsername = "Updated Username" /// Can't update username
        case updateFirstName = "Updated First Name"  /// check
        case updateLastName = "Updated Last Name"  /// check
        case updateBio = "Updated Bio"  /// check
        case updateWork = "Updated Work" /// check
        
        /// Contact me
        case updatePhone = "Updated Phone"  /// check
        case updateWhatsapp = "Updated Whatsapp"  /// check
        case updateCardEmail = "Updated Card Email"  /// check
        case updateWebsite = "Updated Website"  /// check
        case updateWebsite2 = "Updated Website2" /// check
        case updateWebsite3 = "Updated Website3"  /// check
        case updateWebsite4 = "Updated Website4" /// check
        
        /// My Socials
        case updateFacebook = "Updated Facebook"  /// check
        case updateInstagram = "Updated Instagram"  /// check
        case updateSnapchat = "Updated Snapchat"  /// check
        case updateTwitter = "Updated Twitter" ///check
        case updateLinkedin = "Updated Linkedin" /// check
        case updateGithub = "Updated Github" /// check
        case updateVenmo = "Updated Venmo" ///check
        case updateSpotify = "Updated Spotify"  /// check
        case updateAppleMusic = "Updated Apple Music"  /// check
        case updateYoutube = "Updated Youtube"  /// check
        case updateSoundCloud = "Updated Sound Cloud"  /// check
        case updateTiktok = "Updated TikTok"  /// check
        
        /// Settings
        case openedSettings = "Opened Settings" /// added test next beta
        case deactivateAccount = "Deactivated Account"
        case updateLoginEmail = "Updated Email Credenitals"
        case saveSettingsChanges = "Save Settings Changes"
        case updatePassword = "Updated Password"
        case connectedToBusiness = "Connected to a Business"
        case updateToPublic = "Updated to Public" /// check
        case updateToPrivate = "Updated to Private" /// check
    }
    
    enum PropertyField: String {
        /// About Me
        case firstName = "First Name"
        case lastName = "Last Name"
        case email = "Email"
        case bio = "Bio"
        
        case cardColor1 = "Card Color 1"
        case cardColor2 = "Card Color 2"
        
        case privateOrPublic = "Private or Public"
        case socialOrBusiness = "Social or Business"
    }
}

// MARK: - Functions
extension Analytics {
    /// Initialize Mixpanel (Should be called in AppDelegate)
    static func initMixpanel() {
        Mixpanel.initialize(token: mixpanelToken)
    }

    /// Register user to Mixpanel
    /// - Parameters:
    ///   - userId: Id to register user with
    ///   - username: Username of user to register
    static func identifyUser(withId userId: String?, andUsername username: String?) {
        guard let userId = userId else { return }
        mixpanel.identify(distinctId: userId)

        guard let username = username else { return }
        mixpanel.people.set(properties: ["username": username])
    }

    
    /// Track given event
    /// - Parameter event: Event to track
    static func track(_ event: Event) {
        mixpanel.track(event: event.rawValue)
    }
    
    static func setProperty(_ propertyField: PropertyField, userProperty: String?) {
        guard let userProperty = userProperty else { return }
        mixpanel.people.set(properties: ["\(propertyField.rawValue)": userProperty])
    }

}
