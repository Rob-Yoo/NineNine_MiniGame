//
//  GameReadyData.swift
//  NineNine
//
//  Created by Jinyoung Yoo on 2023/06/27.
//

import UIKit
import FirebaseFirestore

struct GameData {
    private let startingResource: [(String, String, UIImage)] = [
        ("탭탭!", "화면에 있는 치즈 버튼을\n10초동안\n마구마구 누르세요!.", #imageLiteral(resourceName: "TapTapGame_start_cat")),
        ("쉐킷쉐킷!", "휴대폰을 마음껏 흔들어주세요!\n너무 열심히 흔든 나머지\n휴대폰이 날아가지 않도록 주의하세요.", #imageLiteral(resourceName: "ShakeItGame_start_cat")),
        ("부비부비", "화면의 생선을 누른 상태로\n좌우로 마구마구 비벼주세요!\n고양이를 생선으로 재미있게 놀아주세요!", #imageLiteral(resourceName: "BBGame_start_cat")),
        ("더하기를 하자!", "최대한 빠르게\n덧셈에 대한 정답을\n입력해주세요!", #imageLiteral(resourceName: "PlusGame_start_cat")),
        ("곱하기를 하자!", "최대한 빠르게\n곱셈에 대한 정답을\n입력해주세요!", #imageLiteral(resourceName: "MultiplyeGame_start_cat"))
    ]
    private let gameStoryBoardAndViewControllerList: [(String, String)] = [
        ("TabTabGame", "TabTabGameViewController"),
        ("ShakeItGame", "ShakeItGameViewController"),
        ("BBGame", "BBGameViewController"),
        ("PlusGame", "PlusGameViewController"),
        ("MultiplyGame", "MultiplyGameViewController")
    ]
    private let gameTitles: [String] = ["TabTabGame", "ShakeItGame", "BBGame", "PlusGame", "MultiplyGame"]
    private let gameStartBtnImages: [UIImage] = [#imageLiteral(resourceName: "GameStartBtn2"), #imageLiteral(resourceName: "GameStartBtn")]
    
    func gameStartingResource() -> [(String, String, UIImage)] {
        return startingResource
    }
    
    func gameTitleList() -> [String] {
        return gameTitles
    }
    
    func gameStartBtnImageArray() -> [UIImage] {
        return gameStartBtnImages
    }
    
    func gameStoryBoardAndViewControllers() -> [(String, String)] {
        return gameStoryBoardAndViewControllerList
    }
}

struct FireStore {
    private let db = Firestore.firestore()
    private let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    private func makeData(score: Int) -> [String: Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm:ss"
        let current_date_string = formatter.string(from: Date())
        
        return [
            "gameTime": current_date_string,
            "gameScore": score
        ]
    }
    
    func recordScore(score: Int, gameName: String) {
        guard let collection_id = uuid else { return }
        let docRef = db.collection("\(collection_id)").document("\(gameName)")
        let data: [String: Any] = makeData(score: score)
        
        docRef.getDocument { (document, err) in
            if let document = document, document.exists { // document가 존재하면
                docRef.updateData(["gameRecord": FieldValue.arrayUnion([data])]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    }
                }
            } else { // document가 존재하지 않을 때, 즉 처음 기록하는 경우
                docRef.setData(["gameRecord": [data]]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                }
            }
        }
    }
    
}