//
//  BaseViewController.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/29/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TO BE OVERRIDE
    func initialize() { }
    func navigationTitle() -> String { return "" }
    func backgroundColor() -> UIColor { return .white }
    func shouldHideNavigationBar() -> Bool { return true }
    func configureSubviews() { }
    func configureLayout() { }
    func configureContent() { }
    func configureStyle() { }
    func configureActions() { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navigationTitle()
        self.view.backgroundColor = backgroundColor()
        configureSubviews()
        configureLayout()
        configureContent()
        configureStyle()
        configureActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(shouldHideNavigationBar(), animated: false)
    }
}
