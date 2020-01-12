package com.fh.logAop;

import com.fh.common.LogMsg;
import com.fh.model.Log;
import com.fh.model.User;
import com.fh.service.LogService;
import net.sf.json.JSONSerializer;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.Map;

public class LogAspect {
    private static final Logger LOG = LoggerFactory.getLogger(LogAspect.class);
    @Autowired
    private LogService logService;
    public Object doLog(ProceedingJoinPoint pjp){
        Object obj=null;
        ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = requestAttributes.getRequest();
        User user = (User) request.getSession().getAttribute("user");
        String userName = "游客";
        //获取当前用户名
        if(user == null){
            userName = user.getUserName();
        }
        //获取全限定名  （包名+类名）
        String className = pjp.getTarget().getClass().getCanonicalName();
        //获取方法名
        String methodName = pjp.getSignature().getName();
        //获取参数
        Map<String,String[]> parameterMap = request.getParameterMap();
        String jsonString = JSONSerializer.toJSON(parameterMap).toString();
        //获取注解里面的Value
        String action = "";
        //获取方法签名
        MethodSignature signature = (MethodSignature)pjp.getSignature();
        //获取方法
        Method method = signature.getMethod();
        //判断是否在LogMsg.class注解
        if (method.isAnnotationPresent(LogMsg.class)){
            LogMsg annotation = method.getAnnotation(LogMsg.class);
            action = annotation.value();
        }
        String info = userName + "调用了" + className + "中的" + methodName + "方法";
        try {
            obj = pjp.proceed();
            addLog(userName,jsonString,action,info,1);
            if(LOG.isDebugEnabled()){
                if(user!=null){
                    LOG.debug("----------------{}调用了{}中的{}方法",user.getUserName(),className,methodName);
                }else{
                    LOG.debug("----------------用户没有登陆 在{}登陆了系统",new Date());
                }
            }
        } catch (Throwable e) {
            // TODO Auto-generated catch block
            addLog(userName,jsonString,action,info,2);
            e.printStackTrace();
        }
        return obj;
    }

    private void addLog(String userName, String jsonString, String action, String info, int i) {
        Log log=new Log();
        log.setStatus(i);
        log.setCreateTime(new Date());
        log.setParameter(jsonString);
        log.setContent(info);
        log.setUsername(userName);
        log.setAction(action);
        logService.addLog(log);
    }
    public void beforeMethod(){
        System.out.println("===========开启事务=============");
    }
    public void afterMethod(){
        System.out.println("===========关闭事务=============");
    }
}
