import XCTest
@testable import RockPaperScissors

final class RockPaperScissorsTests: XCTestCase {
    func testFileInput() throws {
        XCTAssertEqual(score(fileFormat: .generateResult), 14264)
        XCTAssertEqual(score(fileFormat: .generateSign), 12382)
    }
    
    func testSampleData() throws {
        let data = """
A Y
B X
C Z
"""
        XCTAssertEqual(process(data: data, fileFormat: .generateResult), 15)
        XCTAssertEqual(process(data: data, fileFormat: .generateSign), 12)

    }
    
    func testGameLogic() throws {
        let gamelogic = GameLogic()
        
        Sign.allCases.forEach { me in
            Sign.allCases.forEach { opponent in
                switch (me, opponent) {
                case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
                    XCTAssertEqual(gamelogic.result(opponent: opponent, me: me), Result.draw)
                case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
                    XCTAssertEqual(gamelogic.result(opponent: opponent, me: me), Result.win)
                case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
                    XCTAssertEqual(gamelogic.result(opponent: opponent, me: me), Result.loss)
                }
            }
        }
    }
}
