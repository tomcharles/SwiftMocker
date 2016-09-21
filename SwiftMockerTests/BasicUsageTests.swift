//
//  BasicUsageTests.swift
//  SwiftMocker
//
//  Created by Tom Charles on 9/21/16.
//  Copyright © 2016 Tom Charles. All rights reserved.
//

import XCTest
@testable import SwiftMocker

class BasicUsageTests: XCTestCase {
    
    var mockDependency: MockDependencyClass!
    var subject: DoesSomethingClass!
    
    override func setUp() {
        mockDependency = MockDependencyClass()
        subject = DoesSomethingClass(someDependency: mockDependency)
    }
    
    func testModifiesTheResponse() {
        mockDependency.mocker.setReturnValue(forMethod: "doSomethingElse", withReturnValue: "foobar")
        
        let result = subject.doSomething("Hello!")
        
        XCTAssertEqual("Modified the response foobar!", result)
    }
    
    func testGetInvocationCountForWorks() {
        let _ = subject.doSomething("Hello!")
        
        XCTAssertEqual(1, mockDependency.mocker.getInvocationCount(forMethod: "doSomethingElse"))
    }
    
    func testVerifyCorrectParametersWerePassed() {
        let _ = subject.doSomething("Hello!")
        
        let parameter = mockDependency.mocker.getParameter(forMethod: "doSomethingElse", atPosition: 0, forType: String.self)
        let secondTryParameter = mockDependency.mocker.getParameter(forMethod: "doSomethingElse", atPosition: 0, forType: String.self, onNthInvocation: 1)
        
        XCTAssertEqual("Hello!", parameter)
        XCTAssertEqual("crap!", secondTryParameter)
    }
    
    func testVerifyCorrectParametersWerePassedOnSecondInvocation() {
        let _ = subject.doSomething("Hello!")
        
    }
    
    class MockDependencyClass: SomeDependencyClass {
        let mocker = SwiftMocker()
        
        override func doSomethingElse(input: String) -> String {
            mocker.recordInvocation(forMethod: "doSomethingElse", withParams: [input])
            
            guard let result = mocker.getReturnValue(forMethod: "doSomethingElse", forType: String.self) else {
                return ""
            }
            return result
        }
    }
    
}

class DoesSomethingClass {
    
    let someDependency: SomeDependencyClass
    
    init(someDependency: SomeDependencyClass) {
        self.someDependency = someDependency
    }
    
    func doSomething(input: String) -> String {
        let someResponse = someDependency.doSomethingElse(input)
        let _ = someDependency.doSomethingElse("crap!")
        return "Modified the response \(someResponse)!"
    }
}

class SomeDependencyClass {
    
    func doSomethingElse(input: String) -> String {
        return "I've done something to \(input)"
    }
}
