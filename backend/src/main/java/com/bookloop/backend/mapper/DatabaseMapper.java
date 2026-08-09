package com.bookloop.backend.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface DatabaseMapper {

    @Select("SELECT 1")
    Integer ping();
}
