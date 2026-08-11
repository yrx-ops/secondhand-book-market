package com.bookloop.backend.vo;

import lombok.Data;

@Data
public class UserVO {

    private Long id;

    private String username;

    private String nickname;

    private String avatarUrl;

    private Integer status;
}
