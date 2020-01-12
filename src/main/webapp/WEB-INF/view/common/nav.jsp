<%--
  Created by IntelliJ IDEA.
  User: qiaojinghui
  Date: 2019/11/12
  Time: 10:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- 导航栏 -->
<nav class="navbar navbar-inverse" role="navigation">
    <div class="container-fluid col-sm-8">
        <div class="navbar-header">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/UserController/toIndex.do">商品后台管理系统</a>
        </div>
        <div>
            <ul class="nav navbar-nav" id="menuUl">
                <%--<li class="active"><a href="#">商品管理</a></li>
                <li><a href="#">分类管理</a></li>
                <li><a href="#">品牌管理</a></li>
                <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                系统管理
                <b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                <li class="dropdown offset-right">
                <a class="dropdown-toggle" data-toggle="dropdown" href="<%=request.getContextPath()%>/UserController/toUserList.do">
                用户管理
                <span class="glyphicon glyphicon-arrow-right"></span>
                </a>
                <ul class="dropdown-menu">
                <li><a href="#">用户管理1</a></li>
                <li><a href="#">用户管理2</a></li>
                </ul>
                </li>
                <li><a href="<%=request.getContextPath()%>/RoleController/toRoleList.do">角色管理</a></li>
                <li><a href="<%=request.getContextPath()%>/PermissionController/toPermissionList.do">权限管理</a></li>
                </ul>
                </li>--%>
            </ul>
        </div>
    </div>
    <div class="col-sm-4" style="color:#fff">
        <div class="row">
            <div class="col-sm-10">
                <br>
                <marquee scrolldelay=3 scrollamount=5>
                <u>欢迎您,${user.userName}!</u>
                <u>您今天是第${user.loginCount}次登录!</u>
                <u>上次登录时间为<fmt:formatDate value="${user.loginTime}" pattern="yyyy-MM-dd HH:mm:ss"/>!</u>
                </marquee>
            </div>
            <div class="col-sm-2">
                <!-- 展示用户头像 -->
                <img src="<%=request.getContextPath()%>${user.filePath}" height="30" width="30">
                <a href="<%=request.getContextPath()%>/UserController/loginOut.do">注销</a>
            </div>
        </div>


    </div>
</nav>
<script>
    $(function () {
        //发起一个查询当前用户所有菜单权限集合的ajax请求
        $.ajax({
            url:"<%=request.getContextPath()%>/PermissionController/queryMenuPermissionList.do",
            dataType:"json",
            success:function(result){
                if(result.code == 200){
                    var menuHTML = buildMenu(result.data,1);
                    $("#menuUl").html(menuHTML);
                }else{
                    alert("查询菜单失败！");
                }
            },
            error:function () {
                alert("查询菜单失败！");
            }
        });
    });

    function buildMenu(menuPermissionList,pid) {
        var menuHTML = "";
        for(var i = 0; i < menuPermissionList.length;i ++){
            if(menuPermissionList[i].pid == pid){
                //如果当前遍历的菜单权限有儿子，递归调用buildMenu方法
                var isParent = sss(menuPermissionList,menuPermissionList[i].id);
                if(isParent){
                    menuHTML += '<li class="dropdown offset-right">';
                    menuHTML += '<a class="dropdown-toggle" data-toggle="dropdown" href="#">';
                    menuHTML += menuPermissionList[i].name;
                    menuHTML += '<b class="caret"></b>';
                    menuHTML += '</a>';
                    menuHTML += '<ul class="dropdown-menu">';
                    menuHTML += buildMenu(menuPermissionList,menuPermissionList[i].id);
                    menuHTML += '</ul>';
                    menuHTML += '</li>';
                }else{
                    menuHTML += "<li><a href='<%=request.getContextPath()%>" + menuPermissionList[i].url + "'>" + menuPermissionList[i].name + "</a></li>";
                }
            }
        }
        return menuHTML;
    }

    function sss(menuPermissionList,id){
        var flag = false;
        for(var i = 0 ; i < menuPermissionList.length ; i ++ ){
            if(menuPermissionList[i].pid == id){
                flag = true;
                break;
            }
        }
        return flag;
    }
</script>
