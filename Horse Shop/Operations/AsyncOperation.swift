//
//  AsyncOperation.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    private var isAsyncExecuting = false
    private var isAsyncFinished = false
    
    func finish() {
        willChangeValue(forKey: "isFinished")
        isAsyncFinished = true
        didChangeValue(forKey: "isFinished")
    }
}

//MARK: - Override properties

extension AsyncOperation {
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        return isAsyncExecuting
    }
    
    override var isFinished: Bool {
        return isAsyncFinished
    }
}

//MARK: - Override methods

extension AsyncOperation {
    override func start() {
        guard !isCancelled else {
            finish()
            
            return
        }
        
        willChangeValue(forKey: "isExecuting")
        isAsyncExecuting = true
        main()
        didChangeValue(forKey: "isExecuting")
    }
    
    override func main() {
        fatalError("Should be overriden")
    }
}
