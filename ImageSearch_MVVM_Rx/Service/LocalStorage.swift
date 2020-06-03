//
//  LocalStorage.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/03.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift

struct LocalStorage {
    private func operate<T>(_ task: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch {
            print("Operation \(task) failed: \(error)")
            return nil
        }
    }
}

extension LocalStorage {
    @discardableResult
    func getImage(from key: String) -> LocalImage? {
        autoreleasepool {
            do {
                let realm = try Realm()
                let image = realm.object(ofType: LocalImage.self, forPrimaryKey: key)
                return image
            } catch {
                print("getting image failed with error: \(error)")
                return nil
            }
        }
    }
    
    func add(image: LocalImage) {
        autoreleasepool {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(image)
                }
            } catch {
                print("adding image failed with error: \(error)")
            }
        }
    }
    
    func delete(image: LocalImage) {
        autoreleasepool {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(image)
                }
            } catch {
                print("deleting image failed with error: \(error)")
            }
        }
    }
    
    func favorites() -> Observable<[LocalImage]> {
        autoreleasepool {
            do {
                let realm = try Realm()
                let favorites = realm.objects(LocalImage.self)
                    .sorted(byKeyPath: "date")
                return Observable.collection(from: favorites)
                    .map { $0.toArray()}
            } catch {
                print("getting favorite failed with error: \(error)")
                return .empty()
            }
        }
    }
}

