//
//  AWSMobileClient.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.5
//
//
import Foundation
import UIKit
import AWSCore
import AWSMobileHubHelper

/**
 * AWSMobileClient is a singleton that bootstraps the app. It creates an identity manager to establish the user identity with Amazon Cognito.
 */
class AWSMobileClient: NSObject {
    
    // Shared instance of this class
    static let sharedInstance = AWSMobileClient()
    private var isInitialized: Bool
    
    private override init() {
        isInitialized = false
        super.init()
    }
    
    deinit {
        // Should never be called
        print("Mobile Client deinitialized. This should not happen.")
    }
    
    /**
     * Configure third-party services from application delegate with url, application
     * that called this provider, and any annotation info.
     *
     * - parameter application: instance from application delegate.
     * - parameter url: called from application delegate.
     * - parameter sourceApplication: that triggered this call.
     * - parameter annotation: from application delegate.
     * - returns: true if call was handled by this component
     */
    func withApplication(application: UIApplication, withURL url: NSURL, withSourceApplication sourceApplication: String?, withAnnotation annotation: AnyObject) -> Bool {
        print("withApplication:withURL")
        AWSIdentityManager.defaultIdentityManager().interceptApplication(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        if (!isInitialized) {
            isInitialized = true
        }
        
        return false;
    }
    
    /**
     * Performs any additional activation steps required of the third party services
     * e.g. Facebook
     *
     * - parameter application: from application delegate.
     */
    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive:")
    }
    
    
    /**
    * Configures all the enabled AWS services from application delegate with options.
    *
    * - parameter application: instance from application delegate.
    * - parameter launchOptions: from application delegate.
    */
    func didFinishLaunching(application: UIApplication, withOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        print("didFinishLaunching:")

        // Register the sign in provider instances with their unique identifier
        AWSSignInProviderFactory.sharedInstance().registerAWSSignInProvider(AWSFacebookSignInProvider.sharedInstance(), forKey: AWSFacebookSignInProviderKey)
        AWSSignInProviderFactory.sharedInstance().registerAWSSignInProvider(AWSGoogleSignInProvider.sharedInstance(), forKey: AWSGoogleSignInProviderKey)
        
            
        let didFinishLaunching: Bool = AWSIdentityManager.defaultIdentityManager().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)

        if (!isInitialized) {
            AWSIdentityManager.defaultIdentityManager().resumeSessionWithCompletionHandler({(result: AnyObject?, error: NSError?) -> Void in
                print("Result: \(result) \n Error:\(error)")
            }) // If you get an EXC_BAD_ACCESS here in iOS Simulator, then do Simulator -> "Reset Content and Settings..."
               // This will clear bad auth tokens stored by other apps with the same bundle ID.
            isInitialized = true
        }

        return didFinishLaunching
    }

}
