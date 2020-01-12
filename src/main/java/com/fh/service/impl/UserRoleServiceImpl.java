package com.fh.service.impl;

import com.fh.mapper.UserRoleMapper;
import com.fh.model.UserRole;
import com.fh.service.UserRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserRoleServiceImpl implements UserRoleService {

    @Autowired
    private UserRoleMapper userRoleMapper;


    @Override
    public void addUserRoles(List<UserRole> userRoleList) {
        userRoleMapper.addUserRoles(userRoleList);
    }

    @Override
    public List<UserRole> queryUserRoleListByUserId(Integer id) {
        return userRoleMapper.queryUserRoleListByUserId(id);
    }

    @Override
    public void deleteUserRoleByUserId(Integer id) {
        userRoleMapper.deleteUserRoleByUserId(id);
    }
}
