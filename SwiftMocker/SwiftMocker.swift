//
//  SwiftMocker.swift
//  SwiftMocker
//
//  Created by Tom Charles on 9/21/16.
//  Copyright © 2016 Tom Charles. All rights reserved.
//

open class SwiftMocker {
    
    fileprivate var invocations: [String: [[Any]]]
    fileprivate var expectations: [String: Any]
    
    public init() {
        invocations = [:]
        expectations = [:]
    }

    open func recordInvocation(forMethod methodName: String) {
        self.recordInvocation(forMethod: methodName, withParams: [])
    }
    
    open func recordInvocation(forMethod methodName: String, withParams paramList: [Any]) {
        guard let invocationsForMethod = invocations[methodName] else {
            invocations[methodName] = [paramList]
            return
        }
        invocations[methodName] = invocationsForMethod + [paramList]
    }
    
    open func getParameter<T>(forMethod methodName: String, atPosition position: Int, forType type: T.Type, onNthInvocation n: Int) -> T? {
        guard let invocationsForMethod = invocations[methodName] , n < invocationsForMethod.count else { return nil }
        
        let parameters = invocationsForMethod[n]
        
        guard position < parameters.count,
            let parameter = parameters[position] as? T else {
                return nil
        }
        
        return parameter
    }
    
    open func getParameter<T>(forMethod methodName: String, atPosition position: Int, forType type: T.Type) -> T? {
        return getParameter(forMethod: methodName, atPosition: position, forType: type, onNthInvocation: 0)
    }
    
    open func getInvocationCount(forMethod methodName: String) -> Int {
        guard let invocationsForMethod = invocations[methodName] else {
            return 0
        }
        return invocationsForMethod.count
    }
    
    open func setReturnValue(forMethod methodName: String, withReturnValue returnValue: Any) {
        expectations[methodName] = returnValue
    }
    
    open func getReturnValue<T>(forMethod methodName: String, forType type: T.Type) -> T? {
        guard let result = expectations[methodName] as? T else {
            return nil
        }
        return result
    }
    
    open func reset() {
        invocations = [:]
        expectations = [:]
    }
    
}
