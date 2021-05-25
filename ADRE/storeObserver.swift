//
//  storeObserver.swift
//  ADRE
//
//  Created by youngwoo Choi on 2020/05/18.
//  Copyright © 2020 youngwoo Choi. All rights reserved.
//

import UIKit
import StoreKit

class storeObserver: NSObject, SKPaymentTransactionObserver {
    
    // 멤버 변수들.
    var purchased = [SKPaymentTransaction]();
    
    override init() {
        super.init()
        
        // 생성자를 위한 초기화 메서드.
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchasing:
                print("결제가 진행되고 있습니다.");
                break;
                
            // 결제 창을 띄우는 데 실패했습니다.
            case .deferred:
                print("아이폰의 잠기는 등의 이류로 결제 창을 띄우지 못했습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            case .purchased:
                print("결제를 성공하였습니다.")
//                handlepurchased(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            case .failed:
                print("결제를 실패하였습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            case .restored:
                print("결제를 검증을 하였습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            default:
                print("알수 없는 오류를 만났습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            }
        }
    }
    
    func handlepurchased( _ transaction : SKPaymentTransaction) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        print("영수증 주소 : \(String(describing: Bundle.main.appStoreReceiptURL))")
        
//        let receiptData = NSDate( contentsOf: Bundle.main.appStoreReceiptURL! )
//        print(receiptData)
//
//        let receiptString = receiptData!.base64EncodedString(option: NSDate.Base64EncodingOptions())
//
//        print("구매 성공 트랜젝션 아이디 : \(transaction.transactionIdentifier!)")
//        print("상품 아이디 : \(transaction.payment.productIdentifier)")
//        print("구매 영수증 : \(receiptString)")
        
        // 결제 마무리 하도록 합니다.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            print(prodID)
            switch prodID {
            case "com.youngwoo.adre.tourmusic":
                print("복원 성공")
            default:
                print("상품 못찾음")
            }
        }
    }
    

}
