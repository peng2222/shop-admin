package com.fh.test;

import com.fh.model.Role;
import com.fh.service.RoleService;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

//用于指定junit运行环境，是junit提供给其他框架测试环境接口扩展，为了便于使用spring的依赖注入
//spring提供了org.springframework.test.context.junit4.SpringJUnit4ClassRunner作为Junit测试环境
@RunWith(SpringJUnit4ClassRunner.class)
//加载配置文件
@ContextConfiguration(locations = "classpath:/applicationContext.xml")
public class PoiTest {

    @Autowired
    private RoleService roleService;

    public static void main(String[] args) throws IOException {
        //使用poi操作excel文件
        //1.创建一个工作簿(excel文件)
        XSSFWorkbook workbook = new XSSFWorkbook();
        //2.在工作簿中创建一个工作表
        XSSFSheet sheet = workbook.createSheet("我的工作表");
        //3.在工作表中创建一个新行
        XSSFRow row = sheet.createRow(0);
        //4.在新行中创建一个单元格
        XSSFCell cell = row.createCell(0);
        //5.给新的单元格赋值
        cell.setCellValue("张序号");
        XSSFRow row1 = sheet.createRow(1);
        XSSFCell cell1 = row1.createCell(1);
        cell1.setCellValue("李加薪");
        //6.将工作簿保存到指定位置
        workbook.write(new FileOutputStream("c:/User/sss.xlsx"));
    }

    @Test
    public void exportTest() throws IOException {
        //1.查询所有角色信息
        List<Role> list = roleService.queryAllRoleList();
        //2.新建一个工作簿
        XSSFWorkbook workbook = new XSSFWorkbook();
        //3.在工作簿上创建一个工作表
        XSSFSheet sheet = workbook.createSheet("角色列表");
        //4.创建一个表头
        XSSFRow row = sheet.createRow(0);
        //创建一个内容居中的单元格样式
        XSSFCellStyle cellStyle2 = workbook.createCellStyle();
        cellStyle2.setAlignment(HorizontalAlignment.CENTER);
        cellStyle2.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index);
        cellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        //设置单元格边框
        cellStyle2.setBorderRight(BorderStyle.THIN);
        cellStyle2.setRightBorderColor(HSSFColor.BLACK.index);
        cellStyle2.setBorderLeft(BorderStyle.THIN);
        cellStyle2.setLeftBorderColor(HSSFColor.BLACK.index);
        cellStyle2.setBorderTop(BorderStyle.THIN);
        cellStyle2.setTopBorderColor(HSSFColor.BLACK.index);
        cellStyle2.setBorderBottom(BorderStyle.THIN);
        cellStyle2.setBottomBorderColor(HSSFColor.BLACK.index);

        //创建一个字体
        XSSFFont font = workbook.createFont();
        //字体加粗
        font.setBold(true);
        cellStyle2.setFont(font);

        String[] headerNameArr = {"角色id","角色名称","角色状态","描述","创建日期","修改日期"};
        int[] headerWidthArr = {9*256,20*256,10*256,50*256,30*256,30*256};
        for (int i = 0 ; i< headerNameArr.length; i ++){
            XSSFCell cell = row.createCell(i);
            cell.setCellValue(headerNameArr[i]);
            cell.setCellStyle(cellStyle2);
            //设置列的宽度
            sheet.setColumnWidth(i,headerWidthArr[i]);
        }

        //5.遍历角色集合,循环创建数据行
        XSSFCellStyle cellStyle = workbook.createCellStyle();
        XSSFDataFormat format = workbook.createDataFormat();
        cellStyle.setDataFormat(format.getFormat("yyyy年MM月dd日 HH:mm:ss"));
        for (int i = 0; i < list.size(); i ++){
            Role role = list.get(i);
            XSSFRow dataRow = sheet.createRow(i + 1);
            XSSFCell dataCell = dataRow.createCell(0);
            dataCell.setCellValue(role.getId());
            XSSFCell dataCell2 = dataRow.createCell(1);
            dataCell2.setCellValue(role.getName());
            XSSFCell dataCell3 = dataRow.createCell(2);
            dataCell3.setCellValue(role.getStatus()==1?"启用":"禁用");
            XSSFCell dataCell4 = dataRow.createCell(3);
            dataCell4.setCellValue(role.getRemark());
            XSSFCell dataCell5 = dataRow.createCell(4);
            dataCell5.setCellStyle(cellStyle);
            dataCell5.setCellValue(role.getCreateDate());
            XSSFCell dataCell6 = dataRow.createCell(5);
            dataCell6.setCellStyle(cellStyle);
            dataCell6.setCellValue(role.getUpdateDate());
        }

        //6.将工作簿保存到制定文件中
        workbook.write(new FileOutputStream("c:/User/角色列表.xlsx"));
    }
}
