<html>
    <head>
        <style>
            body{
                font-family: SimSun;
            }
        </style>
    </head>
    <body>
        <h1>角色列表</h1>
        <table border="1" cellspacing="0" cellpadding="0">
            <thead>
                <tr>
                    <th>角色id</th>
                    <th>角色名称</th>
                    <th>状态</th>
                    <th>描述</th>
                    <th>创建时间</th>
                    <th>修改时间</th>
                </tr>
            </thead>
            <tbody>
                <#list roleList as role>
                <tr>
                    <td>${role.id!}</td>
                    <td>${role.name!}</td>
                    <td>
                        <#if (role.status)??>
                        <#assign aaaaa=(role.status==1)?string("启用","禁用")/>
                        ${aaaaa}
                        <#else>
                        此项为空
                        </#if>
                    </td>
                    <td>${role.remark!}</td>
                    <td>${(role.createDate?datetime)!}</td>
                    <td>${(role.updateDate?datetime)!}</td>
                </tr>
                </#list>
            </tbody>
        </table>
    </body>
</html>