//
//  ChatViewController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 25/04/2021.
//

import UIKit
import MessageKit
import FirebaseFirestore
import Firebase
import InputBarAccessoryView
import SDWebImage

class ChatController: MessagesViewController {
    
    // MARK: - Properties
    
    var currentUser: User?
    var secondUser: User?
    
    var messages: [Message] = []
    private var docReference: DocumentReference?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = secondUser?.fullname ?? "Chat"
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .blue
        messageInputBar.sendButton.setTitleColor(.blue, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        loadChat(userTwoUID: secondUser!.uid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    // MARK: - Helpers

    private func save(message: Message, docRef: DocumentReference) {
        MessageService.uploadMessage(docRef: docRef, message: message) { error in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    
    private func addNewMessage(message: Message) {
        self.messages.append(message)
        self.messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    
    private func createChat(userTwoUID: String) {
        MessageService.createNewChat(userTwoID: userTwoUID) { docReference in
            self.docReference = docReference
            self.loadChat(userTwoUID: userTwoUID)
        }
    }
    
    private func loadChat(userTwoUID: String) {
//
//        MessageService.fetchConversation(userTwoUID: userTwoUID) { messages, docref  in
//            if docref == nil && messages == nil {
//                self.createChat(userTwoUID: userTwoUID)
//            } else {
//                self.docReference = docref
//                self.messages.removeAll()
//                self.messages.append(contentsOf: messages!)
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToLastItem(animated: true)
//            }
//        }
//
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = K.FStore.COLLECTION_CHATS.whereField("users", arrayContains: uid)

        db.getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error \(error)")
                return
            } else {
                guard let queryCount = snapshot?.documents.count else { return }
                
                if queryCount >= 1 {
                    
                    snapshot?.documents.forEach({ document in
                        
                        let chat = Chat(id: document.documentID, dictionary: document.data())
                        
                        if(chat?.users.contains(userTwoUID))! {
                            
                            self.docReference = document.reference
                            
                            document.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, rror in
                                if let error = error {
                                    print("DEBUG: Error \(error)")
                                } else {
                                    var tmp: [Message] = []
                                    snapshot!.documents.forEach({ message in
                                        tmp.append(Message(dictionary: message.data())!)
                                    })
                                    self.messages.removeAll()
                                    self.messages.append(contentsOf: tmp)
                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToLastItem(animated: true)
                                }
                            })
                            return
                        }
                    })
                    self.createChat(userTwoUID: userTwoUID)
                } else if queryCount == 0 {
                    self.createChat(userTwoUID: userTwoUID)
                } else {
                    print("error")
                }
            }
        }
        
    }
    
    private func setupNavigationController() {
        let backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))
        backBarButtonItem.tintColor = K.Color.navyApp
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    // MARK: - Actions
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - MessagesDataSource

extension ChatController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return MessageService.getCurrentSender(user: self.currentUser!)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
}

// MARK: - MessagesDisplayDelegate

extension ChatController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .lightGray
    }
    
    //his function shows the avatar
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //If it's current user show current user photo.
        if message.sender.senderId == currentUser!.uid {
            SDWebImageManager.shared.loadImage(with: URL(string: currentUser!.profileImageUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        } else {
            SDWebImageManager.shared.loadImage(with: URL(string: secondUser!.profileImageUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }
    }
    
    //Styling the bubble to have a tail
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser!.uid, senderName: currentUser!.fullname)
        
        MessageService.uploadMessage(docRef: self.docReference!, message: message) { error in
            if let error = error {
                print("DEBUG: Error \(error)")
                return
            } else {
                self.addNewMessage(message: message)
                inputBar.inputTextView.text = ""
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
}
