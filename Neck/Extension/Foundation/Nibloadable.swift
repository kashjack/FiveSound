//
//  Nibloadable.swift
//  HomePlus
//
//  Created by worldunionViolet on 2018/5/28.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import Foundation
import UIKit

protocol Nibloadable {
    static var nibName: String {get}
}

protocol HFNibloadable {
    static var nibName: String {get}
}

protocol VCNibloadable {
    static var nibName: String {get}
}

protocol CellNibloadable {
    static var nibName: String {get}
}

extension Nibloadable where Self : UIView {
    static var nibName:String {
        return "\(self)"
    }
    /*
     static func loadNib(_ nibNmae :String = "") -> Self{
     let nib = nibNmae == "" ? "\(self)" : nibNmae
     return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
     }

     class TGEmoticonInputV: UIView,Nibloadable {  实现集成
     */
    static func loadNib(_ nibNmae :String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}

extension HFNibloadable where Self: UITableViewHeaderFooterView {
    static var nibName:String {
        return "\(self)"
    }
    
    static func loadNib(_ nibNmae :String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}

extension CellNibloadable where Self: UITableViewCell {
    static var nibName:String {
        return "\(self)"
    }
    
    static func loadNib(_ nibNmae :String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}

extension VCNibloadable where Self : UIViewController {
    static var nibName:String {
        return "\(self)"
    }
    /*
     static func loadNib(_ nibNmae :String = "") -> Self{
     let nib = nibNmae == "" ? "\(self)" : nibNmae
     return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
     }
     
     class TGEmoticonInputV: UIView,Nibloadable {  实现集成
     */
    static func loadNib(_ nibNmae :String? = nil) -> Self {
        let hasNib: Bool = Bundle.main.path(forResource: nibNmae ?? "\(self)", ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter") // here
            return self.init()
        }
        if let nibN = nibNmae {
            return UIViewController.init(nibName: nibN, bundle: Bundle.main) as! Self
        }else{
            return UIViewController.init(nibName: "\(self)", bundle: Bundle.main) as! Self
        }
    }
}
