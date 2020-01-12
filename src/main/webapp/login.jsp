<%--
  Created by IntelliJ IDEA.
  User: qiaojinghui
  Date: 2019/11/12
  Time: 9:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="/WEB-INF/view/common/static.jsp" />
    <script>

        //用户回车直接登录
        $(function(){
            window.onkeydown = function(event){
                if(event.keyCode == 13){
                    login();
                }
            }
        });

        function changeCheckCode(){
            //因为浏览器对url的结果有缓存
            $("#checkCodeImg").attr("src","<%=request.getContextPath()%>/CheckCodeServlet?aaa=" + Math.random());
        }

        function login() {
            //trim() 去除字符串左右两侧的空格
            var username = $("#username").val().trim();
            var password = $("#password").val().trim();
            //var checkCode = $("#checkCode").val().trim();
            if(username == ""){
                alert("用户名不能为空!");
            }else if(password == ""){
                alert("密码不能为空!");
            }/*else if(checkCode == ""){
                alert("验证码不能为空!");
            }*/else{
                //发起一个登录的ajax请求
                $.ajax({
                    "url":"<%=request.getContextPath()%>/UserController/login.do",
                    "type":"post",
                    "data":{"username":username,"password":password,/*"checkCode":checkCode*/},
                    dataType:"json",
                    success:function(result){
                        if(result.code != 500){

                                if(result.code == 1){
                                    alert("验证码为空!");
                                }else if(result.code == 2){
                                    alert("验证码错误!");
                                }else if(result.code == 3 || result.code == 4){
                                    alert("用户名或密码错误!");
                                }else if(result.code == 6){
                                    alert("您的账号已被锁定，请24小时后再次重试!");
                                }else{
                                    alert("登录成功!");
                                    //跳转到商品后台管理系统的【主页面】
                                    location.href = "<%=request.getContextPath()%>/UserController/toIndex.do";
                                }
                                if(result.code != 5){
                                    changeCheckCode();
                                }

                        }else{
                            alert("登录失败!");
                        }
                    },
                    error:function(){
                    alert("登录失败!");
                }
                });
            }
        }


    </script>
</head>
<body>


    <!-- 登录账号面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                账号登录
            </h3>
        </div>
        <div class="panel-body">
            <form class="form-horizontal" brand="form">
                <div class="container">

                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">账号:</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="username" placeholder="请输⼊账号">
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">密码:</label>
                                <div class="col-sm-4">
                                    <input type="password" class="form-control" id="password" placeholder="请输⼊密码">
                                </div>
                            </div>
                        </div>
                    </div>


                    <%--<div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">验证码:</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="checkCode"><img id="checkCodeImg" onclick="changeCheckCode()" src="<%=request.getContextPath()%>/CheckCodeServlet"/>
                                </div>
                            </div>
                        </div>
                    </div>--%>


                    <div class="row">
                        <div class="col-md-12" style="text-align:center">
                            <button type="button" class="btn btn-primary" onclick="login()">
                                <span class="glyphicon glyphicon-search"></span>&nbsp;登录
                            </button>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <button type="reset" class="btn btn-danger">
                                <span class="glyphicon glyphicon-refresh"></span>&nbsp;重置
                            </button>
                        </div>
                    </div>


                </div>
            </form>
        </div>
    </div>

</body>
</html>
