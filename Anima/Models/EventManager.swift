import Foundation
import EventKit
import SwiftUI

@Observable
class EventManager {
    private let eventStore = EKEventStore()
    var events: [EKEvent] = []
    var isAuthorized = false
    
    // Status properties for Third-Party integrations
    var isGoogleSyncEnabled = false
    var isOutlookSyncEnabled = false
    
    init() {
        checkAuthorization()
    }
    
    func checkAuthorization() {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            isAuthorized = true
            fetchEvents()
        case .notDetermined:
            requestAccess()
        default:
            isAuthorized = false
        }
    }
    
    func requestAccess() {
        if #available(iOS 17.0, macOS 14.0, *) {
            eventStore.requestFullAccessToEvents { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.fetchEvents()
                    }
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.fetchEvents()
                    }
                }
            }
        }
    }
    
    func fetchEvents() {
        guard isAuthorized else { return }
        
        let calendars = eventStore.calendars(for: .event)
        let oneMonthAgo = Date().addingTimeInterval(-30*24*3600)
        let oneMonthFromNow = Date().addingTimeInterval(30*24*3600)
        
        // This predicate automatically fetches events from all accounts logged into the device Settings,
        // which natively includes Google Calendar and Microsoft Exchange/Outlook if the user added them.
        let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthFromNow, calendars: calendars)
        let rawEvents = eventStore.events(matching: predicate)
        
        // Sort by start date
        self.events = rawEvents.sorted { $0.startDate < $1.startDate }
    }
    
    // MARK: - Direct API Sync Methods (Stubs for deep integration)
    
    /// Stub: If direct OAuth google sync is needed beyond EventKit
    func connectGoogleCalendar() async throws {
        // Authenticate via GoogleSignIn
        // Fetch via Google Calendar REST API
        // Merge with local `events` array
        isGoogleSyncEnabled = true
    }
    
    /// Stub: If direct MSAL outlook sync is needed beyond EventKit
    func connectOutlookCalendar() async throws {
        // Authenticate via Microsoft Authentication Library (MSAL)
        // Fetch via Microsoft Graph API
        // Merge with local `events` array
        isOutlookSyncEnabled = true
    }
}
