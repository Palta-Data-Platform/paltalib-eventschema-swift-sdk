//
//  StorageSpaceProvider.swift
//  
//
//  Created by Vyacheslav Beltyukov on 02/05/2023.
//

import Foundation

protocol StorageSpaceProvider {
    func getStorageUsagePercentage() throws -> Double
}

final class StorageSpaceProviderImpl: StorageSpaceProvider {
    private let folderURL: URL
    private let fileManager: FileManager
    
    init(folderURL: URL, fileManager: FileManager) {
        self.folderURL = folderURL
        self.fileManager = fileManager
    }
    
    func getStorageUsagePercentage() throws -> Double {
        try Double(getSpaceUsed()) / Double(getSpaceAvailable() + getSpaceUsed())
    }
    
    private func getSpaceAvailable() throws -> Int {
        let attributes = try fileManager.attributesOfFileSystem(
            forPath: fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).path
        )
        
        return attributes[.systemFreeSize] as? Int ?? 1
    }
    
    private func getSpaceUsed() throws -> Int {
        try fileManager.allocatedSizeOfDirectory(at: folderURL)
    }
}

private extension FileManager {

    /// Calculate the allocated size of a directory and all its contents on the volume.
    ///
    /// As there's no simple way to get this information from the file system the method
    /// has to crawl the entire hierarchy, accumulating the overall sum on the way.
    /// The resulting value is roughly equivalent with the amount of bytes
    /// that would become available on the volume if the directory would be deleted.
    ///
    /// - note: There are a couple of oddities that are not taken into account (like symbolic links, meta data of
    /// directories, hard links, ...).
    func allocatedSizeOfDirectory(at directoryURL: URL) throws -> Int {

        // The error handler simply stores the error and stops traversal
        var enumeratorError: Error? = nil
        func errorHandler(_: URL, error: Error) -> Bool {
            enumeratorError = error
            return false
        }

        // We have to enumerate all directory contents, including subdirectories.
        let enumerator = self.enumerator(at: directoryURL,
                                         includingPropertiesForKeys: Array(allocatedSizeResourceKeys),
                                         options: [],
                                         errorHandler: errorHandler)!

        // We'll sum up content size here:
        var accumulatedSize: UInt64 = 0

        // Perform the traversal.
        for item in enumerator {

            // Bail out on errors from the errorHandler.
            if enumeratorError != nil { break }

            // Add up individual file sizes.
            let contentItemURL = item as! URL
            accumulatedSize += try contentItemURL.regularFileAllocatedSize()
        }

        // Rethrow errors from errorHandler.
        if let error = enumeratorError { throw error }

        return Int(accumulatedSize)
    }
}

private let allocatedSizeResourceKeys: Set<URLResourceKey> = [
    .isRegularFileKey,
    .fileAllocatedSizeKey,
    .totalFileAllocatedSizeKey,
]

private extension URL {
    func regularFileAllocatedSize() throws -> UInt64 {
        let resourceValues = try self.resourceValues(forKeys: allocatedSizeResourceKeys)

        // We only look at regular files.
        guard resourceValues.isRegularFile ?? false else {
            return 0
        }

        // To get the file's size we first try the most comprehensive value in terms of what
        // the file may use on disk. This includes metadata, compression (on file system
        // level) and block size.
        // In case totalFileAllocatedSize is unavailable we use the fallback value (excluding
        // meta data and compression) This value should always be available.
        return UInt64(resourceValues.totalFileAllocatedSize ?? resourceValues.fileAllocatedSize ?? 0)
    }
}
