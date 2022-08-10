//
//  AppStorage.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/08/02.
//
import RxRelay

protocol AppStorageable {
    var mainUser: BehaviorRelay<MainUser>? { get }
    var bookMark: BehaviorRelay<[BookmarkUser]> { get }
    func addUser(_ user: BookmarkUser) throws
    func deleteUser(_ name: String) throws
    func updateUser(_ user: BookmarkUser, index: Int?) throws
    func changeMainUser(_ user: MainUser)
    func isBookmarkUser(_ name: String) -> Bool
}

final class AppStorage: AppStorageable {
    private let localStorage: LocalStorage
    
    var mainUser: BehaviorRelay<MainUser>?
    var bookMark: BehaviorRelay<[BookmarkUser]>
    
    init(_ localStorage: LocalStorage) {
        self.localStorage = localStorage
        self.bookMark = BehaviorRelay<[BookmarkUser]>(value: localStorage.bookmarkUsers())
        guard let mainUser = localStorage.mainUser() else {
            return
        }
        self.mainUser = BehaviorRelay<MainUser>(value: mainUser)
    }
    
    func addUser(_ user: BookmarkUser) throws {
        do {
            try localStorage.addUser(user, index: nil)
            self.bookMark.accept(localStorage.bookmarkUsers())
        } catch {
            throw error
        }
    }
    
    func deleteUser(_ name: String) throws {
        do {
            try localStorage.deleteUser(name)
            self.bookMark.accept(localStorage.bookmarkUsers())
        } catch {
            throw error
        }
    }
    
    func updateUser(_ user: BookmarkUser, index: Int?) throws {
        do {
            try localStorage.deleteUser(user.name)
            try localStorage.addUser(user, index: index)
        } catch {
            throw LocalStorageError.updateError
        }
    }
    
    func changeMainUser(_ user: MainUser) {
        
    }
    
    func isBookmarkUser(_ name: String) -> Bool {
        let user = bookMark.value.filter { name == $0.name }
        
        if user.isEmpty {
            return false
        }
        
        return true
    }
}