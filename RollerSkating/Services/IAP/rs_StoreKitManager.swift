//
//  rs_StoreKitManager.swift
//  RollerSkating
//
//  StoreKit 内购管理
//

import Foundation
import StoreKit

// MARK: - 内购商品模型

struct rs_IAPProduct {
    let id: String          // 商品ID（App Store Connect 配置的 Product ID）
    let coins: Int          // 购买获得的金币数量
    let price: String       // 显示价格
    
    // 预设8个内购套餐（后期修改商品ID、金币数量和价格）
    static let rs_allProducts: [rs_IAPProduct] = [
        rs_IAPProduct(id: "com.rollerskating.coins.100", coins: 100, price: "$0.99"),
        rs_IAPProduct(id: "com.rollerskating.coins.300", coins: 300, price: "$1.99"),
        rs_IAPProduct(id: "com.rollerskating.coins.500", coins: 500, price: "$2.99"),
        rs_IAPProduct(id: "com.rollerskating.coins.1000", coins: 1000, price: "$4.99"),
        rs_IAPProduct(id: "com.rollerskating.coins.2000", coins: 2000, price: "$9.99"),
        rs_IAPProduct(id: "com.rollerskating.coins.5000", coins: 5000, price: "$19.99"),
        rs_IAPProduct(id: "com.rollerskating.coins.10000", coins: 10000, price: "$39.99"),
        rs_IAPProduct(id: "com.rollerskating.coins.50000", coins: 50000, price: "$99.99")
    ]
}

// MARK: - StoreKit Manager

final class rs_StoreKitManager: NSObject {
    
    static let shared = rs_StoreKitManager()
    
    private var rs_productRequest: SKProductsRequest?
    private var rs_purchaseCompletion: ((Bool, String?) -> Void)?
    private var rs_pendingProduct: rs_IAPProduct?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: - Public API
    
    /// 检查是否可以进行内购
    func rs_canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    /// 购买商品（检测商品 + 发起购买合并）
    func rs_purchase(product: rs_IAPProduct, completion: @escaping (Bool, String?) -> Void) {
        guard rs_canMakePayments() else {
            completion(false, "In-app purchases are disabled on this device")
            return
        }
        
        rs_pendingProduct = product
        rs_purchaseCompletion = completion
        
        // 向 Apple 服务器请求商品信息
        let productIds = Set([product.id])
        rs_productRequest = SKProductsRequest(productIdentifiers: productIds)
        rs_productRequest?.delegate = self
        rs_productRequest?.start()
    }
    
    /// 恢复购买（消耗型商品不需要恢复，但保留接口）
    func rs_restorePurchases(completion: @escaping (Bool, String?) -> Void) {
        rs_purchaseCompletion = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension rs_StoreKitManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let skProduct = response.products.first {
                // 商品存在，发起购买
                let payment = SKPayment(product: skProduct)
                SKPaymentQueue.default().add(payment)
            } else {
                // 商品不存在
                self.rs_purchaseCompletion?(false, "Product not found")
                self.rs_purchaseCompletion = nil
                self.rs_pendingProduct = nil
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.rs_purchaseCompletion?(false, error.localizedDescription)
            self?.rs_purchaseCompletion = nil
            self?.rs_pendingProduct = nil
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension rs_StoreKitManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // 购买成功
                rs_handlePurchaseSuccess(transaction: transaction)
                
            case .failed:
                // 购买失败
                rs_handlePurchaseFailure(transaction: transaction)
                
            case .restored:
                // 恢复购买（消耗型商品不会触发）
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred, .purchasing:
                // 等待中
                break
                
            @unknown default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async { [weak self] in
            self?.rs_purchaseCompletion?(true, nil)
            self?.rs_purchaseCompletion = nil
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.rs_purchaseCompletion?(false, error.localizedDescription)
            self?.rs_purchaseCompletion = nil
        }
    }
    
    // MARK: - Private
    
    private func rs_handlePurchaseSuccess(transaction: SKPaymentTransaction) {
        // 完成交易
        SKPaymentQueue.default().finishTransaction(transaction)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let product = self.rs_pendingProduct else {
                self?.rs_purchaseCompletion?(false, "Unknown error")
                self?.rs_purchaseCompletion = nil
                return
            }
            
            // 添加金币
            rs_UserManager.shared.rs_addCoins(product.coins)
            
            self.rs_purchaseCompletion?(true, nil)
            self.rs_purchaseCompletion = nil
            self.rs_pendingProduct = nil
        }
    }
    
    private func rs_handlePurchaseFailure(transaction: SKPaymentTransaction) {
        let errorMessage = transaction.error?.localizedDescription ?? "Purchase failed"
        SKPaymentQueue.default().finishTransaction(transaction)
        
        DispatchQueue.main.async { [weak self] in
            // 用户取消不算错误
            if let error = transaction.error as? SKError, error.code == .paymentCancelled {
                self?.rs_purchaseCompletion?(false, nil)
            } else {
                self?.rs_purchaseCompletion?(false, errorMessage)
            }
            self?.rs_purchaseCompletion = nil
            self?.rs_pendingProduct = nil
        }
    }
}
