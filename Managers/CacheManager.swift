//
//  CacheManager.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let cacheKey = "gatekeep_cached_data"
    
    func saveCache(_ data: CachedData) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    func loadCache() -> CachedData? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
              let decoded = try? JSONDecoder().decode(CachedData.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
    
    func shouldRefresh(cache: CachedData, currentGameId: String?, nextGameId: String?) -> Bool {
        if let current = currentGameId, current != cache.lastGameId {
            return true
        }
        if let next = nextGameId, next != cache.nextGameId {
            return true
        }
        let dayAgo = Calendar.current.date(byAdding: .hour, value: -24, to: Date()) ?? Date()
        if cache.lastUpdated < dayAgo {
            return true
        }
        return false
    }
}
