//
//  JKBmobHelper.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
typealias BmobResultClosure = (Bool, Error?) -> Void

class JKBmobHelper: NSObject {

    // MARK:  增加
    class func addObject(className: String, dic: [String : Any], result: BmobResultClosure?) {
        guard let bmobObject = BmobObject.init(className: className) else {
            HUD.show(.label("增加失败"))
            return
        }
        for (key, value) in dic {
            bmobObject.setObject(value, forKey: key)
        }
        bmobObject.saveInBackground(resultBlock: result)
    }

    // MARK:  删除
    class func deleteObject(className: String, id: String, result: BmobResultClosure?) {
        guard let bmobQuery = BmobQuery.init(className: className) else {
            HUD.show(.label("修改失败"))
            return
        }
        bmobQuery.getObjectInBackground(withId: id) { (object, error) in
            guard error == nil, object != nil else {
                result!(false, error!)
                return
            }
            object!.deleteInBackground(result)
        }
    }

    // MARK:  更新
    class func updateObject(className: String, id: String, dic: [String : Any], result: BmobResultClosure?) {
        guard let bmobQuery = BmobQuery.init(className: className) else {
            HUD.show(.label("修改失败"))
            return
        }
        printLog(id)
        printLog(className)
        bmobQuery.getObjectInBackground(withId: id) { (object, error) in
            guard error == nil, object != nil else {
                result!(false, error!)
                return
            }
            let obj = BmobObject.init(outDataWithClassName: object!.className, objectId: object!.objectId)!
            for (key, value) in dic {
                obj.setObject(value, forKey: key)
                obj.updateInBackground(resultBlock: result)
            }
        }
    }

    // MARK:  查询
    class func queryObjects(className: String, dic: [String : Any], result: BmobResultClosure?) {
        guard let bmobQuery = BmobQuery.init(className: className) else {
            HUD.show(.label("查询失败"))
            return
        }
        bmobQuery.findObjectsInBackground({ (objects, error) in
            guard error == nil, objects != nil else {
                result!(false, error!)
                return
            }
            for i in 0..<(objects!.count) {
                guard let object = objects?[i] as? BmobObject else { return }
                let imageUrl = object.object(forKey: "imageUrl") as! String
            }
        })
    }


}
