//
//  Swiftito.swift
//  SwiftMocker
//
//  Created by Tom Charles on 9/23/16.
//  Copyright © 2016 Tom Charles. All rights reserved.
//


public class Mock<T> {
    
    
    public let object: T
    
    private let mocker = SwiftMocker()

    private var currentSetup: Any?
    
    init(something: T) {
        self.object = something
    }
    
    public func doReturn(retVal: Any) -> Mock<T> {
        currentSetup = retVal
        return self
    }
    
    public func when(callingFunction: String) {
        mocker.setReturnValue(forMethod: callingFunction, withReturnValue: self.currentSetup)
        self.currentSetup = nil
    }
    
}