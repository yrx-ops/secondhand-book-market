package com.bookloop.backend.service;

import com.bookloop.backend.vo.UserVO;
import java.util.List;

public interface UserService {

    /**
     * 获取所有用户列表
     *
     * @return 用户列表
     */
    List<UserVO> listUsers();
}
