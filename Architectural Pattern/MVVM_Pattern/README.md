오. 한가지 신기한 것은 Cell의 DetailTextLabel에 저장된 데이터를 전부 출력하고 싶으면 UITableViewCell.detailTextLabel?.numberOfLines = 0으로 설정하면됨. 근데 여기서 tableView(_:heightForRowAt:)메소드로 높이 제한해버리면 titleLabelf과 겹치게 될수있음.
