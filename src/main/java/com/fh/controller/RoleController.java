package com.fh.controller;

import com.fh.model.DataTableResult;
import com.fh.model.Role;
import com.fh.model.RoleQuery;
import com.fh.service.RoleService;
import com.fh.util.ExcelUtil;
import com.fh.util.FileUtil;
import com.fh.util.FreemarkerUtil;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping("RoleController")
public class RoleController {

    @Autowired
    private RoleService roleService;

    //跳转到角色展示页面
    @RequestMapping("toRoleList")
    public String toUserList(){
        return "role/role-list";
    }

    //---------------------------------------导出PDF-----------------------------------------------------

    @RequestMapping("exportPdf")
    public void exportPdf(RoleQuery roleQuery, HttpServletResponse response,HttpServletRequest request){
        try {
            //1.根据查询条件查询出符合条件的角色集合
            List<Role> roleList = roleService.queryRoleListNoPage(roleQuery);
            Map<String,Object> dataMap = new HashMap<>();
            dataMap.put("roleList",roleList);
            //2.调用FreemarkerUtil工具类的生成pdf文件方法得到一个pdf文件
            File file = FreemarkerUtil.generatePdf(dataMap,"role-pdf.ftl","/template",request);
            //3.调用FileUtil工具类中的下载文件方法
            FileUtil.downloadFile(file,"角色列表.pdf",request,response);
            //4.将服务器上生成的word文件删除掉
            file.delete();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }    //---------------------------------------导出Word-----------------------------------------------------

    @RequestMapping("exportWord")
    public void exportWord(RoleQuery roleQuery,HttpServletResponse response,HttpServletRequest request){
        try {
            //1.根据查询条件查询出符合条件的角色集合
            List<Role> roleList = roleService.queryRoleListNoPage(roleQuery);
            Map<String,Object> dataMap = new HashMap<>();
            dataMap.put("roleList",roleList);
            //2.调用FreemarkerUtil工具类的生成word文件方法得到一个word文件
            File file = FreemarkerUtil.generateWord(dataMap,"role-word.ftl","/template",request);
            //3.调用FileUtil工具类中的下载文件方法
            FileUtil.downloadFile(file,"角色列表.doc",request,response);
            //4.将服务器上生成的word文件删除掉
            file.delete();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //---------------------------------------导出Excel--------------------------------------------------


    //freemarker导出Excel
    @RequestMapping("freemarkerExportExcel")
    public static void main(String[] args) {
        //1.创建一个配置实例
        Configuration cfg = new Configuration();
        //2.设置模板文件所在的目录
        cfg.setClassForTemplateLoading(RoleController.class,"/template");
        //3.设置字符集
        cfg.setDefaultEncoding("UTF-8");
        try {
            //4.获取模板文件
            Template template = cfg.getTemplate("zhangxuhao.ftl", "utf-8");
            //5.创建数据模型
            Map<String,Object> dataMap = new HashMap<>();
            List<Role> roleList = new ArrayList<>();
            for( int i = 0; i < roleList.size(); i ++ ){
                Role role = new Role();
                role.setId(roleList.get(i).getId());
                role.setName(roleList.get(i).getName());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    //导出Excel
    @RequestMapping("exportExcel")
    public void exportExcel(RoleQuery roleQuery, HttpServletRequest request, HttpServletResponse response){
        //1.根据查询条件查询出符合条件的角色信息
        List<Role> roleList = roleService.queryRoleListNoPage(roleQuery);
        //2.创建一个工作簿
        XSSFWorkbook workbook = new XSSFWorkbook();
        //3.在工作簿中创建一张工作表
        XSSFSheet sheet = workbook.createSheet("角色列表");
        //4.在工作表中创建一个表头行
        XSSFRow headerRow = sheet.createRow(0);
        String[] headerNameArr = {"角色id","角色名称","角色状态","描述","创建日期","修改日期"};
        int[] headerWidthArr = {9*256,20*256,10*256,50*256,30*256,30*256};
        for(int i = 0 ; i < headerNameArr.length ; i ++ ){
            XSSFCell headerCell = headerRow.createCell(i);
            headerCell.setCellValue(headerNameArr[i]);
            sheet.setColumnWidth(i,headerWidthArr[i]);
        }

        //创建一个日期格式的单元格样式
        XSSFCellStyle cellStyle = workbook.createCellStyle();
        XSSFDataFormat format= workbook.createDataFormat();
        cellStyle.setDataFormat(format.getFormat("yyyy年MM月dd日 HH:mm:ss"));

        //5.遍历角色集合，循环创建数据行
        for(int i = 0 ; i < roleList.size() ; i ++ ){
            Role role = roleList.get(i);
            //创建数据行
            XSSFRow dataRow = sheet.createRow(i + 1);
            //创建数据行中的每一个单元格
            XSSFCell roleIdCell = dataRow.createCell(0);
            roleIdCell.setCellValue(role.getId());
            XSSFCell roleNameCell = dataRow.createCell(1);
            roleNameCell.setCellValue(role.getName());
            XSSFCell statusCell = dataRow.createCell(2);
            statusCell.setCellValue(role.getStatus()==1?"启用":"禁用");
            XSSFCell remarkCell = dataRow.createCell(3);
            remarkCell.setCellValue(role.getRemark());
            XSSFCell createDateCell = dataRow.createCell(4);
            createDateCell.setCellValue(role.getCreateDate());
            createDateCell.setCellStyle(cellStyle);
            XSSFCell updateDateCell = dataRow.createCell(5);
            updateDateCell.setCellValue(role.getUpdateDate());
            updateDateCell.setCellStyle(cellStyle);
        }

        //6.调用工具类中下载excel文件方法
        ExcelUtil.excelDownload(workbook,request,response, UUID.randomUUID().toString() + ".xlsx");
    }


    //导入Excel
    @RequestMapping("importExcel")
    @ResponseBody
    public Map<String,Object> importExcel(@RequestParam("file") MultipartFile file){
        Map<String,Object> result = new HashMap<>();
        try {
            //将用户上传的Excel文件封装成一个工作簿
            XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream());
            int number = workbook.getNumberOfSheets();
            for(int i = 0 ; i < number ; i ++){
                XSSFSheet sheet = workbook.getSheetAt(i);
                int firstRowNum = sheet.getFirstRowNum();
                int lastRowNum = sheet.getLastRowNum();
                List<Role> roleList = new ArrayList<>();
                for (int j = firstRowNum + 1 ; j <= lastRowNum ; j ++ ) {
                    XSSFRow row = sheet.getRow(j);
                    String roleName = row.getCell(1).getStringCellValue();
                    String status = row.getCell(2).getStringCellValue();
                    String remark = row.getCell(3).getStringCellValue();

                    Role role = new Role();
                    role.setName(roleName);
                    role.setStatus(StringUtils.isNotBlank(status)?status.equals("启用")?1:2:null);
                    role.setRemark(remark);
                    roleList.add(role);
                }
                roleService.batchAddRole(roleList);
            }
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //----------------------------------------角色增删改查-----------------------------------------------

    //分页条件查询角色信息
    @RequestMapping("queryRoleList")
    @ResponseBody
    public DataTableResult queryRoleList(RoleQuery roleQuery){
        DataTableResult dataTableResult = roleService.queryRoleList(roleQuery);
        return dataTableResult;
    }

    //新增角色
    @RequestMapping("addRole")
    @ResponseBody
    public Map<String,Object> addRole(Role role){
        Map<String,Object> result = new HashMap<>();
        try {
            roleService.addRole(role);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //修改角色
    @RequestMapping("updateRole")
    @ResponseBody
    public Map<String,Object> updateRole(Role role){
        Map<String,Object> result = new HashMap<>();
        try {
            roleService.updateRole(role);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //通过ID查询单个角色
    @RequestMapping("getRoleById")
    @ResponseBody
    public Map<String,Object> getRoleById(Integer id, HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            Role role = roleService.getRoleById(id);
            result.put("data",role);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    @RequestMapping("deleteRole")
    @ResponseBody
    public Map<String,Object> deleteRole(Integer id,HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            roleService.deleteRole(id);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    @RequestMapping("batchDeleteRole")
    @ResponseBody
    public Map<String,Object> batchDeleteRole(@RequestParam("ids[]") List<Integer> idList, HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            roleService.batchDeleteRole(idList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //修改角色状态(禁用变启用，启用变禁用)
    @RequestMapping("updateRoleStatus")
    @ResponseBody
    public Map<String,Object> updateRoleStatus(Integer id,HttpServletRequest request){
        Map<String,Object> result = new HashMap<>();
        try {
            roleService.updateRoleStatus(id);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }



    //查询所有启用角色
    @RequestMapping("queryEnableRoleList")
    @ResponseBody
    public Map<String,Object> queryEnableRoleList(){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Role> roleList = roleService.queryEnableRoleList();
            result.put("data",roleList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }
}
