//
//  FirebaseDataManager.swift
//  Beaver
//
//  Created by Jia Jang on 8/11/24.
//

import Foundation
import Firebase
import FirebaseDatabase

final class FirebaseDataManager {
    static let shared = FirebaseDataManager()
    
    private let databaseURL = "https://beaver-39808-default-rtdb.firebaseio.com"
    
    private var ref: DatabaseReference {
        Database.database(url: databaseURL).reference()
    }
    
    private init() {}
    
    func addData<T: Encodable>(
        _ data: T,
        type: DataType,
        id: String
    ) throws {
        let data = try JSONEncoder().encode(data)
        let jsonString = try JSONSerialization.jsonObject(with: data)
        
        ref.child(type.key)
            .child(id)
            .setValue(jsonString)
    }
    
    func fetchData<T: Decodable>(
        type: DataType,
        dataID: String? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var databaseRef = ref.child(type.key)
        if let dataID {
            databaseRef = databaseRef.child(dataID)
        }
        
        databaseRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            self?.handleSnapshot(snapshot: snapshot, dataID: dataID, completion: completion)
        }
    }
    
    func observeData<T: Decodable>(
        eventType: DataEventType,
        dataType: DataType,
        dataID: String? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var databaseRef = ref.child(dataType.key)
        if let dataID {
            databaseRef = databaseRef.child(dataID)
        }
        
        databaseRef.observe(eventType) { [weak self] snapshot in
            self?.handleSnapshot(snapshot: snapshot, dataID: dataID, completion: completion)
        }
    }
    
    func updateData<T: Encodable>(
        _ data: T,
        type: DataType,
        id: String
    ) throws {
        let data = try JSONEncoder().encode(data)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        
        if let json = jsonObject as? [String: Any] {
            ref.child(type.key)
                .child(id)
                .updateChildValues(json)
        } else {
            throw FirebaseError.jsonObjectConvertFailed
        }
    }
    
    private func handleSnapshot<T: Decodable>(
        snapshot: DataSnapshot,
        dataID: String?,
        completion: (Result<T, Error>) -> Void
    ) {
        if snapshot.exists() {
            do {
                let decodedData: T = try self.decode(id: dataID, value: snapshot.value)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(FirebaseError.dataNotFound))
        }
    }
    
    private func decode<T: Decodable>(id: String?, value: Any?) throws -> T {
        guard let object = value as? [String: Any] else {
            throw FirebaseError.dataNotFound
        }
        
        let data = try JSONSerialization.data(withJSONObject: object)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension FirebaseDataManager {
    enum DataType {
        case home
        case report
        
        var key: String {
            switch self {
            case .home:
                "home"
            case .report:
                "report"
            }
        }
    }
    
    enum FirebaseError: Error {
        case dataNotFound
        case jsonObjectConvertFailed
    }
    
}
