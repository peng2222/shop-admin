package com.fh.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fh.model.Student;

import java.util.List;

public interface StudentMapper extends BaseMapper<Student> {

    List<Student> queryAll();
}
