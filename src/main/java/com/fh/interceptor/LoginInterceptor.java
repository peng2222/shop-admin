package com.fh.interceptor;

import com.fh.model.User;
import com.fh.util.JsonUtil;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

public class LoginInterceptor extends HandlerInterceptorAdapter {


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        //获取session中的user数据
        User user = (User) request.getSession().getAttribute("user");
        /*
        //获得方法
        HandlerMethod HandlerMethod = (HandlerMethod) handler;
        Method method = HandlerMethod.getMethod();
        //判断方法上是否有@Ignore自定义注解 有注解的方法就是要放开的方法
        if (method.isAnnotationPresent(Ignore.class)) {
            return true;
        }
        if(user == null){
            //用户没有登录  跳转到登陆页面
            response.sendRedirect("redirect:/login.jsp");
            System.out.println("你已经被拦截---!");
            return false;
        }
        */

        //判断用户是否已登录，如果已登录就放行，如果没登录就拦截
        if(user != null){
            return true;
        }

        //判断用户发起的是不是ajax请求，如果是ajax请求就不能直接重定向到登录页面了！
        if(request.getHeader("X-Requested-With") != null && request.getHeader("X-Requested-With").equals("XMLHttpRequest")){
            Map<String,Object> result = new HashMap<>();
            result.put("code",2000);
            JsonUtil.outJson(response,result);
        }else{
            //重定向到登录页面
            response.sendRedirect("/login.jsp");
        }

        return false;

    }

}

