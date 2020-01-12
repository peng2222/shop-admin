<%--
  Created by IntelliJ IDEA.
  User: mac
  Date: 2019/11/25
  Time: 14:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="../common/static.jsp" />
    <script>

        //用于存放新增商品DIV的HTML代码的全局变量
        var addProductDivHTML;


        $(function () {

            addProductDivHTML = $("#addProductDiv").html();

            //初始化商品表格
            initProductTable();

        })

        //条件查询
        function search(){
            productTable.ajax.reload();
        }


        var productTable;
        function initProductTable(){
            //初始化商品表格
            productTable = $("#productTable").DataTable({
                searching:false,
                ordering:false,
                serverSide:true, //开启服务端模式
                lengthMenu:[3,5,10,15],
                processing:true,//是否显示正在处理中
                language:chinese,
                ajax:{
                    url:"<%=request.getContextPath()%>/ProductController/queryProductList.do",
                    type:"post",
                    data:function(param){
                        //DataTables在发送ajax请求的时候会发送一些自己的参数，比如说每页显示条数，起始条数等等。。。
                        //通过param这个参数咱们可以设置自己需要传递的参数，比如说条件查询的值
                        param.name = $("#name").val();
                        param.status = $("[name=status]:checked").val();
                    }
                },
                columns:[
                    {
                        data:"id",
                        render:function(data){
                            return "<input type='checkbox' name='id' value='"+data+"'/>";
                        }
                    },
                    {data:"name"},
                    {data:"title"},
                    {data:"brandName"},
                    {
                        data:"status",
                        render:function (data) {
                            return data == 1?"上架":"下架";
                        }
                    },
                    {
                        data:"isHot",
                        render:function (data) {
                            return data == 1?"是":"否";
                        }
                    },
                    {data:"price"},
                    {
                        data:"filePath",
                        render:function (data) {
                            return "<img width='50' height='50' src='"+data+"' />";
                        }
                    },
                    {data:"remark"},
                    {
                        data:"id",
                        render:function(data){
                            return '<div class="btn-group btn-group-xs">'+
                                '<button type="button" onclick="showUpdateProductDialog(' + data + ')" class="btn btn-primary">'+
                                '<span class="glyphicon glyphicon-pencil"></span>&nbsp;修改'+
                                '</button>'+
                                '<button type="button" onclick="deleteProduct(' + data + ')" class="btn btn-danger">'+
                                '<span class="glyphicon glyphicon-trash"></span>&nbsp;删除'+
                                '</button>'+
                                '<button type="button" onclick="select(' + data + ')" class="btn btn-info">'+
                                '<span class="glyphicon glyphicon-file"></span>&nbsp;查看附件'+
                                '</button>'+
                                '</div>';
                        }}
                ]
            });
        }

        //初始化新增商品SPU属性DIV的内容
        function initAddSpuAttributeDiv(spuAttributeArr,elementId){
            var addSpuAttributeDivHTML = "";
            //遍历spu属性数组
            for(var i = 0 ; i < spuAttributeArr.length ; i ++){
                addSpuAttributeDivHTML += "<div class='attribute'><div class='attributeName' isSku='" + (spuAttributeArr[i].type==1?2:1) + "'  attributeId='" + spuAttributeArr[i].id + "' attributeName='" + spuAttributeArr[i].name + "'>" + spuAttributeArr[i].name + ":</div><div class='attributeValue'>";
                //先判断当前遍历输入的属性值录入方式(inputType)
                //如果是手动输入(inputType==1)直接显示一个文本框
                //如果是从可选项中选择(inputType==2)这时候咱们再去判断属性选择方式(selectType)
                //如果selectType==3 就把可选项展示成复选框
                //如果selectType==4 就把可选项展示成下拉框
                if(spuAttributeArr[i].inputType == 1){
                    addSpuAttributeDivHTML += "<input class='abc' name='" + spuAttributeArr[i].id + "' type='text' /></div>";
                }else{
                    //如果selectType==2 就把可选项展示成单选按钮
                    if(spuAttributeArr[i].selectType == 2){
                        //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                        var valueArr =  spuAttributeArr[i].inputList.split(",");
                        var valueIdArr = spuAttributeArr[i].valueIdList.split(",");
                        for(var j = 0 ; j < valueArr.length ; j ++ ){
                            addSpuAttributeDivHTML += "<input class='abc' type='radio' name='" + spuAttributeArr[i].id + "' valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "' />" + valueArr[j];
                        }
                    }else if(spuAttributeArr[i].selectType == 3){
                        //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                        var valueArr =  spuAttributeArr[i].inputList.split(",");
                        var valueIdArr = spuAttributeArr[i].valueIdList.split(",");
                        for(var j = 0 ; j < valueArr.length ; j ++ ){
                            addSpuAttributeDivHTML += "<input class='abc' type='checkbox' name='" + spuAttributeArr[i].id + "' valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "' />" + valueArr[j];
                        }
                    }else if(spuAttributeArr[i].selectType == 4){
                        addSpuAttributeDivHTML += "<select class='form-control abc' name='" + spuAttributeArr[i].id + "'>";
                        //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                        var valueArr =  spuAttributeArr[i].inputList.split(",");
                        var valueIdArr = spuAttributeArr[i].valueIdList.split(",");
                        for(var j = 0 ; j < valueArr.length ; j ++ ){
                            addSpuAttributeDivHTML += "<option valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "'>" + valueArr[j] + "</option>";
                        }
                        addSpuAttributeDivHTML += "</select>";
                    }
                    addSpuAttributeDivHTML += "</div>";
                    //如果当前遍历的属性允许新增属性值
                    if(spuAttributeArr[i].addable == 1){
                        addSpuAttributeDivHTML += "<div><input type='text' /><button onclick='addCustomValue(this," + spuAttributeArr[i].selectType + "," + spuAttributeArr[i].id + "," + spuAttributeArr[i].type + ")' type='button' class='btn-link'>新增</button></div>";
                    }

                }
                addSpuAttributeDivHTML += "</div>";
            }
            $("#" + elementId).html(addSpuAttributeDivHTML);
        }

        //初始化新增商品SKU属性DIV的内容
        function initAddSkuAttributeDiv(skuAttributeArr,elementId){
            var type = elementId == "updateSkuAttributeDiv" ? 2:1;
            var addSkuAttributeDivHTML = "";
            //遍历sku属性数组
            for(var i = 0 ; i < skuAttributeArr.length ; i ++){
                addSkuAttributeDivHTML += "<div class='attribute'><div class='attributeName' isSku='" + (skuAttributeArr[i].type==1?2:1) + "' attributeId='" + skuAttributeArr[i].id + "' attributeName='" + skuAttributeArr[i].name + "'>" + skuAttributeArr[i].name + ":</div><div class='attributeValue'>";
                //先判断当前遍历输入的属性值录入方式(inputType)
                //如果是手动输入(inputType==1)直接显示一个文本框
                //如果是从可选项中选择(inputType==2)这时候咱们再去判断属性选择方式(selectType)
                //如果selectType==3 就把可选项展示成复选框
                //如果selectType==4 就把可选项展示成下拉框
                if(skuAttributeArr[i].inputType == 1){
                    addSkuAttributeDivHTML += "<input class='abc' name='" + skuAttributeArr[i].id + "' type='text' /></div>";
                }else{
                    //如果selectType==2 就把可选项展示成单选按钮
                    if(skuAttributeArr[i].selectType == 2){
                        //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                        var valueArr =  skuAttributeArr[i].inputList.split(",");
                        var valueIdArr = skuAttributeArr[i].valueIdList.split(",");
                        for(var j = 0 ; j < valueArr.length ; j ++ ){
                            addSkuAttributeDivHTML += "<input class='abc' type='radio' name='" + skuAttributeArr[i].id + "' valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "' onclick='initSkuTable(" + type + ")' />" + valueArr[j];
                        }
                    }else if(skuAttributeArr[i].selectType == 3){
                        //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                        var valueArr =  skuAttributeArr[i].inputList.split(",");
                        var valueIdArr = skuAttributeArr[i].valueIdList.split(",");
                        for(var j = 0 ; j < valueArr.length ; j ++ ){
                            addSkuAttributeDivHTML += "<input class='abc' type='checkbox' name='" + skuAttributeArr[i].id + "' valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "'  onclick='initSkuTable(" + type + ")' />" + valueArr[j];
                        }
                    }else if(skuAttributeArr[i].selectType == 4){
                        addSkuAttributeDivHTML += "<select class='form-control abc' name='" + skuAttributeArr[i].id + "'  onchange='initSkuTable(" + type + ")'>";
                        //当前遍历属性的可选项值，多个值之间使用逗号隔开的
                        var valueArr =  skuAttributeArr[i].inputList.split(",");
                        var valueIdArr = skuAttributeArr[i].valueIdList.split(",");
                        for(var j = 0 ; j < valueArr.length ; j ++ ){
                            addSkuAttributeDivHTML += "<option valueId='" + valueIdArr[j] + "' value='" + valueArr[j] + "'>" + valueArr[j] + "</option>";
                        }
                        addSkuAttributeDivHTML += "</select>";
                    }
                    addSkuAttributeDivHTML += "</div>";
                    //如果当前遍历的属性允许新增属性值
                    if(skuAttributeArr[i].addable == 1){
                        addSkuAttributeDivHTML += "<div><input type='text' /><button onclick='addCustomValue(this," + skuAttributeArr[i].selectType + "," + skuAttributeArr[i].id + "," + skuAttributeArr[i].type + ")' type='button' class='btn-link'>新增</button></div>";
                    }

                }
                addSkuAttributeDivHTML += "</div>";
            }
            $("#" + elementId).html(addSkuAttributeDivHTML);
        }


        function initSkuTable(type){
            var elementId = type == 1 ? "add" : "update";
            //用于存放所有SKU属性的数组
            var attributeArr = [];
            //获取SKU属性DIV中的所有属性DIV
            $("#" + elementId + "SkuAttributeDiv .attribute").each(function(){
                //获取属性名称的DIV
                var attributeNameDiv = $(this).find(".attributeName");
                //获取属性ID
                var attributeId = attributeNameDiv.attr("attributeId");
                //获取属性名
                var attributeName = attributeNameDiv.attr("attributeName");
                //获取该属性选中的属性值
                //获取属性值的DIV
                var attributeValueDiv = $(this).find(".attributeValue");
                //获取属性值DIV中的属性值元素(单选按钮/复选框/文本框/下拉框)
                var attributeValueElementArr = attributeValueDiv.find(".abc");
                //用于存放当前遍历属性选中的属性值的数组
                var valueArr = [];
                attributeValueElementArr.each(function(){
                    //判断当前遍历的属性值元素的类型(是文本框还是单选按钮还是复选框还是下拉框)
                    var tagName = this.tagName; //INPUT SELECT
                    //如果当前遍历的属性值元素是INPUT类型的
                    if(tagName == "INPUT"){
                        var type = this.type;
                        if(type == "text"){
                            valueArr.push("-1:" + this.value);
                        }else if(type == "radio" && this.checked){
                            valueArr.push($(this).attr("valueId") + ":" + this.value);
                        }else if(type == "checkbox" && this.checked){
                            valueArr.push($(this).attr("valueId") + ":" + this.value);
                        }
                    }else if(tagName == "SELECT"){
                        valueArr.push($(this).find("option:selected").attr("valueId") + ":" + this.value);
                    }
                });

                //创建一个SKU属性对象
                var attribute = {};
                attribute.id = attributeId;
                attribute.name = attributeName;
                attribute.valueList = valueArr;
                if(attribute.valueList.length > 0){
                    attributeArr.push(attribute);
                }
            });
            console.log(attributeArr);
            if(attributeArr.length > 0){
                //【开始生成SKU表格】
                var skuTableHTML = "<table id='addSkuTable' class='table table-striped table-bordered table-hover table-condensed'><thead><tr>";
                //1.生成SKU表格的表头
                var valueListArr = [];
                for(var i = 0 ; i < attributeArr.length ; i ++){
                    skuTableHTML += "<th>" + attributeArr[i].name + "</th>";
                    valueListArr.push(attributeArr[i].valueList);
                }
                skuTableHTML += "<th>库存</th>";
                skuTableHTML += "<th>价格</th>";
                skuTableHTML += "</tr>";
                skuTableHTML += "</thead>";

                //根据所有属性选中值的数组生成笛卡尔积
                var abc = DescartesUtils.descartes(valueListArr);
                console.log(abc);
                //2.生成SKU表格中的数据行
                for(var i = 0 ; i < abc.length ; i ++){
                    skuTableHTML += "<tr class='dataRow'>"
                    for(var j = 0 ; j < abc[i].length ; j ++){
                        var arr = abc[i][j].split(":");
                        skuTableHTML += "<td attributeId='" + attributeArr[j].id + "' valueId='" + arr[0] + "'>" + arr[1] + "</td>";
                    }
                    skuTableHTML += "<td><input type='text' name='stock' style='width:100px'/></td>";
                    skuTableHTML += "<td><input type='text' name='price' style='width:100px'/></td>";
                    skuTableHTML += "</tr>"
                }
                $("#" + elementId + "SkuTableDiv").html(skuTableHTML);
            }
            if(productSkuMap){
                huixianSku(productSkuMap);
            }
        }


        function addCustomValue(obj,selectType,attributeId,attributeType) {
            var value = $(obj).prev(":text").val();
            if(value.trim() == ""){
                alert("属性值不能为空");
                return;
            }

            //发起一个查询属性值是否存在的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/AttributeController/attributeValueIsExisted.do",
                type:"get",
                data:{attributeId:attributeId,value:value},
                dataType:"json",
                success:function(result){
                    if(result.data){


                        var attributeListDiv = $(obj).parent().prev("div");
                        if(attributeType == 1){
                            if(selectType == 2){
                                attributeListDiv.append("<input type='radio' />" + value);
                            }else if(selectType == 3){
                                attributeListDiv.append("<input type='checkbox' />" + value);
                            }else if(selectType == 4){
                                attributeListDiv.find("select").append("<option value='" + value + "'>" + value + "</option>");
                            }
                        }else{
                            if(selectType == 2){
                                attributeListDiv.append("<input type='radio' />" + value);
                            }else if(selectType == 3){
                                attributeListDiv.append("<input type='checkbox' />" + value);
                            }else if(selectType == 4){
                                attributeListDiv.find("select").append("<option value='" + value + "'>" + value + "</option>");
                            }
                        }


                        //把用户手动输入的属性值保存到对应属性的可选项中去
                        //发起一个新增商品属性值的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/AttributeController/addAttributeValue.do",
                            type:"get",
                            data:{attributeId:attributeId,value:value},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                }else{
                                    alert("新增属性值失败!");
                                }
                            },
                            error:function(){
                                alert("新增属性值失败!");
                            }
                        });
                    }else{
                        alert("属性值已存在!");
                    }
                },
                error:function(){
                    alert("新增属性值失败!");
                }
            });


            $(obj).prev(":text").val("");
        }


        function abc(obj){
            if(obj){
                //nextAll是找下面的兄弟节点
                $(obj).parent().nextAll().remove();
                //找到这个下拉框的父亲前面有几个兄弟
                //如果前面没有一个兄弟说明是一级分类，如果前面有一个兄弟说明是二级分类，如果前面有两个兄弟，说明是三级分类。
                var level = $(obj).parent().prevAll().length + 1;
                // alert("当前分类是第" + level + "级分类！");
                //如果当前选择的是第三级商品分类，则获取当前商品分类的id，通过商品分类的id将该分类下的所有属性(SKU属性和SPU属性)查询出来
                // alert(obj.value);
                if(level == 3){
                    $.ajax({
                        url:"<%=request.getContextPath()%>/AttributeController/queryAttributeListByClassifyId.do",
                        data:{classifyId:obj.value},
                        dataType:"json",
                        success:function (result) {
                            if(result.code == 200){
                                //商品分类所有属性的数组
                                var attributeArr = result.data;
                                //存放sku属性的数组
                                var skuAttributeArr = [];
                                //存放spu属性的数组
                                var spuAttributeArr = [];
                                for (var i = 0; i < attributeArr.length; i ++){
                                    //如果type==1说明是spu属性
                                    if(attributeArr[i].type == 1){
                                        spuAttributeArr.push(attributeArr[i]);
                                    }else {
                                        skuAttributeArr.push(attributeArr[i]);
                                    }
                                }
                                //初始化新增商品表单中的SPU属性DIV
                                initAddSpuAttributeDiv(spuAttributeArr,"addSpuAttributeDiv");
                                //初始化新增商品表单中的SKU属性DIV
                                initAddSkuAttributeDiv(skuAttributeArr,"addSkuAttributeDiv");


                            }else {
                                alert("查询属性失败！");
                            }
                        },
                        error:function () {
                            alert("查询属性失败！");
                        }
                    });
                }

            }

            var pid = obj == undefined ? 1 : obj.value;

            $.ajax({
                url:"<%=request.getContextPath()%>/ClassifyController/queryClassifyListByPid.do",
                type:"get",
                data:{pid:pid},
                dataType:"json",
                success:function(result){
                    if(result.data.length < 1){
                        return;
                    }
                    if(result.code == 200){
                        var classifySelectHTML = "<div class='col-sm-4'><select onchange='abc(this)' name='def' style='width:100px' class='form-control'><option value='-1'>请选择</option>";
                        for(var i = 0 ; i < result.data.length ; i ++ ){
                            classifySelectHTML += "<option value='" + result.data[i].id + "'>" + result.data[i].name + "</option>"
                        }
                        classifySelectHTML += "</select></div>";
                        $("#addClassifyDiv").append(classifySelectHTML);
                    }else{
                        alert("查询品牌失败!");
                    }
                },
                error:function(){
                    alert("查询品牌失败!");
                }
            });

        }


        function showAddProductDialog(){
            //发起一个查询品牌的ajax请求
            $.ajax({
                url:"<%=request.getContextPath()%>/BrandController/queryBrandListNoPage.do",
                dataType:"json",
                success:function(result){
                    if(result.code == 200){
                        var brandSelectHTML = "";
                        for(var i = 0 ; i < result.data.length ; i ++){
                            brandSelectHTML += "<option value='" + result.data[i].id + "'>" + result.data[i].name + "</option>";
                        }
                        $("#addBrandSelect").html(brandSelectHTML);
                    }else{
                        alert("查询品牌失败!");
                    }
                },
                error:function(){
                    alert("查询品牌失败!");
                }
            });

            //初始化新增商品表单中的商品头像文件域
            $("#addFile").fileinput({
                language:"zh",//设置语言选项
                maxFileCount:1,//设置最大文件上传数
                //设置文件上传的地址
                uploadUrl:"<%=request.getContextPath()%>/ProductController/uploadFile.do"
            });
            //设置文件上传之后的回调函数
            $("#addFile").on("fileuploaded",function(a,b,c,d){
                //其中b就代表服务器返回的数据
                var result = b.response;
                if(result.code == 200){
                    //将图片上传后的相对路径放入新增商品表单中的用于存放图片相对路径的隐藏域中
                    $("#addFilePath").val(result.filePath);
                }
            });

            abc();

            bootbox.confirm({
                title:"新增商品",
                message:$("#addProductDiv").children(),
                size:"lg",
                buttons:{
                    //設置確定按鈕的文字和樣式
                    confirm:{
                        label:"確認",
                        className:"btn btn-success"
                    },
                    //設置取消按鈕的文字和樣式
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function(result){

                    if(result){
                        //组装数据
                        //1.组装商品的基本信息
                        var product = {};
                        product.name = $("#addName").val();
                        product.title = $("#addTitle").val();
                        product.price = $("#addPrice").val();
                        product.status = $("[name=addStatus]:checked").val();
                        product.isHot = $("[name=addIsHot]:checked").val();
                        product.brandId = $("#addBrandSelect").val();
                        product.filePath = $("#addFilePath").val();
                        //获取所有商品分类下拉框
                        var classifySelectArr = $("#addClassifyDiv [name=def]");
                        product.classifyId1 = classifySelectArr.eq(0).val();
                        product.classifyId2 = classifySelectArr.eq(1).val();
                        product.classifyId3 = classifySelectArr.eq(2).val();
                        product.remark = $("#addRemark").val();
                        console.log(product);

                        //2.组装商品属性的数据
                        var productAttributeArr = [];
                        $(".attribute").each(function () {
                            var attributeNameDiv = $(this).find(".attributeName");
                            var attributeId = attributeNameDiv.attr("attributeId");
                            var attributeName = attributeNameDiv.attr("attributeName");
                            var isSku = attributeNameDiv.attr("isSku");
                            var attributeValueDiv = $(this).find(".attributeValue");
                            attributeValueDiv.find(".abc").each(function () {
                                var productAttribute = {"attributeId":attributeId,"attributeName":attributeName,"isSku":isSku};
                                var tagName = this.tagName;
                                if(tagName == "INPUT"){
                                    if(this.type == "text"){
                                        productAttribute.value = this.value;
                                    }else if((this.type == "radio" || this.type == "checkbox") && this.checked){
                                        productAttribute.valueId = $(this).attr("valueId");
                                        productAttribute.value = this.value;
                                    }
                                }else if(tagName == "SELECT"){
                                    productAttribute.valueId = $(this).find("option:selected").attr("valueId");
                                    productAttribute.value = this.value;
                                }
                                if(productAttribute.value != null){
                                    //把商品放入定义好的商品数组中
                                    productAttributeArr.push(productAttribute);
                                }
                            });
                        });
                        console.log(productAttributeArr);


                        //3.组装商品SKU表的数据
                        var productSkuArr = [];
                        $("#addSkuTable .dataRow").each(function () {
                            var tdArr = $(this).children();
                            var properties = {};
                            tdArr.each(function (i) {
                                if(i < tdArr.length -2){
                                    properties[$(this).attr("attributeId")] = $(this).attr("valueId");
                                }
                            });
                            var productSku = {};
                            productSku.properties = JSON.stringify(properties);
                            productSku.price = $(this).find("[name=price]").val();
                            productSku.stock = $(this).find("[name=stock]").val();
                            productSkuArr.push(productSku);
                        });
                        console.log(productSkuArr);

                        var productInfo = {"product":product,"productAttributeList":productAttributeArr,"productSkuList":productSkuArr};

                        //发送一个新增商品的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/ProductController/addProduct.do",
                            type:"post",
                            data:JSON.stringify(productInfo),//[注意点！！！]
                            contentType:"application/json;charset=utf-8",//[注意点！！！]
                            dataType:"json",
                            success:function (result) {
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("新增商品失败！");
                                }
                            },
                            error:function () {
                                alert("新增商品失败！");
                            }
                        });
                    }
                    $("#addProductDiv").html(addProductDivHTML);
                }
            });

        }


        var productSkuMap = {};
        function showUpdateProductDialog(id){
            alert(id);
            //发送一个通过商品id获取单个商品信息的ajax信息请求
            $.ajax({
                url:"<%=request.getContextPath()%>/ProductController/getProductById.do",
                type:"post",
                data:{"id":id},
                dataType:"json",
                success:function (result) {
                    if(result.code == 200){
                        var product = result.data.product;
                        var productAttributeList = result.data.productAttributeList;
                        var productSkuList = result.data.productSkuList;
                        //初始化修改用户表单中的用户图片文件域
                        $("#updateFile").fileinput({
                            language:"zh",//设置语言选项
                            maxFileCount:1,//设置最大上传文件个数
                            //设置文件上传的地址
                            uploadUrl:"<%=request.getContextPath()%>/ProductController/uploadFile.do"
                        });
                        //设置文件上传之后的回调函数
                        $("#updateFile").on("fileuploaded",function(a,b,c,d){
                            //其中b就代表服务器返回的数据
                            var result = b.response;
                            if(result.code == 200){
                                //将图片上传后的相对路径放入修改用户表单中的用于存放图片相对路径的隐藏域中
                                $("#updateFilePath").val(result.filePath);
                            }
                        });


                        //1. 回显修改商品表单中的商品基本信息
                        $("#updateName").val(product.name);
                        $("#updateTitle").val(product.title);
                        $("#updatePrice").val(product.price);
                        $("#updateRemark").val(product.remark);
                        $("[name=updateStatus][value=" + product.status + "]").prop("checked",true);
                        $("[name=updateIsHot][value=" + product.isHot + "]").prop("checked",true);
                        $("#updateFilePath").val(product.filePath);
                        $("#updateFileImg").attr("src",product.filePath);

                        //初始化修改商品表单中的品牌下拉框并回显
                        //发起一个查询品牌的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/BrandController/queryBrandListNoPage.do",
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    var brandSelectHTML = "";
                                    for(var i = 0 ; i < result.data.length ; i ++){
                                        brandSelectHTML += "<option " + (product.brandId == result.data[i].id ? "selected":"") + " value='" + result.data[i].id + "'>" + result.data[i].name + "</option>";
                                    }
                                    $("#updateBrandSelect").html(brandSelectHTML);
                                }else{
                                    alert("查询品牌失败!");
                                }
                            },
                            error:function(){
                                alert("查询品牌失败!");
                            }
                        });

                        //回显商品分类
                        initClassifySelect(1,product.classifyId1);
                        initClassifySelect(product.classifyId1,product.classifyId2);
                        initClassifySelect(product.classifyId2,product.classifyId3);
                        
                        
                        
                        //2. 回显修改商品表单中的商品属性信息
                        $.ajax({
                            url:"<%=request.getContextPath()%>/AttributeController/queryAttributeListByClassifyId.do",
                            data:{classifyId:product.classifyId3},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    debugger;
                                    //商品分类所有属性的数组
                                    var attributeArr  = result.data;
                                    //存放sku属性的数组
                                    var skuAttributeArr = [];
                                    //存放spu属性的数组
                                    var spuAttributeArr = [];
                                    for(var i = 0 ; i < attributeArr.length ; i ++){
                                        //如果type==1说明是spu属性
                                        if(attributeArr[i].type == 1){
                                            spuAttributeArr.push(attributeArr[i]);
                                        }else{
                                            skuAttributeArr.push(attributeArr[i]);
                                        }
                                    }
                                    //初始化新增商品表单中的SPU属性DIV
                                    initAddSpuAttributeDiv(spuAttributeArr,"updateSpuAttributeDiv");
                                    //初始化新增商品表单中的SKU属性DIV
                                    initAddSkuAttributeDiv(skuAttributeArr,"updateSkuAttributeDiv");

                                    debugger;
                                    //回显属性
                                    var productAttributeMap = {};
                                    //遍历当前修改商品的属性数组
                                    for (var i = 0; i < productAttributeList.length ; i++) {
                                        //获取当前遍历的商品属性的属性id
                                        var attributeId = productAttributeList[i].attributeId;
                                        //获取当前遍历的商品属性的属性值
                                        var value = productAttributeList[i].value;
                                        //判断商品属性JS对象中是否有属性名等于属性id的属性
                                        if(productAttributeMap[attributeId] != null){
                                            //往商品属性JS对象对应属性名的属性值的数组中放入当前遍历商品属性的属性值
                                            productAttributeMap[attributeId].push(value);
                                        }else{
                                            productAttributeMap[attributeId] = [value];
                                        }
                                    }
                                    console.log(productAttributeMap);

                                    $("#updateProductForm .attribute").each(function () {
                                        var attributeNameDiv = $(this).find(".attributeName");
                                        var attributeId = attributeNameDiv.attr("attributeId");
                                        var attributeValueDiv = $(this).find(".attributeValue");
                                        attributeValueDiv.find(".abc").each(function(){
                                            var tagName = this.tagName; //返回的大写的标签名
                                            if(tagName == "INPUT"){
                                                if(this.type == "text"){
                                                    this.value = productAttributeMap[attributeId][0];
                                                }else if((this.type == "radio" || this.type == "checkbox")){
                                                    if(productAttributeMap[attributeId].indexOf(this.value) != -1){
                                                        this.checked = true;
                                                    }
                                                }
                                            }else if(tagName == "SElECT"){
                                                this.value = productAttributeMap[attributeId][0];
                                            }
                                        });
                                    });
                                    initSkuTable(2);


                                    //3.回显修改商品表sku表格的数据
                                    for (var i = 0; i < productSkuList.length; i++) {
                                        productSkuMap[productSkuList[i].properties] = productSkuList[i];
                                    }
                                    huixianSku(productSkuMap);
                                }

                            },

                        });


                        bootbox.confirm({
                            title: "修改商品",
                            message: $("#updateProductDiv").children(),
                            size: "lg",
                            buttons: {
                                //設置確定按鈕的文字和樣式
                                confirm: {
                                    label: "確認",
                                    className: "btn btn-success"
                                },
                                //設置取消按鈕的文字和樣式
                                cancel: {
                                    label: "取消",
                                    className: "btn btn-danger"
                                }
                            },
                            callback: function (result) {
                                if(result){
                                    //组装数据
                                    //1.组装商品的基本信息数据
                                    var updateProduct = {};
                                    updateProduct.id = id;
                                    updateProduct.name = $("#updateName").val();
                                    updateProduct.title = $("#updateTitle").val();
                                    updateProduct.price = $("#updatePrice").val();
                                    updateProduct.status = $("[name=updateStatus]:checked").val();
                                    updateProduct.isHot = $("[name=updateIsHot]:checked").val();
                                    updateProduct.brandId = $("#updateBrandSelect").val();
                                    updateProduct.filePath = $("#updateFilePath").val();
                                    //获取所有商品分类下拉框
                                    var classifySelectArr = $("#updateClassifyDiv [name=def]");
                                    updateProduct.classifyId1 = classifySelectArr.eq(0).val();
                                    updateProduct.classifyId2 = classifySelectArr.eq(1).val();
                                    updateProduct.classifyId3 = classifySelectArr.eq(2).val();
                                    updateProduct.remark = $("#updateRemark").val();
                                    console.log(updateProduct);

                                    //2.组装商品属性的数据
                                    var productAttributeArr = [];
                                    $(".attribute").each(function () {
                                        var attributeNameDiv = $(this).find(".attributeName");
                                        var attributeId = attributeNameDiv.attr("attributeId");
                                        var attributeName = attributeNameDiv.attr("attributeName");
                                        var isSku = attributeNameDiv.attr("isSKu");
                                        var attributeValueDiv = $(this).find(".attributeValue");
                                        attributeValueDiv.find(".abc").each(function(){
                                            var productAttribute = {"attributeId":attributeId,"attributeName":attributeName,"isSku":isSku};
                                            var tagName = this.tagName;
                                            if(tagName == "INPUT"){
                                                if(this.type == "text"){
                                                    productAttribute.value = this.value;
                                                }else if((this.type == "radio" || this.type == "checkbox") && this.checked){
                                                    productAttribute.valueId = $(this).attr("valueId");
                                                    productAttribute.value = this.value;
                                                }
                                            }else if(tagName == "SELECT"){
                                                productAttribute.valueId = $(this).find("option:selected").attr("valueId");
                                                productAttribute.value = this.value;
                                            }
                                            if(productAttribute.value != null){
                                                productAttributeArr.push(productAttribute);
                                            }
                                        });
                                    });
                                    console.log(productAttributeArr);


                                    //3.组装商品SKU表的数据
                                    var productSkuArr = [];
                                    $("#addSkuTable .dataRow").each(function(){
                                        var tdArr = $(this).children();
                                        var properties = {};
                                        tdArr.each(function(i){
                                            if(i < tdArr.length - 2){
                                                properties[$(this).attr("attributeId")] = $(this).attr("valueId");
                                            }
                                        });
                                        var productSku = {};
                                        productSku.properties = JSON.stringify(properties);
                                        productSku.price = $(this).find("[name=price]").val();
                                        productSku.stock = $(this).find("[name=stock]").val();
                                        productSkuArr.push(productSku);
                                    });
                                    console.log(productSkuArr);

                                    var productInfo = {"product":updateProduct,"productAttributeList":productAttributeArr,"productSkuList":productSkuArr};

                                    //发送一个修改商品的ajax请求
                                    $.ajax({
                                        url:"<%=request.getContextPath()%>/ProductController/updateProduct.do",
                                        type:"post",
                                        data:JSON.stringify(productInfo),//【注意点！】
                                        contentType:"application/json;charset=utf-8", //【注意点！】
                                        dataType:"json",
                                        success:function(result){
                                            if(result.code == 200){
                                                //重新加载表格中的数据
                                                //search();
                                            }else{
                                                alert("修改商品失败!");
                                            }
                                        },
                                        error:function(){
                                            alert("修改商品失败!");
                                        }
                                    });

                                }
                            }
                        });
                    }
                    else{
                        alert("查询属性失败！");
                    }
                },
                error:function(){
                    alert("查询商品失败!");
                }
            });
            
        }

        function huixianSku(productSkuMap){
            console.log(productSkuMap);
            $("#addSkuTable .dataRow").each(function(){
                var tdArr = $(this).children();
                var properties = {};
                tdArr.each(function(i){
                    if(i < tdArr.length - 2){
                        properties[$(this).attr("attributeId")] = $(this).attr("valueId");
                    }
                });
                //判断拼装好的字符串 在表里是否能匹配到对应的字段
                if(productSkuMap[JSON.stringify(properties)] != null){
                    $(this).find("[name=price]").val(productSkuMap[JSON.stringify(properties)].price);
                    $(this).find("[name=stock]").val(productSkuMap[JSON.stringify(properties)].stock);
                }
            });
        }

        function initClassifySelect(pid,selectedId){
            $.ajax({
                url:"<%=request.getContextPath()%>/ClassifyController/queryClassifyListByPid.do",
                type:"get",
                data:{pid:pid},
                dataType:"json",
                //关闭异步加载  (三级联动加载顺序出错)
                async:false,
                success:function(result){
                    if(result.data.length < 1){
                        return;
                    }
                    if(result.code == 200){
                        var classifySelectHTML = "<div class='col-sm-4'><select onchange='abc(this)' name='def' style='width:100px' class='form-control'><option value='-1'>请选择</option>";
                        for(var i = 0 ; i < result.data.length ; i ++ ){
                            classifySelectHTML += "<option " + (selectedId == result.data[i].id ? "selected" : "") + " value='" + result.data[i].id + "'>" + result.data[i].name + "</option>"
                        }
                        classifySelectHTML += "</select></div>";
                        $("#updateClassifyDiv").append(classifySelectHTML);
                    }else{
                        alert("查询分类失败!");
                    }
                },
                error:function(){
                    alert("查询分类失败!");
                }
            });
        }
        
        function deleteProduct(id){
            //弹出一个确认框
            bootbox.confirm({
                title:"删除提示",
                message:"您确定要删除吗?",
                buttons:{
                    //設置確定按鈕的文字和樣式
                    confirm:{
                        label:"確認",
                        className:"btn btn-success"
                    },
                    //設置取消按鈕的文字和樣式
                    cancel:{
                        label:"取消",
                        className:"btn btn-danger"
                    }
                },
                callback:function(result){
                    //如果用户点击了确认按钮
                    if(result){
                        //发起一个删除服装的ajax请求
                        $.ajax({
                            url:"<%=request.getContextPath()%>/ProductController/deleteProduct.do",
                            type:"post",
                            data:{id:id},
                            dataType:"json",
                            success:function(result){
                                if(result.code == 200){
                                    //重新加载表格中的数据
                                    search();
                                }else{
                                    alert("删除商品失败!");
                                }
                            },
                            error:function(){
                                alert("删除商品失败!");
                            }
                        });
                    }
                }
            });
        }

        //批量删除
        function batchDeleteProduct() {
            var idCheckboxes = $("[name=id]:checked");
            if (idCheckboxes.length > 0) {
                bootbox.confirm({
                    title: "删除提示",
                    message: "您确定要删除吗?",
                    buttons: {
                        //設置確定按鈕的文字和樣式
                        confirm: {
                            label: "確認",
                            className: "btn btn-success"
                        },
                        //設置取消按鈕的文字和樣式
                        cancel: {
                            label: "取消",
                            className: "btn btn-danger"
                        }
                    },
                    callback: function (result) {
                        if (result) {
                            var idArr = [];
                            idCheckboxes.each(function () {
                                idArr.push(this.value);
                            });

                            //发起一个批量删除用户的ajax请求
                            $.ajax({
                                url: "<%=request.getContextPath()%>/ProductController/batchDeleteProduct.do",
                                type: "post",
                                data: {ids: idArr},
                                dataType: "json",
                                success: function (result) {
                                    if (result.code == 200) {
                                        //重新加载表格中的数据
                                        search();
                                    } else {
                                        alert("批量删除用户失败!");
                                    }
                                },
                                error: function () {
                                    alert("批量删除用户失败!");
                                }
                            });
                        }
                    }
                });

            } else {
                alert("请先选择要删除的用户!");
            }
        }


    </script>
</head>
<body>

    <!--修改商品的DIV-->
    <div id="updateProductDiv" style="display: none">
        <!--修改商品的form表单-->
        <form id="updateProductForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">商品名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateName" placeholder="请输⼊商品名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品标题</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updateTitle">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品价格</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="updatePrice">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">上下架状态</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateStatus" value="1"> 上架
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateStatus" value="2"> 下架
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">是否热销</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="updateIsHot" value="1"> 是
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="updateIsHot" value="2"> 否
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品品牌</label>
                <div class="col-sm-10">
                    <select id="updateBrandSelect" class="form-control">
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品分类</label>
                <div class="col-sm-10" id="updateClassifyDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品关键属性(SPU)</label>
                <div class="col-sm-10" id="updateSpuAttributeDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品销售属性(SKU)</label>
                <div class="col-sm-10" id="updateSkuAttributeDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label"></label>
                <div class="col-sm-10" id="updateSkuTableDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品主图</label>
                <div class="col-sm-10">
                    <!-- 用于存放上传的图片相对路径的隐藏域 -->
                    <input type="text" id="updateFilePath" />
                    <img src="" id="updateFileImg" width="50" height="50">
                    <input type="file" class="form-control" name="file" id="updateFile">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品描述</label>
                <div class="col-sm-10">
                    <textarea id="updateRemark"></textarea>
                </div>
            </div>
        </form>
    </div>

    <!--新增商品的DIV-->
    <div id="addProductDiv" style="display: none">
        <!--新增商品的form表单-->
        <form id="addProductForm" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-2 control-label">商品名称</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addName" placeholder="请输⼊商品名称">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品标题</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addTitle">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品价格</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="addPrice">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">上下架状态</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addStatus" value="1"> 上架
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addStatus" value="2"> 下架
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">是否热销</label>
                <div class="col-sm-10">
                    <label class="radio-inline">
                        <input type="radio" name="addIsHot" value="1"> 是
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="addIsHot" value="2"> 否
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品品牌</label>
                <div class="col-sm-10">
                    <select id="addBrandSelect" class="form-control">
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品分类</label>
                <div class="col-sm-10" id="addClassifyDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品关键属性(SPU)</label>
                <div class="col-sm-10" id="addSpuAttributeDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品销售属性(SKU)</label>
                <div class="col-sm-10" id="addSkuAttributeDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label"></label>
                <div class="col-sm-10" id="addSkuTableDiv">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品主图</label>
                <div class="col-sm-10">
                    <!-- 用于存放上传的图片相对路径的隐藏域 -->
                    <input type="text" id="addFilePath" />
                    <input type="file" class="form-control" name="file" id="addFile">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">商品描述</label>
                <div class="col-sm-10">
                    <textarea id="addRemark"></textarea>
                </div>
            </div>
        </form>
    </div>

    <!-- 引入导航栏 -->
    <jsp:include page="../common/nav.jsp" />

    <!-- 查询条件面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                条件查询
            </h3>
        </div>
        <div class="panel-body">
            <form class="form-horizontal" role="form" id="userQueryForm">
                <div class="container">

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">商品名称:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" name="name" id="name" placeholder="请输⼊商品名称">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">状态:</label>
                                <div class="col-sm-10">
                                    <label class="radio-inline">
                                        <input type="radio" name="status" value="1"> 上架
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="status" value="2"> 下架
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12" style="text-align:center">
                            <button type="button" class="btn btn-primary" onclick="search()">
                                <span class="glyphicon glyphicon-search"></span>&nbsp;查询
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

    <!--商品展示列表面板 -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                商品展示
            </h3>
        </div>
        <div class="panel-body">
            <div style="margin-bottom:10px">
                <button onclick="showAddProductDialog()" type="button" class="btn btn-primary">
                    <span class="glyphicon glyphicon-plus"></span>&nbsp;新增
                </button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button onclick="batchDeleteProduct()" type="reset" class="btn btn-danger">
                    <span class="glyphicon glyphicon-minus"></span>&nbsp;批量删除
                </button>
            </div>

            <table id="productTable" class="table table-striped table-bordered table-hover table-condensed">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox"/>
                    </th>
                    <th>商品名称</th>
                    <th>商品标题</th>
                    <th>品牌名称</th>
                    <th>状态</th>
                    <th>是否热销</th>
                    <th>商品价格</th>
                    <th>商品主题</th>
                    <th>商品描述</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</body>
</html>
