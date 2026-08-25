package com.bookloop.backend.controller;

import com.bookloop.backend.dto.LoginDTO;
import com.bookloop.backend.dto.RegisterDTO;
import com.bookloop.backend.service.UserService;
import com.bookloop.backend.vo.UserVO;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "http://localhost:5173")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public UserVO register(@Valid @RequestBody RegisterDTO registerDTO) {
        return userService.register(registerDTO);
    }

    @PostMapping("/login")
    public UserVO login(@Valid @RequestBody LoginDTO loginDTO) {
        return userService.login(loginDTO);
    }
}
