//
//  PersistenceController.swift
//  MESS
//
//  Created by khush on 02/06/2026.
//

//import Foundation
import CoreData

final class PersistantController {

    static let shared = PersistantController()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "MESS")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData Error: \(error)")
            }
        }
    }

    func save() {
        guard viewContext.hasChanges else { return }

        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }

    // MARK: - GET ALL

    func getAllChatUsers() -> [ChatUser] {
        let request: NSFetchRequest<ChatUser> = ChatUser.fetchRequest()

        do {
            return try viewContext.fetch(request)
        } catch {
            print(error)
            return []
        }
    }

    // MARK: - GET SINGLE

    func getUser(username: String) -> ChatUser? {

        let request: NSFetchRequest<ChatUser> = ChatUser.fetchRequest()

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "username == %@",
            username
        )

        do {
            return try viewContext.fetch(request).first
        } catch {
            print(error)
            return nil
        }
    }

    // MARK: - DELETE

    func deleteUser(username: String) {

        guard let user = getUser(username: username) else {
            return
        }

        viewContext.delete(user)
        save()
    }

    func saveUser(
        username: String,
        displayName: String?,
        email: String?,
        profile: String?,
        objectId: String,
        unreadCount: Int32?
    ) {
        let user = getUser(username: username)
            ?? ChatUser(context: viewContext)

        user.username = username
        user.displayName = displayName
        user.email = email
        user.profile = profile
        user.objectId = objectId
        user.unreadCount = unreadCount ?? 0
        save()
    }
    
    func updateUnreadCount(
        username: String,
        unreadCount: Int32
    ) {
        let request: NSFetchRequest<ChatUser> = ChatUser.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "username == %@",
            username
        )
        
        do {
            guard let user = try viewContext.fetch(request).first else {
                return
            }
            user.unreadCount = Int32(unreadCount)
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    func updateUnreadCount(
        username: String,
        updateCount: Int32
    ) {
        let request: NSFetchRequest<ChatUser> = ChatUser.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "username == %@",
            username
        )
        
        do {
            guard let user = try viewContext.fetch(request).first else {
                return
            }
            user.unreadCount = user.unreadCount + updateCount
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func getMessages(
        conversationId: String
    ) -> [ChatMessage] {

        let request: NSFetchRequest<ChatMessage> =
            ChatMessage.fetchRequest()
        request.predicate = NSPredicate(
            format: "conversationId == %@",
            conversationId
        )
        request.sortDescriptors = [
            NSSortDescriptor(
                key: "timeStamp",
                ascending: true
            )
        ]
        do {
            return try viewContext.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    func saveMessage(
        conversationId: String,
        senderId: String,
        message: String,
        timeStamp: Date
    ) {
        let newMessage =
            ChatMessage(context: viewContext)

        newMessage.conversationId = conversationId
        newMessage.senderId = senderId
        newMessage.message = message
        newMessage.timeStamp = timeStamp

        save()
    }
    
    func deleteConversation(
        conversationId: String
    ) {
        let request: NSFetchRequest<ChatMessage> =
            ChatMessage.fetchRequest()
        request.predicate = NSPredicate(
            format: "conversationId == %@",
            conversationId
        )
        do {
            let messages =
                try viewContext.fetch(request)
            messages.forEach {
                viewContext.delete($0)
            }
            save()
        } catch {
            print(error)
        }
    }
}
