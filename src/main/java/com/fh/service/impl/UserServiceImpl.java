package com.fh.service.impl;

import com.fh.mapper.UserMapper;
import com.fh.model.DataTableResult;
import com.fh.model.User;
import com.fh.model.UserQuery;
import com.fh.model.UserRole;
import com.fh.service.UserRoleService;
import com.fh.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private UserRoleService userRoleService;

    @Override
    public DataTableResult queryUserList(UserQuery userQuery) {

        //1.查询总数
        Long count = userMapper.queryUserCount(userQuery);

        //2.查询当前页数据
        List<User> userList =  userMapper.queryUserList(userQuery);

        DataTableResult dataTableResult = new DataTableResult(userQuery.getDraw(),count,count,userList);
        return dataTableResult;
    }

    @Override
    public void addUser(User user) {
        user.setCreateDate(new Date());
        //默认添加用户时给个正常状态
        userMapper.addUser(user);
        //Ctrl+Alt+M可以快速的把一段代码提成一个单独的方法
        addUserRoles(user);
    }

    @Override
    public void updateUser(User user) {
        user.setUpdateDate(new Date());
        userMapper.updateUser(user);
        //删除用户之前关联的角色
        userRoleService.deleteUserRoleByUserId(user.getId());
        addUserRoles(user);
    }

    private void addUserRoles(User user) {
        //给用户关联新的角色
        if (StringUtils.isNotBlank(user.getRoleIds())) {
            List<UserRole> userRoleList = new ArrayList<>();
            String[] roleIdArr = user.getRoleIds().split(",");
            for (String roleId : roleIdArr) {
                UserRole userRole = new UserRole();
                userRole.setUserId(user.getId());
                userRole.setRoleId(Integer.valueOf(roleId));
                userRoleList.add(userRole);
            }
            userRoleService.addUserRoles(userRoleList);
        }
    }

    @Override
    public User getUserById(Integer id) {
        User user = userMapper.getUserById(id);
        List<UserRole> userRoleList = userRoleService.queryUserRoleListByUserId(id);
        //user.setUserRoleList(userRoleList);
        //如果用户已经关联了角色，则将用户已关联的角色id拼成一个字符串，多个角色id之间使用，隔开
        if(userRoleList != null && !userRoleList.isEmpty()){
            String roleIds = "";
            for(UserRole userRole : userRoleList){
                roleIds += userRole.getRoleId() + ",";
            }
            roleIds = roleIds.substring(0,roleIds.length()-1);
            //核心代码
            user.setRoleIds(roleIds);
        }
        return user;
    }

    @Override
    public void deleteUser(Integer id) {
        userMapper.deleteUser(id);
    }

    @Override
    public List<User> queryUserListByIds(List<Integer> idList) {
        return userMapper.queryUserListByIds(idList);
    }

    @Override
    public void batchDeleteUser(List<Integer> idList) {
        userMapper.batchDeleteUser(idList);
    }

    //-----------------------------------------------用户登录模块---------------------------------------
    @Override
    public User getUserByName(String userName) {
        return userMapper.getUserByName(userName);
    }

    @Override
    public void updateUserErrorCountAndErrorTime(User user) {
        userMapper.updateUserErrorCountAndErrorTime(user);
    }

    @Override
    public void updateUserLoginCountAndUserLoginTime(User user) {
        userMapper.updateUserLoginCountAndUserLoginTime(user);
    }

    @Override
    public List<User> queryUserListNoPage(UserQuery userQuery) {
        return userMapper.queryUserListNoPage(userQuery);
    }

    @Override
    public void batchAddUser(List<User> userList) {
        userMapper.batchAddUser(userList);
    }
}
