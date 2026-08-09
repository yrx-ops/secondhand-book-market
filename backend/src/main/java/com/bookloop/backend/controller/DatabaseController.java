package com.bookloop.backend.controller;

import com.bookloop.backend.mapper.DatabaseMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/db")
@CrossOrigin(origins = "http://localhost:5173")
public class DatabaseController {

    @Autowired
    private DatabaseMapper databaseMapper;

    @GetMapping("/ping")
    public String ping() {
        databaseMapper.ping();
        return "Database OK";
    }
}
