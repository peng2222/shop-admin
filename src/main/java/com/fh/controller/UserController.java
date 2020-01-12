package com.fh.controller;

import com.fh.common.Ignore;
import com.fh.model.DataTableResult;
import com.fh.model.Permission;
import com.fh.model.User;
import com.fh.model.UserQuery;
import com.fh.service.PermissionService;
import com.fh.service.UserService;
import com.fh.util.ExcelUtil;
import com.fh.util.FileUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.poi.xssf.usermodel.*;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("UserController")
public class UserController {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserController.class);
    @Autowired
    private UserService userService;

    @Autowired
    private PermissionService permissionService;

    //------------------------------------ Execl导入导出模块------------------------------------------------------------

    //导出Excel
    @RequestMapping("exportExcel")
    public void exportExcel(UserQuery userQuery, HttpServletRequest request,HttpServletResponse response){
        //1.根据查询条件查询出符合条件的角色信息
        List<User> userList = userService.queryUserListNoPage(userQuery);
        //2.创建一个工作簿
        XSSFWorkbook workbook = new XSSFWorkbook();
        //3.在工作簿中创建一张工作表
        XSSFSheet sheet = workbook.createSheet("用户列表");
        //4.在工作表中创建一个表头行
        XSSFRow headerRow = sheet.createRow(0);
        String[] headerNameArr = {"用户Id","真实姓名","用户姓名","用户密码","email","性别","手机号","图片路径","用户生日","创建时间","修改时间","错误次数","错误时间","登录次数","登录时间"};
        int[] headerWidthArr = {9*256,10*256,20*256,20*256,10*256,5*256,10*256,50*256,30*256,30*256,30*256,10*256,30*256,10*256,30*256};
        for (int i = 0 ; i < headerNameArr.length ; i ++){
            XSSFCell headerCell = headerRow.createCell(i);
            headerCell.setCellValue(headerNameArr[i]);
            sheet.setColumnWidth(i,headerWidthArr[i]);
        }

        //创建一个日期格式的单元格样式
        XSSFCellStyle cellStyle = workbook.createCellStyle();
        XSSFDataFormat format= workbook.createDataFormat();
        cellStyle.setDataFormat(format.getFormat("yyyy年MM月dd日 HH:mm:ss"));

        //5.遍历角色集合，循环创建数据行
        for(int i = 0;i < userList.size() ; i ++){
            User user = userList.get(i);
            //创建数据行
            XSSFRow dataRow = sheet.createRow(i + 1);
            //创建数据行中的每一个单元格
            XSSFCell userIdCell = dataRow.createCell(0);
            userIdCell.setCellValue(user.getId());

            XSSFCell realNameCell = dataRow.createCell(1);
            realNameCell.setCellValue(user.getRealName());

            XSSFCell userNameCell = dataRow.createCell(2);
            userNameCell.setCellValue(user.getUserName());

            XSSFCell passwordCell = dataRow.createCell(3);
            passwordCell.setCellValue(user.getPassWord());

            XSSFCell emailCell = dataRow.createCell(4);
            emailCell.setCellValue(user.getEmail());

            XSSFCell sexCell = dataRow.createCell(5);
            sexCell.setCellValue(user.getSex()==1?"男":"女");

            XSSFCell phoneNumberCell = dataRow.createCell(6);
            phoneNumberCell.setCellValue(user.getPhoneNumber());

            XSSFCell filePathCell = dataRow.createCell(7);
            filePathCell.setCellValue(user.getFilePath());

            XSSFCell birthdayCell = dataRow.createCell(8);
            birthdayCell.setCellValue(user.getBirthday());
            birthdayCell.setCellStyle(cellStyle);

            XSSFCell createDateCell = dataRow.createCell(9);
            createDateCell.setCellValue(user.getCreateDate());
            createDateCell.setCellStyle(cellStyle);

            XSSFCell updateDateCell = dataRow.createCell(10);
            updateDateCell.setCellValue(user.getUpdateDate());
            updateDateCell.setCellStyle(cellStyle);

            XSSFCell errorCountCell = dataRow.createCell(11);
            errorCountCell.setCellValue(user.getErrorCount());

            XSSFCell errorTimeCell = dataRow.createCell(12);
            errorTimeCell.setCellValue(user.getErrorTime());
            errorTimeCell.setCellStyle(cellStyle);

            XSSFCell loginCountCell = dataRow.createCell(13);
            loginCountCell.setCellValue(user.getLoginCount());

            XSSFCell loginTimeCell = dataRow.createCell(14);
            loginTimeCell.setCellValue(user.getLoginTime());
            loginTimeCell.setCellStyle(cellStyle);

        }

        //6.调用工具类中下载excel文件方法
        ExcelUtil.excelDownload(workbook,request,response, UUID.randomUUID().toString() + ".xlsx");
    }


    //导入Excel
    @RequestMapping("importExcel")
    @ResponseBody
    public Map<String,Object> importExcel(@RequestParam("file")MultipartFile file){
        Map<String,Object> result = new HashMap<>();
        try {
            //将用户上传的Excel文件封装成一个工作簿
            XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream());
            //获取工作簿中工作表的数量
            int number = workbook.getNumberOfSheets();
            for (int i = 0; i < number ; i++ ) {
                //获取当前循环下标对应的工作表
                XSSFSheet sheet = workbook.getSheetAt(i);
                //获取当前工作表中第一行的下标
                int firstRowNum = sheet.getFirstRowNum();
                //获取当前工作表中最后一行的下标
                int lastRowNum = sheet.getLastRowNum();
                List<User> userList = new ArrayList<>();
                for (int j = firstRowNum + 1 ; j <= lastRowNum ; j ++ ) {
                    //获取当前循环下标对应的行
                    XSSFRow row = sheet.getRow(j);
                    //获取当前行每一个单元格的值
                    //第一个是Id不用获取 下标为0
                    String realName = row.getCell(1).getStringCellValue();
                    String userName = row.getCell(2).getStringCellValue();
                    String password = row.getCell(3).getStringCellValue();
                    String email = row.getCell(4).getStringCellValue();
                    String sex = row.getCell(5).getStringCellValue();
                    String phoneNumber = row.getCell(6).getStringCellValue();
                    String filePath = row.getCell(7).getStringCellValue();
                    Date birthday = row.getCell(8).getDateCellValue();
                    double errorCount = row.getCell(11).getNumericCellValue();
                    Date errorTime = row.getCell(12).getDateCellValue();
                    double loginCount = row.getCell(13).getNumericCellValue();
                    Date loginTime = row.getCell(14).getDateCellValue();

                    User user = new User();
                    user.setRealName(realName);
                    user.setUserName(userName);
                    user.setPassWord(password);
                    user.setEmail(email);
                    user.setSex(StringUtils.isNotBlank(sex)?sex.equals("男")?1:2:null);
                    user.setPhoneNumber(phoneNumber);
                    user.setFilePath(filePath);
                    user.setBirthday(birthday);
                    user.setErrorCount((int)errorCount);
                    user.setErrorTime(errorTime);
                    user.setLoginCount((int)loginCount);
                    user.setLoginTime(loginTime);

                    userList.add(user);
                }
                userService.batchAddUser(userList);
            }
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }


    //------------------------------------ 用户登录模块------------------------------------------------------------

    //用户登录
    @RequestMapping("login")
    @ResponseBody
    @Ignore
    public Map<String,Object> login(String username, String password, String checkCode, HttpSession session){
        Map<String,Object> result = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        LOGGER.info("{}在{}时候进行了登录操作",username,sdf.format(new Date()));
        LOGGER.debug("登录的用户名为{}",username);
        try {
            /*//判断验证码是否为空
            if(StringUtils.isNotBlank(checkCode)){
                //判断用户输入的验证码和session对象中的验证码是否一致
                String sessionCheckCode = session.getAttribute("checkCode").toString();
                //equalsIgnoreCase 不区分大小写比较两个字符串是否相等
                if(sessionCheckCode.equalsIgnoreCase(checkCode)){*/
                    //判断用户是否存在
                    User user = userService.getUserByName(username);
                    //如果用户存在的话
                    if(user != null){

                        //判断该用户上次登录失败时间距离系统当前时间是否已超过24小时
                        //如果超过24小时则解锁该用户(将用户登录错误次数和登录错误时间置空)！
                        if(user.getErrorTime() != null && (System.currentTimeMillis() - user.getErrorTime().getTime()) >= 24 * 60 * 60 * 1000){
                            user.setErrorCount(null);
                            user.setErrorTime(null);
                            userService.updateUserErrorCountAndErrorTime(user);
                        }

                        //如果用户登录错误次数为null或登录错误次数小于3
                        if(user.getErrorCount() == null || user.getErrorCount() < 3){
                            //判断密码是否正确
                            if (user.getPassWord().equals(password)){

                                //如果用户登录成功时间为空
                                if(user.getLoginTime() == null){
                                    user.setLoginCount(1);
                                    user.setLoginTime(new Date());
                                }else{
                                    //判断用户本次登录时间和上次登录时间是否为同一天
                                    //isSameDay用于判断两个日期是否在同一天，如果在返回true，否则返回false
                                    if(DateUtils.isSameDay(user.getLoginTime(),new Date())){
                                         user.setLoginCount(user.getLoginCount()+1);
                                         user.setLoginTime(new Date());
                                    }else{
                                        user.setLoginCount(1);
                                        user.setLoginTime(new Date());
                                    }
                                }

                                //更新用户的登录成功次数和登录成功时间
                                userService.updateUserLoginCountAndUserLoginTime(user);

                                //查询后台管理系统所有权限的集合
                                List<Permission> allPermissionList = permissionService.queryPermissionList();
                                //将后台管理系统所有权限的集合放入session对象中
                                session.setAttribute("allPermissionList",allPermissionList);

                                //查询当前登录用户所拥有的权限集合
                                List<Permission> permissionList = permissionService.queryPermissionListByUserId(user.getId());
                                //将当前登录用户所拥有的权限集合放入session对象中
                                session.setAttribute("permissionList",permissionList);

                                //查询当前登录用户所用的菜单权限集合
                                List<Permission> menuPermissionList = permissionService.queryMenuPermissionListByUserId(user.getId());
                                //将当前登录用户所拥有的菜单权限集合放入session对象中
                                session.setAttribute("menuPermissionList",menuPermissionList);

                                //登录成功
                                result.put("code",5);
                                //将用户对象放入session对象中
                                session.setAttribute("user",user);
                            }else{
                                //记录用户登录错误次数
                                user.setErrorCount(user.getErrorCount()==null?1:user.getErrorCount()+1);
                                //记录用户登录错误时间
                                user.setErrorTime(new Date());
                                userService.updateUserErrorCountAndErrorTime(user);
                                //密码不正确
                                result.put("code",4);
                            }

                        }else{
                            //用户被锁定
                            result.put("code",6);
                        }
                    }else{
                        //用户不存在
                        result.put("code",3);
                    }
                /*}else{
                    //验证码错误
                    result.put("code",2);
                }
            }else{
                //验证码为空
                result.put("code",1);
            }*/
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    //跳转到商品后台管理系统的主页面
    @RequestMapping("toIndex")
    public String toIndex(){
        return "index";
    }


    @RequestMapping("loginOut")
    public String loginOut(HttpSession session){
        //用户注销同时清空session
        session.invalidate();
        return "redirect:/login.jsp";
    }


    //------------------------------------增删改查图片上传------------------------------------------------------------


    //跳转到用户展示页面
    @RequestMapping("toUserList")
    public String toUserList() {
        return "user/user-list";
    }

    //分页条件查询用户信息
    @RequestMapping("queryUserList")
    @ResponseBody
    public DataTableResult queryUserList(UserQuery userQuery) {
        DataTableResult dataTableResult = userService.queryUserList(userQuery);
        return dataTableResult;
    }

    //上传用户图片
    @RequestMapping("uploadFile")
    @ResponseBody
    public Map<String,Object> uploadFile(@RequestParam("file") MultipartFile file, HttpServletRequest request){
        Map<String,Object> result = new HashMap();
        try {
            String filePath = FileUtil.uploadFile(request,file,"/ss");
            result.put("filePath",filePath);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("用户上传图片时发生异常，异常信息为{}",e);
            result.put("code",500);
        }
        return result;
    }

    //新增用户
    @RequestMapping("addUser")
    @ResponseBody
    public Map<String,Object> addUser(User user){
        Map<String,Object> result = new HashMap<>();
        try {
            userService.addUser(user);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("用户在添加用户信息时发生异常，异常信息为{}",e);
            result.put("code",500);
        }
        return result;
    }

    //修改用户
    @RequestMapping("updateUser")
    @ResponseBody
    public Map<String,Object> updateUser(User user){
        Map<String,Object> result = new HashMap<>();
        try {
            userService.updateUser(user);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("用户在修改用户信息时发生异常，异常信息为{}",e);
            result.put("code",500);
        }
        return result;
    }

    //通过ID查询单个用户
    @RequestMapping("getUserById")
    @ResponseBody
    public Map<String,Object> getUserById(Integer id,HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            User user = userService.getUserById(id);
            result.put("data",user);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("用户在查询单个用户信息时候发生异常，异常信息为{}",e);
            result.put("code",500);
        }
        return result;
    }

    //删除用户
    @RequestMapping("deleteUser")
    @ResponseBody
    public Map<String,Object> deleteUser(Integer id,HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            //如果该用户之前上传过图片，则把图片删除掉
            User oldUser = userService.getUserById(id);
            if(StringUtils.isNotBlank(oldUser.getFilePath())){
                FileUtil.deleteFile(request,oldUser.getFilePath());
            }
            userService.deleteUser(id);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("用户在删除用户信息时发生异常，异常信息为{}",e);
            result.put("code",500);
        }
        return result;
    }

    //批量删除用户
    @RequestMapping("batchDeleteUser")
    @ResponseBody
    public Map<String,Object> batchDeleteUser(@RequestParam("ids[]") List<Integer> idList, HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            List<User> userList = userService.queryUserListByIds(idList);
            for(User user : userList){
                if(StringUtils.isNotBlank(user.getFilePath())){
                    FileUtil.deleteFile(request,user.getFilePath());
                }
            }
            userService.batchDeleteUser(idList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("用户在进行批量删除操作时发生异常，异常信息为{}",e);
            result.put("code",500);
        }
        return result;
    }
}
