package com.fh.util;

import com.lowagie.text.DocumentException;
import com.lowagie.text.pdf.BaseFont;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.xhtmlrenderer.pdf.ITextRenderer;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.Map;
import java.util.UUID;

public class FreemarkerUtil {

    /**
     * 生成Word文件
     * @param dataMap
     * @param templateName
     * @param templateFolderName
     * @return
     */
    public static File generateWord(Map<String,Object> dataMap, String templateName, String templateFolderName, HttpServletRequest request) throws IOException, TemplateException {
        //1.创建一个配置实例
        Configuration cfg = new Configuration();
        //2.设置模板文件所在的目录
        cfg.setClassForTemplateLoading(FreemarkerUtil.class,templateFolderName);
        //3.设置字符编码集
        cfg.setDefaultEncoding("UTF-8");
        //4.获取模板文件
        Template template = cfg.getTemplate(templateName,"UTF-8");
        //5.创建一个Writer对象
        //获取项目发布在tomcat下的绝对路径
        String realPath = request.getServletContext().getRealPath("/");
        File file = new File(realPath + "/" + UUID.randomUUID() + ".doc");
        OutputStream os = new FileOutputStream(file);
        Writer writer = new OutputStreamWriter(os,"UTF-8");
        //6.将数据填充到对应的模板文件中并输出内容到指定的文件中
        template.process(dataMap,writer);
        writer.close();
        os.close();
        return file;
    }


    /**
     * 生成pdf文件
     * @param dataMap
     * @param templateName
     * @param templateFolderName
     * @param request
     * @return
     */
    public static File generatePdf(Map<String,Object> dataMap, String templateName, String templateFolderName, HttpServletRequest request) throws IOException, TemplateException, DocumentException {
        //1.创建一个配置实例
        Configuration cfg = new Configuration();
        //2.设置模板文件所在的目录
        cfg.setClassForTemplateLoading(FreemarkerUtil.class,templateFolderName);
        //3.设置字符编码集
        cfg.setDefaultEncoding("utf-8");
        //4.获取模板文件
        Template template = cfg.getTemplate(templateName, "utf-8");
        //5.创建一个Writer对象
        //获取项目发布在tomcat下的绝对路径
        Writer writer = new StringWriter();
        //6.将数据填充到对应的模板文件中并输出内容到Writer对象中
        template.process(dataMap,writer);
        //7.从Writer对象中获取文件内容
        String fileContent = writer.toString();
        //8.创建一个PDF渲染器
        ITextRenderer renderer = new ITextRenderer();
        //9.设置字体，目前支持宋体和黑体，这一步是必须的，否则生成的pdf文件中不显示中文
        renderer.getFontResolver().addFont("template/simsun.ttc", BaseFont.IDENTITY_H,BaseFont.EMBEDDED);
        //10.将文件内容放入到PDF渲染器中
        renderer.setDocumentFromString(fileContent);
        //11.调用PDF渲染器的layout方法
        renderer.layout();
        //12.创建PDF文件
        String realPath = request.getServletContext().getRealPath("/");
        File file = new File(realPath + "/" + UUID.randomUUID() + ".pdf");
        OutputStream os = new FileOutputStream(file);
        renderer.createPDF(os,false);
        renderer.finishPDF();
        writer.close();
        os.close();
        return file;
    }
}
