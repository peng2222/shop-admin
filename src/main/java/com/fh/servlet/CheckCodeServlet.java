package com.fh.servlet;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

/**
 * <pre>项目名称：fish    
 * 类名称：CheckCodeServlet    
 * 类描述：【用于动态生成验证码的Servlet】
 * 创建人：周文卓 zhouwenzhuo@163.com    
 * 创建时间：2019-6-30 下午4:29:27    
 * 修改人：张旭浩 zhangxuhao@163.com
 * 修改时间：2019-6-30 下午4:29:27    
 * 修改备注：       
 * @version </pre>
 */
public class CheckCodeServlet extends HttpServlet {
	
	// 验证码字符集
	private static final char[] chars = { 'a','1','b','2','3','c','4','d','5','e','f','g','A','B','C','D','E','F','G' };
	// 只包括数字的验证字符集
//			private static final char[] numberChars = { '0', '1', '2', '3', '4', '5', '6',
//				'7', '8', '9' };
	
	
	// 字符数量
	private static final int SIZE = 5;
	// 干扰线数量
	private static final int LINES = 5;
	// 宽度
	private static final int WIDTH = 80;
	// 高度
	private static final int HEIGHT = 30;
	// 字体大小
	private static final int FONT_SIZE = 30;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req,resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		StringBuffer sb = new StringBuffer();
		// 1.创建空白图片
		BufferedImage image = new BufferedImage(WIDTH, HEIGHT,
				BufferedImage.TYPE_INT_RGB);
		// 2.获取图片画笔
		Graphics graphic = image.getGraphics();
		// 3.设置画笔颜色
		graphic.setColor(Color.LIGHT_GRAY);
		// 4.绘制矩形背景
		graphic.fillRect(0, 0, WIDTH, HEIGHT);
		// 5.画随机字符
		Random ran = new Random();
		for (int i = 0; i < SIZE; i++) {
			// 取随机字符索引
			int n = ran.nextInt(chars.length);
			// 设置随机颜色
			graphic.setColor(getRandomColor());
			// 设置字体大小
			graphic.setFont(new Font(null, Font.BOLD + Font.ITALIC, FONT_SIZE));
			// 画字符
			graphic.drawString(chars[n] + "", i * WIDTH / SIZE, HEIGHT * 2 / 3);
			// 记录字符
			sb.append(chars[n]);
		}
		// 6.画干扰线
		for (int i = 0; i < LINES; i++) {
			// 设置随机颜色
			graphic.setColor(getRandomColor());
			// 随机画线
			graphic.drawLine(ran.nextInt(WIDTH), ran.nextInt(HEIGHT),
					ran.nextInt(WIDTH), ran.nextInt(HEIGHT));
		}
		
		//存入session
		HttpSession session = req.getSession();
		session.setAttribute("checkCode", sb.toString());
		// 回写图片
		try {
			ImageIO.write(image, "jpg", resp.getOutputStream());
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 7.返回验证码和图片
	}
	
	/**
	 * 随机取色
	 */
	public static Color getRandomColor() {
		Random ran = new Random();
		Color color = new Color(ran.nextInt(256), ran.nextInt(256),
				ran.nextInt(256));
		return color;
	}
	
	/**
	 * 包括数字和字母
	 * @param pointNumber
	 * @return
	 */
	public static String getPointCode(int pointNumber){
		StringBuffer checkCode = new StringBuffer();
		Random ran = new Random();
		for (int i = 0; i < pointNumber; i++) {
			// 取随机字符索引
			int n = ran.nextInt(chars.length);
			// 记录字符
			checkCode.append(chars[n]);
		}
		return checkCode.toString();
	}
	
}
