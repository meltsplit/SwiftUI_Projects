//
//  PathType.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import Foundation


enum PathType: Hashable {
  case home
  case todo
  case memo(isCreateModel: Bool, memo: Memo?)
}
