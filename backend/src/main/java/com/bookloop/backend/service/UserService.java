package com.bookloop.backend.service;

import com.bookloop.backend.dto.LoginDTO;
import com.bookloop.backend.dto.RegisterDTO;
import com.bookloop.backend.vo.UserVO;
import java.util.List;

public interface UserService {

    /**
     * 获取所有用户列表
     *
     * @return 用户列表
     */
    List<UserVO> listUsers();

    /**
     * 用户注册
     *
     * @param registerDTO 注册信息
     * @return 注册成功的用户信息
     */
    UserVO register(RegisterDTO registerDTO);

    /**
     * 用户登录
     *
     * @param loginDTO 登录信息
     * @return 登录成功的用户信息
     */
    UserVO login(LoginDTO loginDTO);
}
