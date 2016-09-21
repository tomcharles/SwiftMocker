# SwiftMocker

A basic mocking library for swift.

## Usage

### An example class with a dependency:

	class DoesSomethingClass {
	    let someDependency: SomeDependencyClass
	    
	    init(someDependency: SomeDependencyClass) {
	        self.someDependency = someDependency
	    }
	    
	    func doSomething(input: String) -> String {
	        let someResponse = someDependency.doSomethingElse(input)
	        return "Modified the response \(someResponse)!"
	    }
	}

### An example dependency:

	class SomeDependencyClass {
	    
	    func doSomethingElse(input: String) -> String {
	        return "I've done something to \(input)"
	    }

	}

### Mocking and asserting:

	class BasicUsageTests: XCTestCase {
	    
	    var mockDependency: MockDependencyClass!
	    var subject: DoesSomethingClass!
	    
	    override func setUp() {
	        mockDependency = MockDependencyClass()
	        subject = DoesSomethingClass(someDependency: mockDependency)
	    }
	    
	    func test_setting_return_value_for_mock() {
	    	let expectedModifiedResult = "foobar"
	    	// Set a return value
	        mockDependency.mocker.setReturnValue(forMethod: "doSomethingElse", withReturnValue: expectedModifiedResult)
	        
	        let result = subject.doSomething("Hello!")
	        
	        XCTAssertEqual("Modified the response \(expectedModifiedResult)!", result)
	    }
	    
	    func test_get_invocation_count_for_mock() {
	        let _ = subject.doSomething("Hello!")
	        
	        // If you don't want to set a return value, you can simply check the invocation count
	        XCTAssertEqual(1, mockDependency.mocker.getInvocationCount(forMethod: "doSomethingElse"))
	    }

	    func test_verify_correct_parameters_were_passed() {
	        let _ = subject.doSomething("Hello!")
	        
	        let parameter = mockDependency.mocker.getParameter(forMethod: "doSomethingElse", atPosition: 0, forType: String.self)
	        
	        XCTAssertEqual("Hello!", parameter)
	    }
	    
	    // Extend the class you wish to depend on
	    class MockDependencyClass: SomeDependencyClass {
	    	// Give it a SwiftMocker
	        let mocker = SwiftMocker()
	        
	        // Override the functions you want to mock
	        override func doSomethingElse(input: String) -> String {
	            mocker.recordInvocation(forMethod: "doSomethingElse")
	            
	            guard let result = mocker.getReturnValue(forMethod: "doSomethingElse", forType: String.self) else {
	                return ""
	            }
	            return result
	        }
	    }
	    
	}