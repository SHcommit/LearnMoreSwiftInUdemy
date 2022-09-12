# CalculatorApp Unit Test

## 새로 알게 된 개념

- 기능을 구현하고 Test통해 확인하는게 Unit Test이다. 각 기능마다 Unit Test를 추가하면 앱의 Complexity와 size는 당연히 증가한다. 이에 대한 방안으로 자동화 "TDD(TestDrivenDevelopment)"이다.

- Unit Test는 

빨라야 한다.

자동화해야 한다.

독립적이어야 한다.

반복 가능해야 한다.

XCTestCase를 상속받아 구현하는데 이 프레임워크에는 XCTestCase로부터 정의된 다양한 메소드를 사용할 수 있다.

testLogic의 작성은 func 이후 함수 이름이 test로 시작되어야 test기능을 사용할 수 있다.

---

### 1. 기능에 대한 <a href="https://github.com/SHcommit/LearnMoreSwiftInUdemy/blob/a6d4ab614b829cc388a6d65baaf355f4b7254e12/Architectural%20Pattern/MVVM_Pattern/UnitTest/CalculatorApp/CalculatorAppTests/CalculatorAppTests.swift">test함수 구현</a>

초기 구현했던 test 함수에 대한 개선점이 있다. Calculator 인스턴스를 두번이나 재 정의한 것. 테스트 코드를 작성했다면 테스트 코드 또한 **리펙토링**이 필요하다. test 함수가 실행되기 전에 실행되는 함수는 XCTestCase 안에 정의된 **setUp()** 함수를 이용하면 된다.

### 2. Use <a href="https://github.com/SHcommit/LearnMoreSwiftInUdemy/commit/d64db99724597e529b9f3f87289b764b3b905fad">setUp( )</a>

setUp()함수는 각각의 테스트 testSubstractTwoNumbers() , testAddTwoNumbers()가 실행되기 전에 실행되는 함수이다. 즉 두번 선언되는 Calculator 인스턴스는 setUp()에서 초기화 할 경우에 두개의 단위 테스트 가 실행되기 이전에 초기화 될 것이다.

### 3. Use <a href="https://github.com/SHcommit/LearnMoreSwiftInUdemy/commit/9da9fb4697a213a2c5ca9723674510a7676f1db4">tearDown()</a>

teatDown() 또한 XCTestCase에서 제공되는 함수들 중 하나다. 각각의 test들이 실행된 이후에 실행되는 함수이다. 예를들어 db에서 무언가를 test code로 작성하거나 파일을 작성한 후에 테스트가 실행 될 경우 db에 값이 변경되어 적용 될 수 있음으로 이 함수를 통해 로직들을 초기화 할 수 있다.

UserDefaults.standard 영구저장소에 특정 값을 넣고 test할 경우에도 실제 코드에서 value가 적용되기에 tearDown()을 통해 삭제 해야 한다.

---

따라서 test는 한가지만 테스트하고 tearDown()으로 제거하는 원칙을 따른다!! 그리고 신뢰할 수 없을 때 하는 게 test이다!!
