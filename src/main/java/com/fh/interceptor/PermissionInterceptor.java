package com.fh.interceptor;

import com.fh.model.Permission;
import com.fh.util.JsonUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PermissionInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        //从session对象中取出后台管理系统所有的权限集合和当前登录用户所拥有的权限集合
        HttpSession session = request.getSession();
        List<Permission> allPermissionList = (List<Permission>)session.getAttribute("allPermissionList");
        List<Permission> permissionList = (List<Permission>)session.getAttribute("permissionList");


        //判断当前请求url有没有在后台管理系统所有权限集合中，如果不在则说明该请求为公共资源，不需要拦截！！！
        String uri = request.getRequestURI();
        boolean isNeedControl = false;
        for(Permission permission : allPermissionList){
            if(StringUtils.isNotBlank(permission.getUrl()) && uri.contains(permission.getUrl())){
                isNeedControl = true;
                break;//跳出当前循环
            }
        }
        //如果当前请求的url需要管控
        if(isNeedControl){
            //判断当前请求url有没有在当前登录用户所拥有的权限集合中，如果不在则说明该用户没有权限!
            boolean hasPermission = false;
            for(Permission permission : permissionList){
                if(StringUtils.isNotBlank(permission.getUrl()) && uri.contains(permission.getUrl())){
                    hasPermission = true;
                    break;
                }
            }
            //如果当前用户有该请求url的访问权限则放行
            if(hasPermission){
                return true;
            }else{
                //判断当前请求是否为ajax请求，如果是ajax请求则通过response对象返回一个状态码，否则直接重定向到无权限页面
                if(request.getHeader("X-Requested-With") != null && request.getHeader("X-Requested-With").equals("XMLHttpRequest")){
                    Map<String,Object> result = new HashMap<>();
                    result.put("code",3000);
                    JsonUtil.outJson(response,result);
                }else{
                    response.sendRedirect(request.getContextPath() + "/no-permission.jsp");
                }
                return false;
            }
        }else {
            return true;
        }
    }
}
