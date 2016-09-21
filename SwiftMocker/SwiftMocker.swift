//
//  SwiftMocker.swift
//  SwiftMocker
//
//  Created by Tom Charles on 9/21/16.
//  Copyright © 2016 Tom Charles. All rights reserved.
//

public class SwiftMocker {
    
    private var invocations: [String: [[Any]]]
    private var expectations: [String: Any]
    
    public init() {
        invocations = [:]
        expectations = [:]
    }

    public func recordInvocation(forMethod methodName: String) {
        self.recordInvocation(forMethod: methodName, withParams: [])
    }
    
    public func recordInvocation(forMethod methodName: String, withParams paramList: [Any]) {
        guard var invocation = invocations[methodName] else {
            invocations[methodName] = [paramList]
            return
        }
        invocation.append(paramList)
    }
    
    public func getInvocationCount(forMethod methodName: String) -> Int {
        guard let invocation = invocations[methodName] else {
            return 0
        }
        return invocation.count
    }
    
    public func setReturnValue(forMethod methodName: String, withReturnValue returnValue: Any) {
        expectations[methodName] = returnValue
    }
    
    public func getReturnValue<T>(forMethod methodName: String, forType type: T.Type) -> T? {
        guard let result = expectations[methodName] as? T else {
            return nil
        }
        return result
    }
    
    public func reset() {
        invocations = [:]
        expectations = [:]
    }
    
}