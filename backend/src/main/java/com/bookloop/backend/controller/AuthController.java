package com.bookloop.backend.controller;

import com.bookloop.backend.dto.LoginDTO;
import com.bookloop.backend.dto.RegisterDTO;
import com.bookloop.backend.service.UserService;
import com.bookloop.backend.util.JwtUtil;
import com.bookloop.backend.vo.LoginVO;
import com.bookloop.backend.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "http://localhost:5173")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    public UserVO register(@Valid @RequestBody RegisterDTO registerDTO) {
        return userService.register(registerDTO);
    }

    @PostMapping("/login")
    public LoginVO login(@Valid @RequestBody LoginDTO loginDTO) {
        return userService.login(loginDTO);
    }

    @GetMapping("/me")
    public String me(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return "未携带 Token";
        }
        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            return "Token 无效或已过期";
        }
        String username = jwtUtil.getUsernameFromToken(token);
        return "欢迎回来，用户：" + username;
    }
}
